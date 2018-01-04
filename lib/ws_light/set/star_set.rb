require 'ws_light/set/color_set'

module WSLight
  module Set
    # Creates a set with all random colors
    class StarSet < ColorSet
      FRAMES_PER_STAR = 75
      VISIBLE_STARS = 7
      BLACK = Color.new(0,0,0)

      def init
        @stars = (0..(@full_length-4)).to_a.shuffle
        @max = @stars.size
        @stars += @stars[@stars.size - VISIBLE_STARS, VISIBLE_STARS]
        generate_frame
      end

      def next_frame
        @frame_count += 1
        @frame_count = @frame_count % (@max * FRAMES_PER_STAR)
        generate_frame
      end

      def frame
        next_frame
        @set
      end

      def generate_frame
        @set = []
        @full_length.times{ @set << BLACK }
        start = (@frame_count * VISIBLE_STARS / FRAMES_PER_STAR) % @max
        VISIBLE_STARS.times do |i|
          draw_star(@stars[start + i], @frame_count - ((start - VISIBLE_STARS + 1 + i) * (FRAMES_PER_STAR.to_f / VISIBLE_STARS.to_f)).to_i)
        end
      end

      def draw_star(position, star_frame)
        white = brightness((star_frame.to_f - (FRAMES_PER_STAR.to_f/2.0)).abs)
        @set[position] = Color.new(white, white, white)
      end

      def pixel(number)
        @set[number]
      end

      def brightness(frame_distance)
        (255 * (1.0 - (frame_distance.to_f/(FRAMES_PER_STAR.to_f/2.0)))).to_i
      end
    end
  end
end
