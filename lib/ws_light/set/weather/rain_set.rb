require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class RainSet < ColorSet
      FRAMES_PER_DROP = 24
      VISIBLE_DROPS = 35
      CLOUD = Color.new(8, 8, 8)

      def init
        @drops = (0..(@full_length - 4)).to_a.shuffle
        @max = @drops.size
        @drops += @drops[@drops.size - VISIBLE_DROPS, VISIBLE_DROPS]
        generate_frame
      end

      def next_frame
        @frame_count += 1
        @frame_count = @frame_count % (@max * FRAMES_PER_DROP)
        generate_frame
      end

      def frame
        next_frame
        @set
      end

      def generate_frame
        @set = []
        @full_length.times { @set << CLOUD }
        start = (@frame_count * VISIBLE_DROPS / FRAMES_PER_DROP) % @max
        VISIBLE_DROPS.times do |i|
          drop_ratio = (FRAMES_PER_DROP.to_f / VISIBLE_DROPS.to_f)
          draw_star(@drops[start + i], @frame_count - ((start - VISIBLE_DROPS + 1 + i) * drop_ratio).to_i)
        end
      end

      def draw_star(position, star_frame)
        blue = brightness((star_frame.to_f - (FRAMES_PER_DROP.to_f / 2.0)).abs)
        @set[position] = Color.new(8, 8, 8 + blue)
      end

      def pixel(number)
        @set[number]
      end

      def brightness(frame_distance)
        (248 * (1.0 - (frame_distance.to_f / (FRAMES_PER_DROP.to_f / 2.0)))).to_i
      end
    end
  end
end
