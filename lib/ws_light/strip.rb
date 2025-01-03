if FAKE_SPI
  require 'ws_light/fake_spi/spi_color'
else
  require 'spi'
end

require 'ws_light/color'
require 'pp'
require 'date'
require 'json'
require 'open-uri'

require 'ws_light/animation/slide_left_animation'
require 'ws_light/animation/slide_right_animation'
require 'ws_light/animation/fade_animation'

require 'ws_light/set/color_set'
require 'ws_light/set/gradient_set'
require 'ws_light/set/flowerbed_set'
require 'ws_light/set/random_set'
require 'ws_light/set/rainbow_set'
require 'ws_light/set/strawberry_set'
require 'ws_light/set/watermelon_set'
require 'ws_light/set/semolina_set'
require 'ws_light/set/star_set'
require 'ws_light/set/lgbtqia_flag_set'


require 'ws_light/set/weather/cloudy_set'
require 'ws_light/set/weather/fair_set'
require 'ws_light/set/weather/rain_set'
require 'ws_light/set/weather/sunny_set'

# Ideas
# - Fire?
# Config file

module WSLight
  # Controls the led strip
  class Strip
    attr_accessor :direction, :last_event, :state, :current_set, :debug

    LENGTH = 160
    TYPE = :double
    FULL_LENGTH = 320

    SPECIAL_SETS = [
      Set::RainbowSet,
      Set::RandomSet,
      Set::StrawberrySet,
      Set::WatermelonSet,
      Set::SemolinaSet,
      Set::FlowerbedSet
    ].freeze

    # SPECIAL_SETS = [
    #   Set::RainSet,
    #   Set::FairSet,
    #   Set::SunnySet,
    #   Set::CloudySet
    # ].freeze

    TIMEOUT = 12

    WEATHER_URL = 'http://api.openweathermap.org/data/2.5/weather?q=Hannover,de'.freeze

    FRAMES_PER_SECOND = 25

    def initialize
      if FAKE_SPI
        @spi = SPI.new
      else
        @spi = SPI.new(device: '/dev/spidev0.0')
      end
      @spi.speed = 500_000
      
      # self_test
      @listen_thread = Thread.new { loop { check_timer; sleep 0.5; } }
      @background_thread = Thread.new {}
      @last_event = Time.now - 3600 # set last event to a longer time ago
      @state = :state_off
      @debug = false
      @current_set = Set::ColorSet.new
      @current_set.color = Color.new(0, 0, 0)
    end

    def on(direction)
      @last_event = Time.now
      puts "triggered event 'on': #{last_event.to_f} from state #{@state}" if @debug
      @state = :state_starting_up if @state == :state_shutting_down
      return if @state != :state_off

      puts 'Loading a new set...' if @debug

      @direction = direction
      @state = :state_starting_up

      set = choose_set

      puts "Set #{set.class}" if @debug
      
      animation = animation_for(direction).new(@current_set, set)

      animate(animation)
      @current_set = set

      @state = :state_on

      # Move show() into background, so we can accept new events on the main thread
      @background_thread.kill if @background_thread.alive?
      @background_thread = Thread.new { show(@current_set, animation.frames) }
    end

    def on_with_color(color)
      @last_event = Time.now
      @previous_set = @current_set
      set = Set::ColorSet.new
      set.color = color
      @current_set = set

      @state = :state_on

      # Move show() into background, so we can accept new events on the main thread
      @background_thread.kill if @background_thread.alive?
      @background_thread = Thread.new { show(@current_set, 50) }
    end

    def previous_set
      @current_set = @previous_set
      @background_thread.kill if @background_thread.alive?
      @background_thread = Thread.new { show(@current_set, 50) }
    end

    def off(direction = nil)
      puts "triggered event 'off': #{Time.now.to_f} during state #{@state}" if @debug
      return if @state != :state_on

      @state = :state_shutting_down
      sleep 0.2
      @direction = direction if direction

      set = Set::ColorSet.new
      set.color = Color.by_name :black

      animation = animation_for(@direction).new(@current_set, set)

      if animate(animation)
        @state = :state_off
        @current_set = set
      else
        @state = :state_on
        @background_thread.kill if @background_thread.alive?
        @background_thread = Thread.new { show(@current_set, animation.frames) }
      end

      puts "finished shutting off: #{Time.now.to_f}" if @debug
    end

    def choose_set
      return Set::StarSet.new if night?

      return SPECIAL_SETS.sample.new if rand(8).zero?

      return Set::LGBTQIAFlagSet.new if rand(2).zero?

      set = Set::GradientSet.new
      set.color_from = Color.random_from_set
      set.color_to = Color.random_from_set
      set
    end

    def animation_for(direction)
      return Animation::FadeAnimation if night?

      if direction == :direction_left
        Animation::SlideLeftAnimation
      else
        Animation::SlideRightAnimation
      end
    end

    def animate(animation)
      current_frame = 0
      beginning_state = @state

      animation.frames.times do |i|
        write(animation.frame_data(current_frame = i))
        sleep(1.0 / animation.frames_per_second) if animation.frames_per_second
        break if @state != beginning_state # Reverse shutting off when a new event is triggered
      end

      # This is run when the animation is reversed
      if (current_frame + 1) < animation.frames
        current_frame.times do |i|
          write(animation.frame_data(current_frame - i - 1))
          sleep(1.0 / animation.frames_per_second) if animation.frames_per_second
        end
        false
      else
        true
      end
    end

    def show(set, start_frame = 0)
      current_state = @state
      i = start_frame
      while @state == current_state
        write(set.frame_data)
        sleep 1.0 / FRAMES_PER_SECOND.to_f
        i += 1
      end
    end

    def night?
      time = Time.now
      time.hour > 22 || time.hour < 6
    end

    def shutdown
      write([0, 0, 0] * FULL_LENGTH)
    end

    def self_test
      write([0, 0, 255] * FULL_LENGTH)
      sleep 1
      write([0, 255, 0] * FULL_LENGTH)
      sleep 1
      write([255, 0, 0] * FULL_LENGTH)
      sleep 1
      write([0, 0, 0] * FULL_LENGTH)
    end

    def check_timer
      write([0, 0, 0] * FULL_LENGTH) if @state == :state_off
      off if timeout?
    end

    def timeout?
      @last_event < (Time.now - TIMEOUT)
    end

    def write(data)
      @spi.xfer(txdata: data)
    end
  end
end
