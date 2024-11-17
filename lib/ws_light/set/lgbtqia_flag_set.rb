require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates one of multiple LGTBQIA+ flags
    class LGBTQIAFlagSet < ColorSet
      attr_accessor :color_from, :color_to

      # 23. September: Bi visibility day
      # June: pride month
      
      FLAGS = {
        rainbow: [
          Color.new(255, 0, 0),
          Color.new(255, 31, 0),
          Color.new(255, 127, 0),
          Color.new(15, 255, 15),
          Color.new(15, 15, 255),
          Color.new(95, 15, 255)
        ],
        non_binary: [
          Color.new(255, 127, 0),
          Color.new(255, 255, 255),
          Color.new(63, 7, 255),
          Color.new(0, 0, 0)
        ],
        trans: [
          Color.new(31, 31, 255),
          Color.new(255, 63, 127),
          Color.new(255, 255, 255),
          Color.new(255, 63, 127),
          Color.new(31, 31, 255)
        ],
        lesbian: [
          Color.new(255, 15, 0),
          Color.new(255, 63, 0),
          Color.new(255, 63, 15),
          Color.new(255, 255, 255),
          Color.new(255, 64, 255),
          Color.new(255, 15, 255),
          Color.new(95, 15, 255)
        ],
        bi: [
          Color.new(255, 0, 63),
          Color.new(255, 0, 63),
          Color.new(47, 0, 95),
          Color.new(0, 0, 255),
          Color.new(0, 0, 255)
        ],
        pan: [
          Color.new(255, 0, 63),
          Color.new(255, 127, 0),
          Color.new(31, 31, 255)
        ],
        ace: [
          Color.new(0, 0, 0),
          Color.new(15, 15, 15),
          Color.new(255, 255, 255),
          Color.new(95, 15, 255)
        ]
      }

      def init
        @flag = FLAGS.keys.sample
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
        block_length = @length / FLAGS[@flag].length.to_f
        block_number = number / block_length
        FLAGS[@flag][block_number.to_i]
      end
    end
  end
end
