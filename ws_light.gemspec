lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ws_light/version'

Gem::Specification.new do |spec|
  spec.name          = 'ws_light'
  spec.version       = WSLight::VERSION
  spec.authors       = ['Audra Visscher']
  spec.email         = ['kayssun@kayssun.de']
  spec.summary       = 'A lighting gem for WS2801 led strips.'
  spec.description   = 'Controls one or two WS2801 led strips with a Raspberry Pi or another computer with an SPI interface.'
  spec.homepage      = 'https://github.com/kayssun/ws_light'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'

  spec.add_runtime_dependency 'pi_piper', '~>2'
  spec.add_runtime_dependency 'spi', '~>0.1'
end
