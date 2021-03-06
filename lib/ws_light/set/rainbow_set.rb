require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a moving rainbow (actually a color circle)
    class RainbowSet < ColorSet
      def init
        @frequency = Math::PI / @length
      end

      def next_frame
        @frame_count += 1
      end

      def frame
        next_frame
        set = []

        @length.times do |i|
          set << pixel(i)
        end

        set += set.reverse if type == :double

        set
      end

      def pixel(number)
        number = @full_length - 1 - number if number >= @length
        x = @frequency * (number + @frame_count)
        Color.new(
          (Math.sin(x)**2 * 127),
          (Math.sin(x + 2.0 * Math::PI / 3.0)**2 * 127),
          (Math.sin(x + 4.0 * Math::PI / 3.0)**2 * 127)
        )
      end
    end
  end
end
