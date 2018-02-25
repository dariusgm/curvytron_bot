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
     puts 'creating player 2'
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
     sleep 0.5

     KeyboardFFI.type('room')
     KeyboardFFI.type([:return])
   end

   def mouse_click
     AutoClick.left_click
   end

   def create_main_player
     puts 'creating main player'
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
     puts 'starting the game'
     mouse_reset
     sleep 0.5
     MouseFFI.move(1400, 450)
     sleep 0.5
     MouseFFI.left_click
   end

   def get_init_position
     image = ChunkyPNG::Image.from_file('field.png')


     count_x = {}
     pos_x = 0

     count_y = {}
     pos_y = 0
     # Searching Player init position.
     (0..image.width).each do |x|
       (0..image.height).each do |y|
         # puts "searching pixel on #{x}/#{y}"
         pixel = image.get_pixel(x, y)
          if pixel == 4278190335
            count_x[x] = count_x.fetch(x, 0) + 1
            count_y[y] = count_y.fetch(y, 0) + 1
          end
       end
     end

     max_pixels_x = count_x.values.max
     max_pixels_y = count_y.values.max


     positions_x = []
     count_x.each do |k,v|
       if (v == max_pixels_x)
         positions_x << k
       end
     end

     positions_y = []
     count_y.each do |k,v|
       if (v == max_pixels_y)
         positions_y << k
       end
     end

     # Now in positions_x and positions_y are all pixel coordinates of the init circle of the player

     # get correct pixels
     beginning = [ positions_x.sort[positions_x.size / 2], positions_y.sort[positions_y.size / 2] ]
     puts "extracted beginning pixels of player: #{beginning}"
     beginning
   end

   def get_direction(beginning_x, beginning_y)
     image = ChunkyPNG::Image.from_file('field.png')

     count_x = {}
     pos_x = 0

     count_y = {}
     pos_y = 0

     # seach now the angle arrow within 56px of the middle. skip the size of the circle itself (10px from beginning_x and beginning_y)
     ((beginning_x - 56)..(beginning_x + 56)).each do |x|
       ((beginning_y - 56)..(beginning_x + 56)).each do |y|
         if (beginning_x - 10 < x && beginning_x + 10 < x && beginning_y - 10 < y  && beginning_y + 10)
         # puts "searching pixel on #{x}/#{y}"
           pixel = image.get_pixel(x, y)
            if pixel == 4278190335
              count_x[x] = count_x.fetch(x, 0) + 1
              count_y[y] = count_y.fetch(y, 0) + 1
            end
          end
       end
     end

     max_pixels_x = count_x.values.max
     max_pixels_y = count_y.values.max


     positions_x = []
     count_x.each do |k,v|
       if (v == max_pixels_x)
         positions_x << k
       end
     end

     positions_y = []
     count_y.each do |k,v|
       if (v == max_pixels_y)
         positions_y << k
       end
     end

     direction = [ positions_x.sort[positions_x.size / 2], positions_y.sort[positions_y.size / 2] ]
   end

   def run_ai
     beginning_x, beginning_y = get_init_position
     direction_x, direction_y = get_direction(beginning_x, beginning_y)

     # http://onlinemschool.com/math/library/vector/angl/
     upperpart = beginning_x * direction_x + beginning_y * direction_y
     lowerpart = Math.sqrt((beginning_x**2)+(beginning_y**2))*Math.sqrt((direction_x**2) + (direction_y**2))
     # calculate angle
     angle = upperpart / lowerpart
     binding.pry


   end

   def user_created?
     `./boxcutter/boxcutter.exe -f -c -100,120,-75,150 player.png`
    image = ChunkyPNG::Image.from_file('player.png')
    # Check if there is a lot of red in the second line "FF0000FF" (red) = 4278190335
    line = image.row(1)
    (0...13).each do |index|
      return false unless line[index] == 4278190335
    end

    puts 'player exists'
    true
   end

   def capture_all
     `./boxcutter/boxcutter.exe -f -c -1920,0,1,1200 all.png`
   end

   def game_field
      `./boxcutter/boxcutter.exe -f -c -1285,100,-275,1120 field.png`
   end

   def main_loop
     unless (user_created?)
       create_main_player
     end

     # create_room
     # create_players
     # start_game
     # capture_all
     # game_field
     # run_ai
     binding.pry
   end
 end
end


# Init::main_loop
Init::run_ai
