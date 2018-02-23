# Setting up environment for training the model


require 'pry'
require_relative 'keyboard.rb'
require_relative 'mouse.rb'
require 'chunky_png'

# require 'win32-autogui'

class Init


  SCREEN_WIDTH = 1980
  SCREEN_HEIGHT = 1200

  MOUSE_WIDTH = 62
  MOUSE_HEIGHT = 62

  START = {
    x: -SCREEN_WIDTH-MOUSE_WIDTH,
    y: 0
  }

  PLAYERS = [
    {
      name: 'bot1',
      color: '#0000ff',
      left: 'a',
      right: 'd'
    }
  ]

 class << self
   include MouseFFI
   include KeyboardFFI

   def create_players
     mouse_reset
     sleep 0.5
     MouseFFI.move(1100, 500)
     sleep 0.5
     MouseFFI.left_click

     sleep 0.5

     KeyboardFFI.type('bot2')
     KeyboardFFI.type([:return])
   end

   def create_room
     mouse_reset
     sleep 0.1

     # Move to Channel Input
     MouseFFI.move(1400, 704)
     sleep 0.5
     MouseFFI.left_click
     sleep

     KeyboardFFI.type('room')
     KeyboardFFI.type([:return])
   end

   def mouse_click
     AutoClick.left_click
   end

   def create_main_player
     mouse_reset
     MouseFFI.move(1650, 300)
     sleep 0.5

     # Type user name
     MouseFFI.left_click
     KeyboardFFI.type('bot1')

     sleep 0.5
     # Select Colorbox
     KeyboardFFI.type([:tab])
     sleep 0.5

     KeyboardFFI.type([:right])
     # Delete Existing Input, leaving the # input
     (0..5).each do
       KeyboardFFI.type([:back])
     end

     sleep 0.5

     # Set red
     KeyboardFFI.type('ff0000')
     sleep 0.5

     MouseFFI.move(0, 500)
     sleep 0.5
     MouseFFI.left_click
   end

   def mouse_reset
     MouseFFI.move_absolute(-99999,-99999)
     # AutoClick.mouse_move(START[:x],START[:y])
   end

   def start_game
     mouse_reset
     sleep 0.5
     MouseFFI.move(1400, 450)
     sleep 0.5
     MouseFFI.left_click
   end

   def run_ai
     capture_all
     game_field
     field = image = ChunkyPNG::Image.from_file('field.png')
     
     binding.pry

   end

   def capture_all
     `./boxcutter/boxcutter.exe -f -c -1920,0,1,1200 all.png`
   end

   def game_field
      `./boxcutter/boxcutter.exe -f -c -1285,100,-275,1120 field.png`
   end

   def main_loop
     # require 'pry'; binding.pry

     # create_main_player
     # create_room
     # create_players
     # start_game
     run_ai
     binding.pry
   end
 end
end


Init::main_loop
