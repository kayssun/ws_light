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
        sun_position = case rand(4)
        when 0
          10..40
        when 1
          140..170
        when 2
          190..220
        when 3
          300..330
        @full_length.times do |i|
          if sun_position.include?(i)
            set << Color.by_name(:yellow)
          else
            set << Color.by_name(:blue)
          end
        end
        set
      end
    end
  end
end
