# Setting up environment for training the model


require 'pry'
require_relative 'keyboard.rb'
require_relative 'mouse.rb'

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

   def create_room
     mouse_reset
     sleep 0.1

     # Move to Channel Input
     MouseFFI.move(1400, 704)
     sleep 0.1

     # Focus Channel Input
     MouseFFI.left_click
     sleep 0.1

     # Type Channel Name
     KeyboardFFI.type('bot')

     # Select "+" Button
     MouseFFI.move(100, 0)

     # Create Room
     MouseFFI.left_click
   end

   def mouse_click
     AutoClick.left_click
   end

   def create_players
     mouse_reset
     MouseFFI.move(1650, 300)
     sleep 0.5
     MouseFFI.left_click
     KeyboardFFI.type('bot1')
     binding.pry
     MouseFFI.move()
     PLAYERS.each do |player|

     end
   end

   def mouse_reset
     MouseFFI.move_absolute(-99999,-99999)
     # AutoClick.mouse_move(START[:x],START[:y])
   end

   def main_loop
     # require 'pry'; binding.pry

     create_room
     create_players
     while true
       print mouse_coordinates
       puts

       sleep 1
     end
   end
 end
end


Init::main_loop
