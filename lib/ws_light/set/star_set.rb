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
        #(-3..3).each do |i|
        #  white = brightness(i.abs, (star_frame - (FRAMES_PER_STAR/2)).abs)
        #  @set[position + i] = Color.new(white, white, white)
        #end
        #return if star_frame < 0
        white = brightness(0, (star_frame.to_f - (FRAMES_PER_STAR.to_f/2.0)).abs)
        #puts "#{position}, #{star_frame}, #{(star_frame.to_f - (FRAMES_PER_STAR.to_f/2.0)).abs}, #{white}"
        @set[position] = Color.new(white, white, white)
      end

      def pixel(number)
        @set[number]
      end

      def brightness(led_distance, frame_distance)
        #return 0 if led_distance > 3
        #(2 ** ((3 - led_distance) * 3 - 1) - 1) * (1 - (frame_distance/(FRAMES_PER_STAR/2)))
        (255 * (1.0 - (frame_distance.to_f/(FRAMES_PER_STAR.to_f/2.0)))).to_i
      end
    end
  end
end
