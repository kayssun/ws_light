require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class RainSet < ColorSet
      FRAMES_PER_DROP = 20
      VISIBLE_DROPS = 35
      CLOUD = Color.new(4, 4, 4)

      def init
        @drops = (0..(@full_length - 1)).to_a.shuffle
        @max = @drops.size
        # append the start at the end to ensure same result window when near the % @max
        @drops += @drops[0, VISIBLE_DROPS]
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
        @set = [CLOUD] * @full_length
        start = (@frame_count * VISIBLE_DROPS / FRAMES_PER_DROP) % @max
        VISIBLE_DROPS.times do |i|
          drop_ratio = (FRAMES_PER_DROP.to_f / VISIBLE_DROPS.to_f)
          draw_drop(@drops[start + i], @frame_count - ((start - VISIBLE_DROPS + 1 + i) * drop_ratio).to_i)
        end
      end

      def draw_drop(position, drop_frame)
        blue = brightness(drop_frame.to_f) % 250
        @set[position] = Color.new(4, 4, 4 + blue)
      end

      def pixel(number)
        @set[number]
      end

      def brightness(frame_distance)
        (250 * (1.0 - (frame_distance.to_f / FRAMES_PER_DROP.to_f))).to_i
      end
    end
  end
end
