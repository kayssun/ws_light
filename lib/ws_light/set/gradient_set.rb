require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a gradient from one color to another
    class GradientSet < ColorSet
      attr_accessor :color_from, :color_to

      def init
        @color_from = Color.new(0,0,0)
        @color_to = Color.new(255,255,255)
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
        number = @full_length - 1 - number if number >= @length
        @color_from.mix(@color_to, number.to_f/(@length-1))
      end
    end
  end
end
