
require 'color'
require 'set/color_set'

class RainbowSet < ColorSet

  def frame
    @frame_count += 1
    @frequency = Math::PI / @length
  def next_frame
    @frame_count += 1
  end
    set = []

    @length.times do |i|
      set << pixel(i)
    end

    set += set.reverse if type == :double
    set
  end

  def pixel(number, frame = @frame_count)
    number = @length - number if number >= @length
    Color.new(
        (Math.sin(@frequency*(number+frame) + 0)**2 * 127),
        (Math.sin(@frequency*(number+frame) + 2.0*Math::PI/3.0)**2 * 127),
        (Math.sin(@frequency*(number+frame) + 4.0*Math::PI/3.0)**2 * 127)
    )
  end

end