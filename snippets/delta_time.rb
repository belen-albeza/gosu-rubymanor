require 'rubygems'
require 'gosu'

class Game < Gosu::Window
    def initialize
        super(550, 600, false)
        self.caption = 'Snippet - Draw images'

        @background = Gosu::Image.new(self, '../gfx/background.png')
        @ship = Gosu::Image.new(self, '../gfx/captain.png')

        @ship_x = 275
        @last_milliseconds = 0
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
        self.update_delta
        # with a delta we need to express the speed of our entities in
        # terms of pixels/second
        @ship_x -= 200 * @delta if self.button_down?(Gosu::KbLeft)
        @ship_x += 200 * @delta if self.button_down?(Gosu::KbRight)
    end

    def update_delta
        # Gosu::millisecodns returns the time since the window was created
        # Divide by 1000 since we want to work in seconds
        current_time = Gosu::milliseconds / 1000.0
        # clamping here is important to avoid strange behaviors
        @delta = [current_time - @last_milliseconds, 0.25].min
        @last_milliseconds = current_time
    end
end

game = Game.new
game.show
