require 'optparse'
require 'yaml'

module WSLight
  # Reads config file and parses command parameters
  class Config
    CONFIG_FILE = "/etc/ws_light.conf"

    DEFAULT_OPTIONS = {
      'pin_right' => 23,
      'pin_left' => 24,
      'log_file' => '/var/log/motion.log',
      'track_motion_in_log' => true,
      'debug' => false,
      'sensor_right_name' => 'motion_right',
      'sensor_left_name' => 'motion_left',
      'sensor_right_description' => 'Motion sensor right',
      'sensor_left_description' => 'Motion sensor left',
      'hass_integration' => false,
      'hass_url' => '',
      'hass_api_password' => ''
    }.freeze

    def initialize
      @config = DEFAULT_OPTIONS.merge(yaml_options).merge(command_line_options)
      store_options
    end

    def store_options
      File.open(CONFIG_FILE, 'w') do |file|
        file.puts @config.to_yaml
      end
    end

    def parse
      @config
    end

    def yaml_options
      if File.exist?CONFIG_FILE
        ::YAML.load(File.read(CONFIG_FILE))
      else
        {}
      end
    end

    def command_line_options
      options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: ws_light [options]'

        opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
          options['verbose'] = v
        end

        opts.on('-l NUMBER', '--left-pin NUMBER', 'Pin number to which the left motion detector is connected') do |number|
          options['pin_left'] = number
        end

        opts.on('-r NUMBER', '--right-pin NUMBER', 'Pin number to which the right motion detector is connected') do |number|
          options['pin_right'] = number
        end

        opts.on('-o PATH', '--log PATH', 'path to the log file') do |log_file|
          options['log_file'] = log_file
        end

        opts.on('--quiet-log', 'do not log detected motions') do
          options['track_motion_in_log'] = false
        end

        opts.on('--debug', 'output all log messages to stdout, too') do
          options['debug'] = true
        end
      end.parse!
      options
    end
  end
end
