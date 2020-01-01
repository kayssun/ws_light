require 'net/http'
require 'json'

# Home Assistant notifier
class Hass
  def initialize(url, password, logger)
    @url = url
    @password = password
    @logger = logger
  end

  def notify(state, sensor_name = 'motion', friendly_name = 'Motion Sensor')
    url = "#{@url}/api/states/sensor.#{sensor_name}"
    data = { 'state' => (state ? 'on' : 'off'), 'attributes' => { 'friendly_name' => friendly_name } }.to_json
    Thread.new { send_data(url, data) }
  end

  def send_data(url, data)
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Post.new(uri)
      request['x-ha-access'] = @password
      request.body = data
      response = http.request request
      logger.log("Request to Home Assistent failed: #{response.body}") if response.code > 299
    end
  end
end
