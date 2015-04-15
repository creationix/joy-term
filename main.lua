-- "gamepad" module works much better with jit off.
local jit = require('jit')
jit.off()

local ffi = require('ffi')
local tb = require('termbox')
local uv = require('uv')
local G = require('gamepad')

local uni = ffi.new("uint32_t[1]")
local function write(string, x, y, fg, bg)
  local i, l = 1, #string
  while i <= l do
    i = i + tb.tb_utf8_char_to_unicode(uni, string:sub(i))
    tb.tb_change_cell(x, y, uni[0], fg, bg)
    x = x + 1
  end
end

G.Gamepad_init()
local axes = {0,0,0,0,0,0}
G.Gamepad_axisMoveFunc(function (_, axis, value)
  axes[axis + 1] = value
end, nil)

tb.tb_init()
tb.tb_select_output_mode(tb.TB_OUTPUT_256)

local event = ffi.new("struct tb_event")
local interval = uv.new_timer()
local j = 0
interval:start(33, 33, function ()
  tb.tb_clear()
  j = (j + 1) % 216
  write(string.format("%d", uv.hrtime()), 1, 1, 0x10 + j, 0)
  for i = 1, #axes do
    local value = axes[i]
    if value < 0.01 and value > -0.01 then
      value = 0
    end
    write(string.format("Axis: %d value: %f", i, value), 1, 1 + i, value < 0 and 2 or 3, 0)
  end
  tb.tb_present()
  G.Gamepad_processEvents()
  tb.tb_peek_event(event, 13)
  if event.key == 27 and event.type == 1 then
    tb.tb_shutdown()
    interval:close()
  end
end)
