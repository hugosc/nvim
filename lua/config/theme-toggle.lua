-- Theme toggle between wal and e-ink
local M = {}

M.current_theme = "wal" -- Default theme is now wal
M.last_wal_mtime = 0

--- Detect if the current wal theme is light or dark based on background brightness
local function detect_wal_background()
  local wal_colors_path = vim.fn.expand("~/.cache/wal/colors-wal.vim")
  
  -- Read the colors file to get the background color
  local file = io.open(wal_colors_path, "r")
  if not file then
    return "dark" -- Default to dark if file doesn't exist
  end
  
  local content = file:read("*a")
  file:close()
  
  -- Extract the background color (hex)
  local background = content:match('let background%s*=%s*"(#%x+)"')
  
  if not background then
    return "dark"
  end
  
  -- Convert hex to RGB and calculate luminance
  local r, g, b = background:match("#(%x%x)(%x%x)(%x%x)")
  if not r then
    return "dark"
  end
  
  r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
  
  -- Calculate relative luminance using standard formula
  -- https://www.w3.org/TR/WCAG20/#relativeluminancedef
  local function get_linear(c)
    c = c / 255
    if c <= 0.03928 then
      return c / 12.92
    else
      return math.pow((c + 0.055) / 1.055, 2.4)
    end
  end
  
  local luminance = 0.2126 * get_linear(r) + 0.7152 * get_linear(g) + 0.0722 * get_linear(b)
  
  -- If background luminance is high (bright background), the theme is light
  -- If background luminance is low (dark background), the theme is dark
  return luminance > 0.5 and "light" or "dark"
end

--- Toggle between wal and e-ink colorscheme
M.toggle_theme = function()
  if M.current_theme == "wal" then
    -- Switch to e-ink
    vim.o.background = "dark"
    vim.cmd.colorscheme("e-ink")
    M.current_theme = "e-ink"
    vim.notify("Switched to e-ink colorscheme", vim.log.levels.INFO)
  else
    -- Switch to wal
    local background = detect_wal_background()
    vim.o.background = background
    vim.cmd.colorscheme("wal")
    M.current_theme = "wal"
    vim.notify("Switched to wal colorscheme (" .. background .. ")", vim.log.levels.INFO)
  end
end

--- Set up file watcher for hot-reloading wal colors
M.setup_wal_watcher = function()
  local wal_colors_path = vim.fn.expand("~/.cache/wal/colors-wal.vim")
  local debounce_timer = nil
  
  -- Set initial background on startup
  local stat = vim.loop.fs_stat(wal_colors_path)
  if stat then
    M.last_wal_mtime = stat.mtime.sec
    local background = detect_wal_background()
    vim.o.background = background
  end
  
  -- Use fs_event for efficient filesystem watching (no polling)
  local fs_event = vim.loop.new_fs_event()
  if not fs_event then
    return
  end
  
  local reload_wal = function(err, filename, events)
    if err then
      return
    end
    
    -- Only reload if we're using wal theme
    if M.current_theme ~= "wal" then
      return
    end
    
    -- Cancel any pending reload
    if debounce_timer then
      debounce_timer:stop()
      debounce_timer:close()
    end
    
    -- Debounce: wait 500ms for all file updates to complete
    -- (wal writes, then darken-color0 modifies, then regenerate-wal-templates writes)
    debounce_timer = vim.loop.new_timer()
    debounce_timer:start(500, 0, vim.schedule_wrap(function()
      local current_stat = vim.loop.fs_stat(wal_colors_path)
      if current_stat and current_stat.mtime.sec > M.last_wal_mtime then
        M.last_wal_mtime = current_stat.mtime.sec
        
        pcall(function()
          local background = detect_wal_background()
          vim.o.background = background
          vim.cmd.colorscheme("wal")
        end)
      end
      
      debounce_timer:close()
      debounce_timer = nil
    end))
  end
  
  -- Start watching the file for changes
  fs_event:start(wal_colors_path, {}, reload_wal)
end

return M
