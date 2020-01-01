require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates semolina with raspberries
    class SemolinaSet < ColorSet
      COLOR_SEMOLINA = Color.new(255, 127, 15)
      COLOR_RASPBERRY = Color.new(255, 7, 15)
      RASPBERRY_SIZE = 10
      RASPBERRY_COUNT = 8

      def init
        @raspberries = []

        while @raspberries.size < RASPBERRY_COUNT
          position = rand(@full_length)
          @raspberries << position unless at_end?(position) || between_strips?(position) || raspberry?(position)
        end
      end

      def between_strips?(position)
        @type == :double && ((@full_length / 2 - 1 - RASPBERRY_SIZE)..(@full_length / 2)).cover?(position)
      end

      def at_end?(position)
        position >= (@full_length - 1 - RASPBERRY_SIZE)
      end

      def frame
        @set ||= create_frame
      end

      def create_frame
        set = []

        @full_length.times do |i|
          set << (raspberry?(i) ? COLOR_RASPBERRY : COLOR_SEMOLINA)
        end

        set
      end

      def raspberry?(pixel)
        @raspberries.each do |raspberry|
          return true if pixel > raspberry && pixel < (raspberry + RASPBERRY_SIZE)
        end
        false
      end

      def pixel(number)
        frame[number]
      end
    end
  end
end
