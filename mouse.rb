# handle all fake input keyword data

require 'ffi'

module MouseFFI

  extend FFI::Library
  ffi_lib 'user32'
  ffi_convention :stdcall

  MOUSEEVENTF_MOVE = 0x0001
  MOUSEEVENTF_LEFTDOWN = 0x0002
  MOUSEEVENTF_ABSOLUTE = 0x8000
  MOUSEEVENTF_LEFTUP = 0x0004

  attach_function :mouse_event, [ :uint, :uint, :uint, :uint, :pointer], :void

  def self.move(x, y)
    mouse_event(MOUSEEVENTF_MOVE, x, y, 0, nil)
  end

  def self.move_absolute(x, y)
    mouse_event(MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, x, y, 0, nil)
  end

  def self.left_click
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, nil)
    sleep 0.1
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, nil)
  end
end
