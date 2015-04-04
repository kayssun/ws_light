
require 'animation/animation_base'

class AnimationSlideRight < AnimationBase

  def frames
    @set_from.length + 1 # one for each led plus one for all zero
  end

  def frame(count)
    set = []

    @set_from.next_frame
    @set_to.next_frame

    count.times do |i|
      set << set_to.pixel(i)
    end

    (set_from.length - count).times do |i|
      set << set_from.pixel(i + count)
    end

    set += set.reverse if set_from.type == :double

    set
  end

  def frames_per_second
    nil
  end

end