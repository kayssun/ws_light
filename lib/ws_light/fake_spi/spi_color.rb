# A fake SPI class for testing, puts out a colored string
class SPI
    attr_accessor :speed, :skip

    def initialize
        @skip = 1
    end

    def xfer(data)
        color_data = data[:txdata]
        counter = -1
        while color_data.length > 2
            counter += 1
            color = color_data.shift(3)
            next if counter % (@skip + 1) != 0
            # For background color: \033[48;2;#{color[0]};#{color[1]};#{color[2]}m
            print("\033[38;2;#{color[0]};#{color[1]};#{color[2]}m█\033[0m")
            sleep 0.00005
        end
        print "\r"
    end
end
