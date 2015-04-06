require 'ws2801'
require 'benchmark'
include Benchmark

WS2801.length(320)

light = [1] * 320 * 3
dark = [0] * 320 * 3

n = 1000

puts "Testing #{n} writes to the led strip..."

Benchmark.bm(15) do |x|
  x.report('Write:') { n.times do |i| WS2801.strip(i % 2 == 0 ? light : dark); WS2801.write end }
end

puts "To run smoothly, the benchmarks should all be lower than #{n/50.0} seconds."