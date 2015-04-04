require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a strawberry set, some green, lots of pinkish red with a few greenish dots
    class StrawberrySet < ColorSet
      LENGTH_RED = 0.9
      COLOR_NUT = Color.new(220, 255, 15)

      def frame
        @set ||= create_frame
      end

      def create_frame
        set = []

        length_red = (LENGTH_RED * @length).to_i


        color_strawberry = Color.new(255, 7, 15)
        color_leaves = Color.new(15, 191, 15)

        @length.times do |i|
          set << (i < length_red ? color_strawberry : color_leaves)
        end

        set = sprinkle_nuts(set)

        type == :double ? set + set.reverse : set
      end

      def sprinkle_nuts(set)
        length_red = (LENGTH_RED * @length).to_i
        distance = 0
        while distance < length_red - 21
          distance += 15 + rand(5)
          set[distance] = COLOR_NUT
        end

        set
      end

      def pixel(number)
        frame[number]
      end
    end
  end
end
