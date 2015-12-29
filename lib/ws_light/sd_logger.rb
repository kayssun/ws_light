module WSLight
  # Provides a logger which writes only in long intervals, thus reducing write access to the cd card
  # (out data is not that crucial)
  class SDLogger
    attr_accessor :entries, :interval, :entries, :debug, :filename

    def initialize
      @filename = '/var/log/motion.log'
      @interval = 1800 # log interval in seconds
      @entries = []
      @last_write = Time.now
      @debug = false
    end

    def log(text)
      puts Time.now.to_s + ' -> ' + text if @debug
      entries << {
        text: text,
        time: Time.now
      }
      write_log if timeout?
    end

    def write_log
      return if @entries.empty?
      file = File.open(@filename, File.exists?(@filename) ? 'a' : 'w')
      @entries.each do |entry|
        file.puts(entry[:time].to_s + ', ' + entry[:text])
      end
      file.close
      @entries = []
      @last_write = Time.now
    end

    def timeout?
      (Time.now - @last_write) > @interval
    end

  end
end
