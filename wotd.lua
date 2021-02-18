------------------------------------------------------------------
-- Feeling Word Of The Day for Awesome Window Manager
--
-- Scroll through random feeling words until you find one that
-- describes your mood :)
--
-- A word is a single line retrieved from a text file, which is
-- by default the directory where this lua file is found.
-- Might have to adjust that manually (look for the 
-- WORD_FILE_DEFAULT variable).
--
-- In the word file, empty lines and lines whose first
-- non-whitespace character is a '#' will be skipped.
--
-- @author: categorille @ protonmail dot com
-- @copyleft 2021 categorille
------------------------------------------------------------------

-- awesome widgets API
local wibox = require("wibox")

local HOME = os.getenv("HOME")
local WIDGET_DIR = HOME .. "/.config/awesome/my-widgets/"
local WORD_FILE_DEFAULT = WIDGET_DIR .. "words.txt"

------------UTILITY FUNCTIONS------------
local function increment(index, mod)
    local result = (index + 1) % (mod + 1)
    if result == 0 then
        result = 1
    end
    return result
end

local function decrement(index, mod)
    local result = index - 1
    if result <= 0 then
        result = mod
    end
    return result
end


-----------WORKER FUNCTION------------
local wotd_widget = {}
local function worker(user_args)
    -- Handle user arguments
    local args = user_args or {}
    local word_file = args.word_file or WORD_FILE_DEFAULT
    local prefix = args.prefix or ""
    local suffix = args.suffix or ""
    local hist_count = args.hist_count or 5

    -- returns the text with pretties added
    local function render_text(text)
        return prefix .. text .. suffix
    end

    -- returns a random line from the word_file
    local function get_random_word()
        local word
        repeat -- Find a random non-comment, non-empty line
            local f = io.popen("shuf " .. word_file, "r")
            word = f:read("*l")
        until not(word == "") and not(word:match("^[ \t]*#.*"))
        return word
    end

    -- Keep track of history
    -- TODO find a better history system, currently moving
    -- through an array mod hist_count
    local hist = {}
    local hist_index = 2

    do
        local init_word = get_random_word()
        hist[1] = init_word
        for i = 2, hist_count do
            hist[i] = 0
        end
        -- Build the widget
        wotd_widget = wibox.widget {
            text = render_text(init_word),
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        }
    end

    wotd_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 1 or button == 3) then
            local result
            if button == 1 then -- New random word
                local word = get_random_word()
                hist[hist_index] = word
                hist_index = increment(hist_index, hist_count)
                result = word
            elseif button == 3 then -- Move back in history
                if not (#hist < 1) then
                    hist_index = decrement(hist_index, hist_count)
                    result = hist[hist_index]
                end
            end
            wotd_widget.text = render_text(result)
        end
    end)

    return wotd_widget
end

return setmetatable(wotd_widget, {
    __call = function(_self, ...)
        return worker(...)
    end
})
