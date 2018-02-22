# handle all fake input keyword data

require 'ffi'

module KeyboardFFI
  extend FFI::Library

  ffi_lib 'user32'
  ffi_convention :stdcall

  attach_function :keybd_event, [ :uchar, :uchar, :int, :pointer ], :void

  # delay in seconds between keystrokes
  KEYBD_KEYDELAY = 0.050

  # keybd_event
  KEYBD_EVENT_KEYUP = 2
  KEYBD_EVENT_KEYDOWN = 0

  # MSDN virtual key codes
  BINDING = {
    key_lbutton: 0x01,
    key_rbutton: 0x02,
    key_cancel: 0x03,

    key_back: 0x08,
    key_tab: 0x09,
    key_clear: 0x0c,
    key_return: 0x0d,
    key_shift: 0x10,
    key_control: 0x11,
    key_menu: 0x12,
    key_pause: 0x13,
    key_escape: 0x1b,
    key_space: 0x20,
    key_prior: 0x21,
    key_next: 0x22,
    key_end: 0x23,
    key_home: 0x24,
    key_left: 0x25,
    key_up: 0x26,
    key_right: 0x27,
    key_down: 0x28,
    key_select: 0x29,
    key_execute: 0x2b,
    key_snapshot: 0x2c,
    key_insert: 0x2d,
    key_delete: 0x2e,
    key_help: 0x2f,

    key_0: 0x30,
    key_1: 0x31,
    key_2: 0x32,
    key_3: 0x33,
    key_4: 0x34,
    key_5: 0x35,
    key_6: 0x36,
    key_7: 0x37,
    key_8: 0x38,
    key_9: 0x39,
    key_a: 0x41,
    key_b: 0x42,
    key_c: 0x43,
    key_d: 0x44,
    key_e: 0x45,
    key_f: 0x46,
    key_g: 0x47,
    key_h: 0x48,
    key_i: 0x49,
    key_j: 0x4a,
    key_k: 0x4b,
    key_l: 0x4c,
    key_m: 0x4d,
    key_n: 0x4e,
    key_o: 0x4f,
    key_p: 0x50,
    key_q: 0x51,
    key_r: 0x52,
    key_s: 0x53,
    key_t: 0x54,
    key_u: 0x55,
    key_v: 0x56,
    key_w: 0x57,
    key_x: 0x58,
    key_y: 0x59,
    key_z: 0x5a
  }

  def self.type(array_of_sym)
    if array_of_sym.is_a? String
      array_of_sym.split('').each do |sym|
        # simulate pressing stuff on the keyboard
        virtual_keyboard_key = BINDING["key_#{sym}".to_sym]
        keybd_event(virtual_keyboard_key, 0, KEYBD_EVENT_KEYDOWN, nil);
        keybd_event(virtual_keyboard_key, 0, KEYBD_EVENT_KEYUP, nil);
      end
    else
      array_of_sym.each do |sym|
        # simulate pressing stuff on the keyboard
        virtual_keyboard_key = BINDING["key_#{sym}".to_sym]
        keybd_event(virtual_keyboard_key, 0, KEYBD_EVENT_KEYDOWN, nil);
        keybd_event(virtual_keyboard_key, 0, KEYBD_EVENT_KEYUP, nil);
      end    
    end
  end
end
