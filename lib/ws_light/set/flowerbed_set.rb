require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a green set with some random colors
    class FlowerbedSet < ColorSet
      def frame
        @set ||= generate_set
      end

      def pixel(number, _frame = 0)
        frame[number]
      end

      def generate_set
        set = []
        @full_length.times do
          if rand(8) == 0
            set << Color.random_from_set
          else
            set << Color.by_name(:green)
        end
        set
      end
    end
  end
end
