require 'net/http'
require 'json'

# Home Assistant notifier
class Hass
  def initialize(url, password, logger)
    @url = url
    @password = password
    @logger = logger
  end

  def notify(sensor_name = 'motion', friendly_name = 'Motion Sensor')
    url = "#{@url}/api/states/sensor.#{sensor_name}"
    on_data = { 'state' => 'on', 'attributes' => { 'friendly_name' => friendly_name } }.to_json
    off_data = { 'state' => 'off', 'attributes' => { 'friendly_name' => friendly_name } }.to_json
    Thread.new do
      send_data(url, on_data)
      sleep 5
      send_data(url, off_data)
    end
  end

  def send_data(url, data)
    uri = URI(url)
    puts "Starting request to #{url} with data #{data}"
    https = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)
    request['Authorization'] = "Bearer #{@password}"
    request['Accept-Encoding'] = 'deflate'
    request.body = data
    https.use_ssl = true if uri.scheme == 'https'
    response = https.request request
    @logger.log("Request to Home Assistant failed (#{response.code}): #{response.body}") #  if response.code > 299
  end
end
