#!/usr/bin/env ruby

require 'ws2801'
require 'pi_piper'
require 'timeout'

include PiPiper

# TODO
# - cancel led shut off when new motion is detected
# - add farbverlauf
# - use color presets


COLORS = {
	pink: { r: 255, g: 16, b:32 },
	red: { r: 255, g: 0, b: 0},
	blue: { r: 0, g: 0, b: 255},
	green: { r: 0, g: 255, b: 0},
	cyan: { r: 0, g: 127, b: 127}
}

class Color
	attr_accessor :r, :g, :b

	def initialize(r=0, g=0, b=0)
		@r = r
		@g = g
		@b = b
	end

	def self.random
		Color.new(rand(192), rand(192), rand(192))
	end
end

class Strip

	attr_accessor :direction, :last_event, :is_on

	LENGTH = 320
	DIRECTION_NONE = 0
	DIRECTION_LEFT = 1
	DIRECTION_RIGHT = 2
	TIMEOUT = 12

	def initialize
		WS2801.length(Strip::LENGTH)
		WS2801.autowrite(true)
		@listen_thread = Thread.new { while true do check_timer; sleep 1; end }
		@last_event = Time.now - 3600 # set last event to a longer time ago
	end

	def on(direction)
		@last_event = Time.now
		return if @is_on
		@is_on = true
		@direction = direction
		#set_color(128, 128, 128)
		#set_color(rand(192), rand(192), rand(192))
		set = random_set
		#set = simple_set(Color.random)
		write_set(set)
	end

	def off(direction = nil)
		return unless @is_on
		@is_on = false
		@direction = direction if direction
		write_set(simple_set(Color.new))
	end

	# red and blue are switched
	def write_set(set)
		if @direction == DIRECTION_RIGHT
			(LENGTH/2).times{|i| WS2801.set(set[i])}
		elsif @direction == DIRECTION_LEFT
			(LENGTH/2).times{|i| WS2801.set(set[(LENGTH/2)-i])}
		end
	end

	# red and blue are switched
	def set_color_single(r,g,b)
		if @direction == DIRECTION_RIGHT
			LENGTH.times{|i| WS2801.set(pixel: i, r: b, g: g, b: r)}
		elsif @direction == DIRECTION_LEFT
			LENGTH.times{|i| WS2801.set(pixel:(LENGTH-1-i),r: b, g: g, b: r)}
		else
			WS2801.set(r: b, g: g, b: r)
		end
	end

	def simple_set(color)
		preset = []
		(LENGTH/2).times do |i|
			# red and blue are switched
			preset << {
				pixel: [i, LENGTH-1-i],
				r: color.b,
				g: color.g,
				b: color.r
			}
		end
		preset
	end

	def gradient_set(color_from, color_to)
		preset = []
		(LENGTH/2).times do |i|
			# red and blue are switched
			preset << {
				pixel: [i, LENGTH-1-i],
				r: between(color_from.b, color_to.b, i),
				g: between(color_from.g, color_to.g, i),
				b: between(color_from.r, color_to.r, i)
			}
		end
		preset
	end

	def random_set
		preset = []
		(LENGTH/2).times do |i|
			# red and blue are switched
			preset << {
				pixel: [i, LENGTH-1-i],
				r: rand(192),
				g: rand(192),
				b: rand(192)
			}
		end
		preset
	end

	def between(from, to, i)
		from + ((to - from) * i.to_f/(LENGTH.to_f/2)).to_i
	end

	def check_timer
		self.off if @last_event < (Time.now - TIMEOUT)
	end

end


strip = Strip.new

pin_right = PiPiper::Pin.new(:pin => 22, :direction => :in)
pin_left = PiPiper::Pin.new(:pin => 23, :direction => :in)

after :pin => 23, :goes => :high do
  strip.on(Strip::DIRECTION_RIGHT)
  while pin_right.on?
  	strip.on(Strip::DIRECTION_RIGHT)
  	sleep 1
  end
end

after :pin => 24, :goes => :high do
  strip.on(Strip::DIRECTION_LEFT)
  while pin_left.on?
  	strip.on(Strip::DIRECTION_LEFT)
  	sleep 1
  end
end

PiPiper.wait
	