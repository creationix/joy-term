-- "gamepad" module works much better with jit off.
local jit = require('jit')
jit.off()
local G = require('gamepad')

local ffi = require('ffi')
local tb = require('termbox')
local uv = require('uv')

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

░░░▄▄█▀▀▀▀▀▀▀▀█▄▄░░░
░░█▀░▄▄█▀▀▀▀█▄▄░▀█░░
░░█░░█▄▄▀▀▀▀▄▄█░░█░░
░░▀█▄▄░▀▀▀▀▀▀░▄▄█▀░░
░░░▄▄▀▀▀█▀▀█▀▀▀▄▄░░░
░░█░▄▀▀▄█░░█▄▀▀▄░█░░
░░▀▄░▀▄░█░░█░▄▀░▄▀░░
░░░░▀▀▄█▄▄▄▄█▄▀▀░░░░

U+270x      ✁   ✂   ✃   ✄   ✅   ✆   ✇   ✈   ✉   ✊   ✋   ✌   ✍   ✎   ✏
U+271x  ✐   ✑   ✒   ✓   ✔   ✕   ✖   ✗   ✘   ✙   ✚   ✛   ✜   ✝   ✞   ✟
U+272x  ✠   ✡   ✢   ✣   ✤   ✥   ✦   ✧   ✨   ✩   ✪   ✫   ✬   ✭   ✮   ✯
U+273x  ✰   ✱   ✲   ✳   ✴   ✵   ✶   ✷   ✸   ✹   ✺   ✻   ✼   ✽   ✾   ✿
U+274x  ❀   ❁   ❂   ❃   ❄   ❅   ❆   ❇   ❈   ❉   ❊   ❋   ❌   ❍   ❎   ❏
U+275x  ❐   ❑   ❒   ❓   ❔   ❕   ❖   ❗   ❘   ❙   ❚   ❛   ❜   ❝   ❞   ❟
U+276x  ❠   ❡   ❢   ❣   ❤   ❥   ❦   ❧   ❨   ❩   ❪   ❫   ❬   ❭   ❮   ❯
U+277x  ❰   ❱   ❲   ❳   ❴   ❵   ❶   ❷   ❸   ❹   ❺   ❻   ❼   ❽   ❾   ❿
U+278x  ➀   ➁   ➂   ➃   ➄   ➅   ➆   ➇   ➈   ➉   ➊   ➋   ➌   ➍   ➎   ➏
U+279x  ➐   ➑   ➒   ➓   ➔   ➕   ➖   ➗   ➘   ➙   ➚   ➛   ➜   ➝   ➞   ➟
U+27Ax  ➠   ➡   ➢   ➣   ➤   ➥   ➦   ➧   ➨   ➩   ➪   ➫   ➬   ➭   ➮   ➯
U+27Bx  ➰   ➱   ➲   ➳   ➴   ➵   ➶   ➷   ➸   ➹   ➺   ➻   ➼   ➽   ➾   ➿

U+250x  ─   ━   │   ┃   ┄   ┅   ┆   ┇   ┈   ┉   ┊   ┋   ┌   ┍   ┎   ┏
U+251x  ┐   ┑   ┒   ┓   └   ┕   ┖   ┗   ┘   ┙   ┚   ┛   ├   ┝   ┞   ┟
U+252x  ┠   ┡   ┢   ┣   ┤   ┥   ┦   ┧   ┨   ┩   ┪   ┫   ┬   ┭   ┮   ┯
U+253x  ┰   ┱   ┲   ┳   ┴   ┵   ┶   ┷   ┸   ┹   ┺   ┻   ┼   ┽   ┾   ┿
U+254x  ╀   ╁   ╂   ╃   ╄   ╅   ╆   ╇   ╈   ╉   ╊   ╋   ╌   ╍   ╎   ╏
U+255x  ═   ║   ╒   ╓   ╔   ╕   ╖   ╗   ╘   ╙   ╚   ╛   ╜   ╝   ╞   ╟
U+256x  ╠   ╡   ╢   ╣   ╤   ╥   ╦   ╧   ╨   ╩   ╪   ╫   ╬   ╭   ╮   ╯
U+257x  ╰   ╱   ╲   ╳   ╴   ╵   ╶   ╷   ╸   ╹   ╺   ╻   ╼   ╽   ╾   ╿

U+258x  ▀   ▁   ▂   ▃   ▄   ▅   ▆   ▇   █   ▉   ▊   ▋   ▌   ▍   ▎   ▏
U+259x  ▐   ░   ▒   ▓   ▔   ▕   ▖   ▗   ▘   ▙   ▚   ▛   ▜   ▝   ▞   ▟

U+25Ax  ■   □   ▢   ▣   ▤   ▥   ▦   ▧   ▨   ▩   ▪   ▫   ▬   ▭   ▮   ▯
U+25Bx  ▰   ▱   ▲   △   ▴   ▵   ▶   ▷   ▸   ▹   ►   ▻   ▼   ▽   ▾   ▿
U+25Cx  ◀   ◁   ◂   ◃   ◄   ◅   ◆   ◇   ◈   ◉   ◊   ○   ◌   ◍   ◎   ●
U+25Dx  ◐   ◑   ◒   ◓   ◔   ◕   ◖   ◗   ◘   ◙   ◚   ◛   ◜   ◝   ◞   ◟
U+25Ex  ◠   ◡   ◢   ◣   ◤   ◥   ◦   ◧   ◨   ◩   ◪   ◫   ◬   ◭   ◮   ◯
U+25Fx  ◰   ◱   ◲   ◳   ◴   ◵   ◶   ◷   ◸   ◹   ◺   ◻   ◼   ◽   ◾   ◿

U+219x  ←   ↑   →   ↓   ↔   ↕   ↖   ↗   ↘   ↙   ↚   ↛   ↜   ↝   ↞   ↟
U+21Ax  ↠   ↡   ↢   ↣   ↤   ↥   ↦   ↧   ↨   ↩   ↪   ↫   ↬   ↭   ↮   ↯
U+21Bx  ↰   ↱   ↲   ↳   ↴   ↵   ↶   ↷   ↸   ↹   ↺   ↻   ↼   ↽   ↾   ↿
U+21Cx  ⇀   ⇁   ⇂   ⇃   ⇄   ⇅   ⇆   ⇇   ⇈   ⇉   ⇊   ⇋   ⇌   ⇍   ⇎   ⇏
U+21Dx  ⇐   ⇑   ⇒   ⇓   ⇔   ⇕   ⇖   ⇗   ⇘   ⇙   ⇚   ⇛   ⇜   ⇝   ⇞   ⇟
U+21Ex  ⇠   ⇡   ⇢   ⇣   ⇤   ⇥   ⇦   ⇧   ⇨   ⇩   ⇪   ⇫   ⇬   ⇭   ⇮   ⇯
U+21Fx  ⇰   ⇱   ⇲   ⇳   ⇴   ⇵   ⇶   ⇷   ⇸   ⇹   ⇺   ⇻   ⇼   ⇽   ⇾   ⇿

U+27Cx  ⟀   ⟁   ⟂   ⟃   ⟄   ⟅   ⟆   ⟇   ⟈   ⟉   ⟊   ⟋   ⟌   ⟍   ⟎   ⟏
U+27Dx  ⟐   ⟑   ⟒   ⟓   ⟔   ⟕   ⟖   ⟗   ⟘   ⟙   ⟚   ⟛   ⟜   ⟝   ⟞   ⟟
U+27Ex  ⟠   ⟡   ⟢   ⟣   ⟤   ⟥   ⟦   ⟧   ⟨   ⟩   ⟪   ⟫   ⟬   ⟭   ⟮   ⟯

U+2B0x  ⬀   ⬁   ⬂   ⬃   ⬄   ⬅   ⬆   ⬇   ⬈   ⬉   ⬊   ⬋   ⬌   ⬍   ⬎   ⬏
U+2B1x  ⬐   ⬑   ⬒   ⬓   ⬔   ⬕   ⬖   ⬗   ⬘   ⬙   ⬚   ⬛   ⬜   ⬝   ⬞   ⬟
U+2B2x  ⬠   ⬡   ⬢   ⬣   ⬤   ⬥   ⬦   ⬧   ⬨   ⬩   ⬪   ⬫   ⬬   ⬭   ⬮   ⬯
U+2B3x  ⬰   ⬱   ⬲   ⬳   ⬴   ⬵   ⬶   ⬷   ⬸   ⬹   ⬺   ⬻   ⬼   ⬽   ⬾   ⬿
U+2B4x  ⭀   ⭁   ⭂   ⭃   ⭄   ⭅   ⭆   ⭇   ⭈   ⭉   ⭊   ⭋   ⭌
U+2B5x  ⭐   ⭑   ⭒   ⭓   ⭔   ⭕   ⭖   ⭗   ⭘   ⭙

U+1F70x   🜀   🜁   🜂   🜃   🜄   🜅   🜆   🜇   🜈   🜉   🜊   🜋   🜌   🜍   🜎   🜏
U+1F71x   🜐   🜑   🜒   🜓   🜔   🜕   🜖   🜗   🜘   🜙   🜚   🜛   🜜   🜝   🜞   🜟
U+1F72x   🜠   🜡   🜢   🜣   🜤   🜥   🜦   🜧   🜨   🜩   🜪   🜫   🜬   🜭   🜮   🜯
U+1F73x   🜰   🜱   🜲   🜳   🜴   🜵   🜶   🜷   🜸   🜹   🜺   🜻   🜼   🜽   🜾   🜿
U+1F74x   🝀   🝁   🝂   🝃   🝄   🝅   🝆   🝇   🝈   🝉   🝊   🝋   🝌   🝍   🝎   🝏
U+1F75x   🝐   🝑   🝒   🝓   🝔   🝕   🝖   🝗   🝘   🝙   🝚   🝛   🝜   🝝   🝞   🝟
U+1F76x   🝠   🝡   🝢   🝣   🝤   🝥   🝦   🝧   🝨   🝩   🝪   🝫   🝬   🝭   🝮   🝯
U+1F77x   🝰   🝱   🝲   🝳

local level = {
  "          ",
  "          ",
  "          ",
  "          ",
  "          ",
  "          ",
}


local chars = ffi.new("uint32_t[6]")
tb.tb_utf8_char_to_unicode(chars, "░")
tb.tb_utf8_char_to_unicode(chars + 1, "▒")
tb.tb_utf8_char_to_unicode(chars + 2, "▓")
tb.tb_utf8_char_to_unicode(chars + 3, "█")
tb.tb_utf8_char_to_unicode(chars + 4, "▀")
tb.tb_utf8_char_to_unicode(chars + 5, "▄")

tb.tb_init()
tb.tb_select_output_mode(tb.TB_OUTPUT_256)

local event = ffi.new("struct tb_event")
local interval = uv.new_timer()
local j = 0
interval:start(33, 33, function ()
  tb.tb_clear()
  local w, h = tb.tb_width(), tb.tb_height()
  for y = 1, h do
    for x = 1, w do
      tb.tb_change_cell(x, y, chars[((x + y) % 6)], ((x + j) % 216) + 0x10, ((y + j) % 216) + 0x10)
    end
  end

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



