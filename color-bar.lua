local ffi = require('ffi')
local tb = require('termbox')

local uni = ffi.new("uint32_t[1]")
local function decodeUtf8(str)
  local i = 1
  local codes = {}
  while i <= #str do
    i = i + tb.tb_utf8_char_to_unicode(uni, str:sub(i))
    codes[#codes + 1] = uni[0]
  end
  return codes
end

local corners = decodeUtf8("╭╮╰╯")

local random = math.random
local x = 1
local y = 1
local mx = 1
local my = 1
local c = 100


-- hue is in range 0-360
-- brightness is in range 0-360
local function wheel(hue, brightness)
  local r, g, b

  -- Apply hue
  hue = hue % 360

  r = math.abs(540 - hue * 3) - 180
  hue = (hue + 120) % 360
  g = math.abs(540 - hue * 3) - 180
  hue = (hue + 120) % 360
  b = math.abs(540 - hue * 3) - 180

  if brightness < 180 then
    r = r * brightness / 180
    g = g * brightness / 180
    b = b * brightness / 180
  else
    r = 360 - (360 - r) * (180 - (brightness - 180)) / 180
    g = 360 - (360 - g) * (180 - (brightness - 180)) / 180
    b = 360 - (360 - b) * (180 - (brightness - 180)) / 180
  end

  -- r = r + random(61) - 30
  -- g = g + random(61) - 30
  -- b = b + random(61) - 30

  -- Convert to 216 color space
  r = math.min(math.max(math.floor(r / 60), 0), 5)
  g = math.min(math.max(math.floor(g / 60), 0), 5)
  b = math.min(math.max(math.floor(b / 60), 0), 5)
  return 0x10 + r + g * 6 + b * 36

end

tb.tb_init()
tb.tb_select_output_mode(tb.TB_OUTPUT_256)
local w, h = tb.tb_width(), tb.tb_height()

local fx = 360 / (w - 1)
local fy = 360 / (h - 1)

local o = 0
local event = ffi.new("struct tb_event")
repeat

  o = (o + 3) % 360

  tb.tb_clear()

  for y = 0, h - 1 do
    for x = 0, w - 1 do
      tb.tb_change_cell(x, y, 0, 0, wheel(x * fx + o, y * fy))
    end
  end

  tb.tb_present()

  tb.tb_peek_event(event, 50)
until event.key == 27 and event.type == 1

tb.tb_shutdown()
