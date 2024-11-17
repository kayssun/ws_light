# A fake SPI class for testing, puts out the length of same colored blocks
class SPI
    attr_accessor :speed, :skip

    def initialize
        @skip = 1
    end

    def xfer(data)
        color_data = data[:txdata]
        old_color = color_data[0,3]
        counter = 0
        while color_data.length > 2
            counter += 1
            color = color_data.shift(3)
            if color != old_color
                print "#{counter}x[#{old_color[0]}, #{old_color[1]}, #{old_color[2]}] "
                counter = 0
            end
            old_color = color
        end
        print "#{counter}x[#{old_color[0]}, #{old_color[1]}, #{old_color[2]}] "
        print "\n"
    end
end
