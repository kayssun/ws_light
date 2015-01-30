#!/usr/bin/env ruby

require 'pi_piper'

include PiPiper

require './strip.rb'

# TODO
# - cancel led shut off when new motion is detected

DEBUG = false

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
	