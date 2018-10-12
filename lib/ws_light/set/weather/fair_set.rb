require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class CloudySet < ColorSet
      def frame
        @set ||= generate_set
      end

      def pixel(number, _frame = 0)
        frame[number]
      end

      def generate_set
        set = []
        @full_length.times do |i|
          set << Color.new(8, 8, 8)
        end
        set
      end
    end
  end
end


dd
Guido Laßmann <guido.lassmann@t-online.de>