require 'ws_light/animation/base_animation'

module WSLight
  module Animation
    # Slides from one set to another from right to left (obviously depending on the hardware setup)
    class SlideRightAnimation < BaseAnimation
      def frames
        @set_from.length + 1 # one for each led plus one for all zero
      end

      def frame(count)
        set = []
        reverse_set = []

        @set_from.next_frame
        @set_to.next_frame

        count.times do |i|
          set << set_to.pixel(i)
          reverse_set << set_to.pixel((set_from.length * 2) - 1 - i)
        end

        (set_from.length - count).times do |i|
          set << set_from.pixel(i + count)
          reverse_set << set_from.pixel((set_from.length * 2) - count - 1 - i)
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
