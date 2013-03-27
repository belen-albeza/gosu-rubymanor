require 'rubygems'
require 'gosu'

class Game < Gosu::Window
    def initialize
        # this super calls Gosu constructor with
        # [width, height, fullscreen?] values.
        super(800, 600, false)
        self.caption = 'Sample shooter'
    end
end

game = Game.new
game.show # creates the window and starts the game loop
