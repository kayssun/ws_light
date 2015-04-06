require 'ws_light/animation/fade_animation'
require 'ws_light/animation/slide_left_animation'
require 'ws_light/animation/slide_right_animation'
require 'ws_light/set/color_set'

require 'benchmark'
include Benchmark


color_set_from = WSLight::Set::ColorSet.new
color_set_from.color = WSLight::Color.new(255, 127, 0)
color_set_to = WSLight::Set::ColorSet.new
color_set_to.color = WSLight::Color.new(0, 127, 255)

@fade_animation = WSLight::Animation::FadeAnimation.new(color_set_from, color_set_to)
@slide_left_animation = WSLight::Animation::SlideLeftAnimation.new(color_set_from, color_set_to)
@slide_right_animation = WSLight::Animation::SlideRightAnimation.new(color_set_from, color_set_to)

n = 10_000

puts "Testing #{n} animation cycles with a simple color set..."

Benchmark.bm(15) do |x|
  x.report('FadeAnimation:') { n.times do @fade_animation.frame(n%50) end }
  x.report('SlideLeftAnimation:') { n.times do @slide_left_animation.frame(n%50) end }
  x.report('SlideRightAnimation:') { n.times do @slide_right_animation.frame(n%50) end }
end

puts "To run smoothly, the benchmarks should all be lower than #{n/50.0} seconds."