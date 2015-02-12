#!/usr/bin/env ruby

require 'pi_piper'

include PiPiper

require './strip.rb'
require './logger.rb'

DEBUG = true

logger = Logger.new
logger.debug = DEBUG
logger.filename = 'motion.log'
logger.log 'Starting up'

# Trap ^C 
Signal.trap('INT') {
  logger.log 'Shutting down'
  logger.write_log
  exit
}
 
# Trap `Kill `
Signal.trap('TERM') {
  logger.log 'Shutting down'
  logger.write_log
  exit
}

strip = Strip.new
strip.debug = DEBUG

pin_right = PiPiper::Pin.new(:pin => 22, :direction => :in)
pin_left = PiPiper::Pin.new(:pin => 23, :direction => :in)

after :pin => 23, :goes => :high do
  logger.log('Motion detected: RIGHT')
  strip.on(Strip::DIRECTION_RIGHT)
  while pin_right.on?
  	strip.on(Strip::DIRECTION_RIGHT)
  	sleep 1
  end
end

after :pin => 24, :goes => :high do
  logger.log('Motion detected: LEFT')
  strip.on(Strip::DIRECTION_LEFT)
  while pin_left.on?
  	strip.on(Strip::DIRECTION_LEFT)
  	sleep 1
  end
end

PiPiper.wait
	