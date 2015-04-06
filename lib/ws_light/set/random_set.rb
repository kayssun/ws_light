require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class RandomSet < ColorSet
      def frame
        @set ||= generate_set
      end

      def pixel(number, _frame = 0)
        frame[number]
      end

      def generate_set
        set = []
        @full_length.times do
          set << Color.random
        end
        set
      end
    end
  end
end
