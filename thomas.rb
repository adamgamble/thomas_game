#!/usr/bin/env ruby
require 'rubygems'
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
require 'texplay'
include Gosu

class Game < Chingu::Window
  def initialize
    super(1920,736)
    switch_game_state(Scroller)
    thomas_image = Image["images/james.png"]
    thomas_image.clear :color => thomas_image.get_pixel(1,1), :dest_select => :transparent
    rosie_image = Image["images/thomas.png"]
    rosie_image.clear :color => rosie_image.get_pixel(1,1), :dest_select => :transparent
    @player_2 = Player.create(:x => 1850, :y => 415, :image => rosie_image)
    @player   = Player.create(:x => 1850, :y => 430, :image => thomas_image)
    @player.input =  { :left_control => :move_left,
                    :left_alt => :move_right,
                    :escape => :exit
                    }
    @player_2.input =  { :left_arrow => :move_left,
                    :right_arrow => :move_right,
                    :escape => :exit
                    }
  end
end

class Scroller < Chingu::GameState

  def initialize(options = {})
    super(options)
    @text_color = Color.new(0xFF000000)
    @scrolling = false
  end

  def scroll
    @scrolling = true
  end

  def dont_scroll
    @scrolling = false
  end

  def camera_left
    @parallax.camera_x -= 10
  end

  def camera_right
    @parallax.camera_x += 1
  end

  def setup
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => "background.png", :repeat_x => true, :repeat_y => true}
  end

  def update
    super()
    self.camera_left if @scrolling
  end
end

class Player < Chingu::GameObject

  ACCELERATION_FACTOR = 1.25
  DECELERATION_FACTOR = 0.075

  def initialize options = {}
    super(options)
    @speed = 0
  end

  def move_left
    @speed -= ACCELERATION_FACTOR unless @speed <= -5
  end

  def move_right
    @speed += ACCELERATION_FACTOR unless @speed >= 5
  end

  def update
    if @x <= 100 && @speed < 0
      $window.game_state_manager.game_states.first.camera_left
      @x += 10
    end
    @x += @speed
    if @speed < 0
      @speed += DECELERATION_FACTOR
    elsif @speed > 0
      @speed -= DECELERATION_FACTOR
    end
  end
end

Game.new.show
