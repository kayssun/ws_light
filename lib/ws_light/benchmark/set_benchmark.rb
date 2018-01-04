require 'ws_light/set/gradient_set'
require 'ws_light/set/rainbow_set'
require 'ws_light/set/semolina_set'
require 'ws_light/set/random_set'
require 'ws_light/set/strawberry_set'
require 'ws_light/set/watermelon_set'
require 'ws_light/set/star_set'

require 'benchmark'
include Benchmark

@gradient_set = WSLight::Set::GradientSet.new
@rainbow_set = WSLight::Set::RainbowSet.new
@semolina_set = WSLight::Set::SemolinaSet.new
@random_set = WSLight::Set::RandomSet.new
@strawberry_set = WSLight::Set::StrawberrySet.new
@watermelon_set = WSLight::Set::WatermelonSet.new
@star_set = WSLight::Set::StarSet.new

@gradient_set.color_from = WSLight::Color.random_from_set
@gradient_set.color_to = WSLight::Color.random_from_set

n = 10_000

puts "Testing #{n} cycles over all sets..."

Benchmark.bm(15) do |x|
  x.report('GradientSet:') { n.times do @gradient_set.frame end }
  x.report('RainbowSet:') { n.times do @rainbow_set.frame end }
  x.report('SemolinaSet:') { n.times do @semolina_set.frame end }
  x.report('RandomSet:') { n.times do @random_set.frame end }
  x.report('StrawberrySet:') { n.times do @strawberry_set.frame end }
  x.report('WatermelonSet:') { n.times do @watermelon_set.frame end }
  x.report('StarSet:') { n.times do @star_set.frame end }
end

puts "To run smoothly, the benchmarks should all be lower than #{n/50.0} seconds."