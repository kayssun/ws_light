require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a watermelon set, some green, some white, lots of red with a few red dots
    class WatermelonSet < ColorSet
      def frame
        set = []

        length_red = (0.72 * @length).to_i
        length_red_to_white = (0.1 * @length).to_i
        length_white = (0.1 * @length).to_i

        white = Color.new(255, 255, 255)
        red = Color.new(255, 0, 0)

        @length.times do |i|
          if i < length_red
            set << Color.new(0, 0, (rand(25) < 1 ? 0 : 255))
          elsif i < length_red + length_red_to_white
            ratio = (i - length_red) / (length_red + length_red_to_white)
            set << red.mix(white, ratio)
          elsif i < length_red + length_red_to_white + length_white
            set << white
          else
            set << Color.new(0, 127, 0)
          end
        end

        set
      end

      def pixel(number, _frame = 0)
        frame[number]
      end
    end
  end
end
