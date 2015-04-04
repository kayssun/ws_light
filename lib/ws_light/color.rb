module WSLight
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
      @r = r.to_i < 255 ? r.to_i : 255
      @g = g.to_i < 255 ? g.to_i : 255
      @b = b.to_i < 255 ? b.to_i : 255
    end

    def to_a
      [@b, @g, @r]
    end

    def mix(other, ratio)
      Color.new(
          (@r * (1-ratio) + other.r * ratio).to_i,
          (@g * (1-ratio) + other.g * ratio).to_i,
          (@b * (1-ratio) + other.b * ratio).to_i
      )
    end

    def mix!(other, ratio)
      @r = (@r * (1-ratio) + other.r * ratio).to_i
      @g = (@g * (1-ratio) + other.g * ratio).to_i
      @b = (@b * (1-ratio) + other.b * ratio).to_i
      self
    end

    def self.random
      Color.new(rand(192), rand(192), rand(192))
    end

    def self.by_name(name)
      if Color::COLORS[name]
        selected_color = Color::COLORS[name]
        Color.new(selected_color[:r], selected_color[:g], selected_color[:b])
      elsif name == :black
        Color.new(0, 0, 0)
      else
        fail "Cannot find color #{name}"
      end
    end

    def self.random_from_set
      color_values = Color::COLORS.values
      selected_color = color_values[rand(color_values.length)]
      Color.new(selected_color[:r], selected_color[:g], selected_color[:b])
    end
  end
end
