module WSLight
  module Animation
    # Base class for all animations, defines common methods
    class AnimationBase
      attr_accessor :set_from, :set_to, :type

      def initialize(set_from, set_to)
        @set_from = set_from
        @set_to = set_to
      end

      def frame_data(count)
        frame(count).collect{|color| color.to_a}.flatten
      end

      def frames_per_second
        25.0
      end
    end
  end
end