#!/usr/bin/env ruby

require 'ws2801'
require './color.rb'

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
		puts "Triggered event 'on': #{last_event.to_f}" if DEBUG
		return if @is_on
		@is_on = true
		@direction = direction
		puts "starting write: #{(Time.now - last_event).to_f}" if DEBUG
		
		# 5% chance to generate rainbow or random colors
		switch = rand(100)
		if switch > 94
			set = rainbow_set
		elsif switch > 89
			set = random_set
		else
			set = gradient_set(Color.random_from_set, Color.random_from_set)
		end	
		
		write_set(set)
		
		puts "finishing write: #{(Time.now - last_event).to_f}" if DEBUG
	end

	def off(direction = nil)
		return unless @is_on
		puts "Triggered event 'off': #{Time.now.to_f}" if DEBUG
		@is_on = false
		@direction = direction if direction
		write_set(simple_set(Color.new))
		puts "Finished shutting off: #{Time.now.to_f}" if DEBUG
	end

	def shutdown
		WS2801.set(r: 0, g: 0, b: 0)
	end

	# red and blue are switched
	def write_set(set)
		if @direction == DIRECTION_RIGHT
			(LENGTH/2).times{|i| WS2801.set(set[i])}
		elsif @direction == DIRECTION_LEFT
			(LENGTH/2).times{|i| WS2801.set(set[(LENGTH/2)-i-1])}
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

	def rainbow_set
		frequency = 0.06 * (160.0 / LENGTH)
		preset = []
		(LENGTH/2).times do |i|
			preset << {
				pixel: [i, LENGTH-1-i],
				g: (Math.sin(frequency*i + 0) * 127 + 128),
   				r: (Math.sin(frequency*i + 2) * 127 + 128),
   				b: (Math.sin(frequency*i + 4) * 127 + 128),
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