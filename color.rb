#!/usr/bin/env ruby

class Color
	attr_accessor :r, :g, :b

	COLORS = {
		pink: { r: 255, g: 16, b:32 },
		red: { r: 255, g: 0, b: 0},
		blue: { r: 0, g: 0, b: 255},
		green: { r: 0, g: 255, b: 0},
		cyan: { r: 0, g: 127, b: 127},
		orange: {r: 255, g:70, b: 0},
		yellow: {r: 255, g:220, b: 0},
		purple: {r: 80, g:0, b: 180}
	}

	def initialize(r=0, g=0, b=0)
		@r = r
		@g = g
		@b = b
	end

	def self.random
		Color.new(rand(192), rand(192), rand(192))
	end

	def self.by_name(name)
    selected_color = Color::COLORS[name]
		Color.new(selected_color[:r], selected_color[:g], selected_color[:b])
	end

	def self.random_from_set
		color_values = Color::COLORS.values
		selected_color = color_values[rand(color_values.length)]
		Color.new(selected_color[:r], selected_color[:g], selected_color[:b])
	end
end