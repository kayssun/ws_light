require 'set/color_set'

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
        length = type == :double ? Strip::LENGTH * 2 : Strip::LENGTH
        set = []
        length.times do
          set << Color.random
        end
        set
      end
    end
  end
end
