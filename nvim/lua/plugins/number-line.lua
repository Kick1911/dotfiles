-- Utility: clamp a number between min and max
local function clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

-- Utility: linearly interpolate between a and b by t
local function lerp(a, b, t)
  return a + (b - a) * t
end

-- Convert RGB to hex string
local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Compute gradient colour from green → yellow → red
local function gradient_colour(ratio)
  local r, g, b, t
  if ratio < 0.5 then
    -- green (0,255,0) to yellow (255,255,0)
    t = ratio / 0.5
    r = lerp(0, 255, t)
    g = 255
    b = 0
  else
    -- yellow (255,255,0) to red (255,0,0)
    t = (ratio - 0.5) / 0.5
    r = 255
    g = lerp(255, 0, t)
    b = 0
  end

  -- Now darken slightly as you scroll down, but not below background brightness
  local bg_min = 0x26 -- background channel (38)
  local darken_factor = lerp(1.0, 0.6, ratio) -- never go below 60% brightness
  r = clamp(math.floor(r * darken_factor), bg_min, 255)
  g = clamp(math.floor(g * darken_factor), bg_min, 255)
  b = clamp(math.floor(b * darken_factor), bg_min, 255)

  return rgb_to_hex(r, g, b)
end

function NumberLineColour()
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local total = vim.api.nvim_buf_line_count(0)
  local ratio = r / math.max(total, 1)
  local colour = gradient_colour(ratio)
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colour, bold = true })
end

vim.cmd [[
set cursorline
set relativenumber
set cursorlineopt=both
]]

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = NumberLineColour,
  group = vim.api.nvim_create_augroup("DynamicNumberColour", { clear = true }),
})
