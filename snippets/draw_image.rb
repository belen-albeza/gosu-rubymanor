require 'rubygems'
require 'gosu'

class Game < Gosu::Window
    def initialize
        super(550, 600, false)
        self.caption = 'Snippet - Draw images'

        # Gosu::Image.new loads an image
        @background = Gosu::Image.new(self, '../gfx/background.png')
        @ship = Gosu::Image.new(self, '../gfx/captain.png')
    end

    def draw
        # draws an image taking as origin its top left corner
        # args are: [x, y, z]
        @background.draw(0, 0, 0)

        # draws an image taking as origin its *center*
        # args are: [x, y, z, angle]
        # this method takes many extra parameters to do scale, blending,
        # etc. Take a look at the doc
        @ship.draw_rot(275, 300, 0, 0)
    end
end

game = Game.new
game.show
