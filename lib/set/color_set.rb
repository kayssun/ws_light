
require 'color'

class ColorSet

  DEFAULT_LENGTH = 160
  DEFAULT_TYPE = :double

  attr_accessor :type, :length, :color

  def initialize(length = DEFAULT_LENGTH, type = DEFAULT_TYPE)
    @length = length
    @type = type
    @color = Color.random
    @frame_count = 0
  end

  def frame_data
    frame.collect{|color| color.to_a}.flatten
  end

  def frame
    length = type == :double ? @length * 2 : @length
    set = []
    length.times do
      set << @color
    end
    set
  end

  def next_frame
    # reimplement if necessary, please :)
  end

  def pixel(_number, _frame = 0)
    @color
  end

end