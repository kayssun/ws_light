
require 'animation/animation_base'

class AnimationSlideRight < AnimationBase

  def frames
    set_from.length
  end

  def frame(count)
    set = []
    reverse_set = []

    count += 1

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