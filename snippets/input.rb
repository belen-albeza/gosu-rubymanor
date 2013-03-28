require 'rubygems'
require 'gosu'

class Game < Gosu::Window
    def initialize
        super(550, 600, false)
        self.caption = 'Snippet - Draw images'

        @background = Gosu::Image.new(self, '../gfx/background.png')
        @ship = Gosu::Image.new(self, '../gfx/captain.png')

        @ship_x = 275
    end

    def draw
        @background.draw(0, 0, 0)
        @ship.draw_rot(@ship_x, 550, 0, 0)
    end

    # this is a callback for key up events or equivalent (there are
    # constants for gamepad buttons and mouse clicks)
    def button_up(key)
        self.close if key == Gosu::KbEscape
    end

    def update
        # in addition to a callback for key up, we can check whether a key
        # is being pressed right now
        @ship_x -= 4 if self.button_down?(Gosu::KbLeft)
        @ship_x += 4 if self.button_down?(Gosu::KbRight)
    end
end

game = Game.new
game.show
