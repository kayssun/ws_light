
require 'animation/animation_base'

module WSLight
  module Animation
    # Slides from one set to another from left to right (obviously depending on the hardware setup)
    class AnimationSlideLeft < AnimationBase
      def frames
        @set_from.length + 1 # one for each led plus one for all zero
      end

      def frame(count)
        set = []
        reverse_set = []

        @set_from.next_frame
        @set_to.next_frame

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
  end
end
