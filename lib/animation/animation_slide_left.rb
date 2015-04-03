
require 'animation/animation_base'

class AnimationSlideLeft < AnimationBase

  def frames
    set_from.length
  end

  def frame(count)
    set = []
    reverse_set = []

    count += 1

    (set_from.length - count).times do |i|
      set << set_from.pixel(i)
      reverse_set << set_from.pixel((set_from.length * 2) - 1 - i) if set_from.type == :double
    end

    count.times do |i|
      set << set_to.pixel(set_from.length - count + i)
      reverse_set << set_to.pixel(set_from.length + count - 1 - i) if set_from.type == :double
    end

    set += reverse_set.reverse if set_from.type == :double

    set
  end

  def frames_per_second
    nil
  end

end