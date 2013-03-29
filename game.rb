require 'rubygems'
require 'gosu'

class Game < Gosu::Window
  attr_reader :images, :audio, :delta, :aliens, :bullets, :ship
  attr_accessor :score

  IMAGE_ASSETS = {
    :background => 'background.png',
    :ship => 'captain.png',
    :alien => 'alien.png',
    :bullet => 'laser.png'
  }

  AUDIO_ASSETS = {
    :shoot => 'shoot.wav',
    :kill => 'kill.wav'
  }

  def initialize
    super(550, 600, false)
    self.caption = 'Shooter'
    @images = {}
    @audio = {}

    @ship = nil
    @bullets = []
    @aliens = []
  end

  def run!
    self.load_assets
    self.setup_game
    self.show
  end

  def draw
    # draw background
    @images[:background].draw(0, 0, 0)

    # draw the sprites
    @ship.draw
    @bullets.each {|bullet| bullet.draw }
    @aliens.each {|alien| alien.draw }

    # draw the score
    @font.draw("#{@score}", 10, 10, 20)
  end

  def update
    self.update_delta
    self.spawn_enemies

    @ship.update
    @bullets.each {|bullet| bullet.update }
    @aliens.each {|alien| alien.update }

    self.handle_kills
  end

  def button_up(key)
    self.close if key == Gosu::KbEscape
    self.shoot if key == Gosu::KbSpace
  end

  protected

  def load_assets
    IMAGE_ASSETS.each do |key, value|
      @images[key] = Gosu::Image.new(self, "gfx/#{value}")
    end

    AUDIO_ASSETS.each do |key, value|
      @audio[key] = Gosu::Sample.new(self, "sfx/#{value}")
    end

    @font = Gosu::Font.new(self, 'Courier', 40)
  end

  def update_delta
    current_time = Gosu::milliseconds / 1000.0
    @delta = [current_time - @last_time, 0.25].min
    @last_time = current_time
  end

  def setup_game
    @last_time = Gosu::milliseconds / 1000.0
    @ship = Ship.new
    @score = 0
  end

  def shoot
    @bullets.push(Bullet.new(@ship.x, @ship.y)) unless @ship.nil?
    @audio[:shoot].play
  end

  def spawn_enemies
    if rand(100) < 400 * @delta
      @aliens.push(Alien.new)
    end
  end

  def handle_kills
    @aliens.reject! {|x| x.killed? }
    @bullets.reject! {|x| x.killed? }
    self.game_over if @ship.killed?
  end

  def game_over
    self.close
  end
end

module Sprite
  attr_accessor :x, :y, :z, :angle, :image, :radius

  def initialize_sprite
    @killed = false
    @x = 0
    @y = 0
    @z = 0
    @angle = 0
    @image = nil
    @image_index = 0
    @radius = 0 # circular boundign box size
  end

  def killed?
    @killed
  end

  def kill!
    @killed = true
  end

  def colliding?(other)
    if @radius.zero? or other.radius.zero?
      false
    else
      Gosu::distance(@x, @y, other.x, other.y) < (@radius + other.radius)
    end
  end

  def draw
    @image.draw_rot(@x, @y, @z, @angle) unless @image.nil?
  end
end

class Ship
  include Sprite
  SPEED = 350 # pixels / second

  def initialize
    self.initialize_sprite
    @x = $game.width / 2
    @y = $game.height - 50
    @image = $game.images[:ship]
    @z = 10
    @radius = 30
  end

  def update
    # move horizontally if <- or -> are pressed
    @x -= SPEED * $game.delta if $game.button_down?(Gosu::KbLeft)
    @x += SPEED * $game.delta if $game.button_down?(Gosu::KbRight)
    # clamp @x so the ship always stays inside the screen
    @x = [[@x, $game.width].min, 0].max
  end
end

class Bullet
  include Sprite
  SPEED = 400 # pixels / second

  def initialize(x, y)
    self.initialize_sprite
    @x = x
    @y = y
    @image = $game.images[:bullet]
    @z = 1
    @radius = 10
  end

  def update
    # move upwards
    @y -= SPEED * $game.delta

    # collisions against aliens
    $game.aliens.each do |alien|
      if self.colliding?(alien)
        # destroy both alien and bullet
        alien.kill!
        self.kill!
        $game.score += 10 # increase score
        $game.audio[:kill].play # play explosion sfx
      end
    end

    # destroy the laser when out of the screen
    self.kill! if @y < -15
  end
end

class Alien
  include Sprite

  def initialize
    self.initialize_sprite
    @x = rand($game.width)
    @y = -80
    @z = 1
    @image = $game.images[:alien]
    @radius = 20

    # random horizontal and vertical speed
    @speed_x = [-1, 1].sample * rand(50)
    @speed_y = 100 + rand(200)
  end

  def update
    @x += @speed_x * $game.delta
    @y += @speed_y * $game.delta

    # collisions against the ship
    $game.ship.kill! if self.colliding?($game.ship)

    # destroy alien when out of the screen
    self.kill! if @y > $game.height + 25
  end
end

$game = Game.new
$game.run!
