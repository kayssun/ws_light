require 'ws_light/color'

module WSLight
  module Set
    # Base set with one color
    class ColorSet
      DEFAULT_LENGTH = 160
      DEFAULT_TYPE = :double

      attr_accessor :type, :length, :color

      def initialize(length = DEFAULT_LENGTH, type = DEFAULT_TYPE)
        @length = length
        @full_length = (@type == :double ? @length * 2 : @length)
        @type = type
        @color = Color.random
        @frame_count = 0
        init
      end

      def frame_data
        frame.collect{|color| color.to_a}.flatten
      end

      def frame
        length = type == :double ? @length * 2 : @length
        set = []
        length.times do
          set << @color
        end
        set
      end

      def next_frame
        # reimplement if necessary, please :)
      end

      def pixel(_number, _frame = 0)
        @color
      end

      def init
        # do some initializing stuff here
      end
    end
  end
end
