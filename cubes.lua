
local ffi = require('ffi')
local tb = require('termbox')

local uni = ffi.new("uint32_t[1]")
local function write(string, x, y, fg, bg)
  local i, l = 1, #string
  while i <= l do
    i = i + tb.tb_utf8_char_to_unicode(uni, string:sub(i))
    tb.tb_change_cell(x, y, uni[0], fg, bg)
    x = x + 1
  end
end


tb.tb_init()
tb.tb_select_output_mode(tb.TB_OUTPUT_256)

local function pixel(x, y, c)
  tb.tb_change_cell(x * 2, y, 32, 0, c)
  tb.tb_change_cell(x * 2 + 1, y, 32, 0, c)
end

tb.tb_clear()
write("System colors:", 0, 0, 15, 0)
for y = 0, 1 do
  for x = 0, 7 do
    pixel(x, y + 1, x + y * 8)
  end
end

write("Color cube, 6x6x6:", 0, 4, 15, 0)
for z = 0, 5 do
  for y = 0, 5 do
    for x = 0, 5 do
      pixel(x + z * 7, y + 5, 0x10 + x + y * 6 + z * 36)
    end
  end
end

write("Grayscale ramp:", 0, 12, 15, 0)
for x = 0, 23 do
  pixel(x, 13, x + 232)
end

write("Pres ESC to exit program", 0, 15, 8, 0)

tb.tb_present()

-- Wait for esc to be pressed
local event = ffi.new("struct tb_event")
repeat
  tb.tb_peek_event(event, 13)
until event.key == 27 and event.type == 1
tb.tb_shutdown()


