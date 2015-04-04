require 'ws2801'
require 'ws_light/color'
require 'pp'

require 'ws_light/animation/animation_slide_left'
require 'ws_light/animation/animation_slide_right'

require 'ws_light/set/color_set'
require 'ws_light/set/gradient_set'
require 'ws_light/set/random_set'
require 'ws_light/set/rainbow_set'
require 'ws_light/set/strawberry_set'
require 'ws_light/set/watermelon_set'
require 'ws_light/set/semolina_set'

# Ideas
# - Stars
# - Fire?
# - 

module WSLight
  # Controls the led strip
  class Strip
    attr_accessor :direction, :last_event, :state, :current_set, :debug

    LENGTH = 160
    TYPE = :double

    DIRECTION_NONE = 0
    DIRECTION_LEFT = 1
    DIRECTION_RIGHT = 2
    TIMEOUT = 12

    STATE_OFF = :state_off
    STATE_ON = :state_on
    STATE_STARTING_UP = :state_starting_up
    STATE_SHUTTING_DOWN = :state_shutting_down

    FRAMES_PER_SECOND = 25

    def initialize
      WS2801.length(Strip::TYPE == :double ? Strip::LENGTH * 2 : Strip::LENGTH)
      WS2801.autowrite(true)
      self_test
      @listen_thread = Thread.new { while true do check_timer; sleep 0.5; end }
      @last_event = Time.now - 3600 # set last event to a longer time ago
      @state = STATE_OFF
      @debug = false
      @current_set = Set::ColorSet.new
      @current_set.color = Color.by_name :black
    end

    def on(direction)
      @last_event = Time.now
      puts "triggered event 'on': #{last_event.to_f} from state #{@state}" if @debug
      @state = STATE_STARTING_UP if @state == STATE_SHUTTING_DOWN
      return if @state != STATE_OFF

      puts 'Loading a new set...' if @debug

      @direction = direction
      @state = STATE_STARTING_UP

      case rand(100)
      when 0..3
        set = Set::RainbowSet.new
      when 4..6
        set = Set::RandomSet.new
      when 7..9
        set = Set::StrawberrySet.new
      when 10..12
        set = Set::WatermelonSet.new
      when 13..15
        set = Set::SemolinaSet.new
      else
        set = Set::GradientSet.new
        set.color_from = Color.random_from_set
        set.color_to = Color.random_from_set
      end

      puts "Set #{set.class}" if @debug

      animation = animation_for(direction).new(@current_set, set)

      animate(animation)
      @current_set = set

      @state = STATE_ON

      # Move show() into background, so we can accept new events on the main thread
      Thread.new { show(@current_set, animation.frames) }
    end

    def off(direction = nil)
      puts "triggered event 'off': #{Time.now.to_f} during state #{@state}" if @debug
      return if @state != STATE_ON

      @state = STATE_SHUTTING_DOWN
      sleep 0.2
      @direction = direction if direction

      set = Set::ColorSet.new
      set.color = Color.by_name :black

      animation = animation_for(@direction).new(@current_set, set)

      if animate(animation)
        @state = STATE_OFF
        @current_set = set
      else
        @state = STATE_ON
      end

      puts "finished shutting off: #{Time.now.to_f}" if @debug
    end

    def animation_for(direction)
      if direction == DIRECTION_LEFT
        Animation::AnimationSlideLeft
      else
        Animation::AnimationSlideRight
      end
    end

    def animate(animation)
      current_frame = 0
      beginning_state = @state

      animation.frames.times do |i|
        WS2801.strip(animation.frame_data(current_frame = i))
        WS2801.write
        sleep (1.0/animation.frames_per_second) if animation.frames_per_second
        break if @state != beginning_state # Reverse shutting off when a new event is triggered
      end

      # This is run when the animation is reversed
      if (current_frame + 1) < animation.frames
        current_frame.times do |i|
          WS2801.strip(animation.frame_data(current_frame - i - 1))
          WS2801.write
          sleep (1.0/animation.frames_per_second) if animation.frames_per_second
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
        WS2801.strip(set.frame_data)
        WS2801.write
        sleep 1.0/FRAMES_PER_SECOND.to_f
        i += 1
      end
    end

    def shutdown
      WS2801.set(r: 0, g: 0, b: 0)
    end

    def self_test
      WS2801.set(r: 0, g: 0, b: 255)
      sleep 1
      WS2801.set(r: 0, g: 255, b: 0)
      sleep 1
      WS2801.set(r: 255, g: 0, b: 0)
      sleep 1
      WS2801.set(r: 0, g: 0, b: 0)
    end

    def check_timer
      WS2801.set(r: 0, g: 0, b: 0) if @state == STATE_OFF
      off if timeout?
    end

    def timeout?
      @last_event < (Time.now - TIMEOUT)
    end
  end
end
