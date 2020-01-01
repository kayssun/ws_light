require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class SunnySet < ColorSet
      def frame
        @set ||= generate_set
      end

      def pixel(number, _frame = 0)
        frame[number]
      end

      def generate_set
        set = []
        position = sun_position
        @full_length.times do |i|
          set << if position.include?(i)
                   Color.by_name(:yellow)
                 else
                   Color.by_name(:blue)
                 end
        end
        set
      end

      def sun_position
        case rand(4)
        when 0
          10..40
        when 1
          140..170
        when 2
          190..220
        else
          300..330
        end
      end
    end
  end
end
