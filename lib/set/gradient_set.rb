
require 'color'
require 'set/color_set'

class GradientSet < ColorSet

  attr_accessor :color_from, :color_to

  def frame
    @color_from = Color.new(0,0,0) unless @color_from
    @color_to = Color.new(255,255,255) unless @color_to


    set = []
    @length.times do |i|
      set << pixel(i)
    end

    set += set.reverse if type == :double

    set
  end

  def pixel(number, _frame = 0)
    number = @length - number if number >= @length
    @color_from.mix(@color_to, number.to_f/(@length-1))
  end

end