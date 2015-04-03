
require 'color'

class ColorSet

  attr_accessor :type, :length, :color

  def initialize(length = 160, type = :double)
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

  def pixel(_number, _frame = 0)
    @color
  end

end