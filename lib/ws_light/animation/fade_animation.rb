require 'ws_light/animation/base_animation'

module WSLight
  module Animation
    # Slides from one set to another from left to right (obviously depending on the hardware setup)
    class FadeAnimation < BaseAnimation
      FADE_DURATION = 50

      def frames
        FADE_DURATION + 1
      end

      def frame(count)
        set = []

        @set_from.next_frame
        @set_to.next_frame

        @set_from.full_length.times do |i|
          set << @set_from.pixel(i).mix(@set_to.pixel(i), count.to_f / FADE_DURATION.to_f)
        end

        set
      end

      def frames_per_second
        nil
      end
    end
  end
end
