require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates one of multiple LGTBQIA+ flags
    class LGBTQIAFlagSet < ColorSet
      attr_accessor :color_from, :color_to

      FLAGS = {
        rainbow: [
          Color(255, 0, 0)
        ]
      }

      def init
        @flag = :rainbow
      end

      def frame
        @set ||= create_frame
      end

      def create_frame
        set = []
        @length.times do |i|
          set << pixel(i)
        end

        set += set.reverse if type == :double # this should be faster than generating the pixel one after another

        set
      end

      def pixel(number)
        Color(255, 0, 0)
      end
    end
  end
end
