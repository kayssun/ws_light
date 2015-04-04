require 'set/color_set'

module WSLight
  module Set
    # Creates a gradient from one color to another
    class GradientSet < ColorSet
      attr_accessor :color_from, :color_to

      def initialize(length = DEFAULT_LENGTH, type = DEFAULT_TYPE)
        super(length, type)
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

        set += set.reverse if type == :double

        set
      end

      def pixel(number, _frame = 0)
        number = @length - number if number >= @length
        @color_from.mix(@color_to, number.to_f/(@length-1))
      end
    end
  end
end
