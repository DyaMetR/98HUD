--[[------------------------------------------------------------------
  Progress bar components
]]--------------------------------------------------------------------

if SERVER then return end

--[[------------------------------------------------------------------
  Draws the foreground of a segmented bar
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {number} segment size
  @param {number} margin
  @param {number} percentage
  @param {Color} colour
  @param {boolean} is it vertical
]]--------------------------------------------------------------------
local function segmentBar(x, y, w, h, segmentSize, margin, percentage, colour, vertical)
  local size = w
  if vertical then size = h end
  local segments = ((size + margin) / (segmentSize + margin)) * percentage
  for i=1, segments do
    local segment = (segmentSize + margin)
    if not vertical then
      draw.RoundedBox(0, x + (segment * (i - 1)), y, segmentSize, h, colour)
    else
      draw.RoundedBox(0, x, y + h + margin - (segment * i), w, segmentSize, colour)
    end
  end
end

--[[------------------------------------------------------------------
  Draws a percentage progress bar
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {number} percentage
  @param {string} text to show
  @param {Color} primary colour
  @param {Color} secondary colour
  @param {boolean} is it vertical
  @param {string} font
  @param {Color} colour
]]--------------------------------------------------------------------
function W98HUD.COMPONENTS:progressBar(x, y, w, h, percentage, background, colour1, colour2, vertical, text, font, fontColour)
  local value = math.min(percentage, 1)
  -- draw background
  draw.RoundedBox(0, x, y, w, h, colour2)
  -- draw foreground
  if not vertical then
    draw.RoundedBox(0, x, y, w * value, h, colour1)
  else
    local size = math.Round(h * value)
    draw.RoundedBox(0, x, y + h - size, w, size, colour1)
  end
  -- draw percentage
  if font then
    local x1, y1, x2, y2 = x, y, x + (w * value), y + h
    if vertical then
      y1 = y + (h * (1 - value))
      x2 = x + w
    end
    -- foreground font
    render.SetScissorRect(x1, y1, x2, y2, true)
    draw.SimpleText(text, font, x + (w * .5), y + (h * .5), colour2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    render.SetScissorRect(0, 0, 0, 0, false)
    -- get background position and size
    if not vertical then
      x1 = x2
      x2 = x + w
    else
      y1 = y
      y2 = y + (h * (1 - value))
    end
    -- background font
    render.SetScissorRect(x1, y1, x2, y2, true)
    draw.SimpleText(text, font, x + (w * .5), y + (h * .5), fontColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    render.SetScissorRect(0, 0, 0, 0, false)
  end
  -- draw border
  W98HUD.COMPONENTS:windowBorder(x, y, w, h, background, true)
end



--[[------------------------------------------------------------------
  Draws a segmented percentage bar
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {number} percentage
  @param {Color} primary colour
  @param {boolean} is it vertical
  @param {boolean} use non simple borders
  @param {Color} colour used for non simple border background
]]--------------------------------------------------------------------
function W98HUD.COMPONENTS:segmentBar(x, y, w, h, percentage, background, colour1, vertical, nonSimple, background2)
  local value = math.min(percentage, 1)
  -- draw border
  local margin = 0
  if nonSimple then
    draw.RoundedBox(0, x, y, w, h, background2)
    margin = W98HUD.COMPONENTS:windowBorder(x, y, w, h, background, true)
  else
    margin = W98HUD.COMPONENTS:simpleBorder(x, y, w, h, background, true)
  end
  -- draw foreground
  if percentage > 0 then
    local segSize, segMargin = 6, 2
    local borderMargin = margin + 1
    if nonSimple then segMargin = 1 end
    segmentBar(x + borderMargin, y + borderMargin, w - (borderMargin * 2), h - (borderMargin * 2), segSize, segMargin, value, colour1, vertical)
  end
end
