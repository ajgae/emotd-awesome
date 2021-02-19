------------------------------------------------------------------
-- `emotd` - A SIMPLE `awesome` WIDGET THAT HELPS YOU DEVELOP
-- YOUR EMOTIONAL LITERACY
--
-- Whenever you feel like it, scroll through random feeling
-- words until you find one that describes your current mood.
--
-- @author: categorille @ protonmail dot com
-- @copyleft 2021 categorille
------------------------------------------------------------------

-- awesome widgets API
local wibox = require("wibox")

local HOME_DIR = os.getenv("HOME") .. "/"
local WORDS_FILE_DEFAULT = HOME_DIR .. ".emotd_words"

------------UTILITY FUNCTIONS------------
-- increments an array index modulo `mod` with
-- indexing starting at 1
local function increment(index, mod)
    local result = (index + 1) % (mod + 1)
    if result == 0 then
        result = 1
    end
    return result
end

-- decrements an array index modulo `mod` with
-- indexing starting at 1
local function decrement(index, mod)
    local result = index - 1
    if result < 1 then
        result = mod
    end
    return result
end


-----------WORKER FUNCTION------------
local emotd_widget = {}
local function worker(user_args)
    -- Handle user arguments
    local args = user_args or {}
    local words_file = args.words_file or WORDS_FILE_DEFAULT
    local prefix = args.prefix or ""
    local suffix = args.suffix or ""
    local hist_count = args.hist_count or 10

    -- Returns the text as it should be displayed in the widget
    local function render_text(text)
        return prefix .. text .. suffix
    end

    -- Returns a random line from the words_file
    local function get_random_word()
        local word
        repeat -- Find a random non-comment, non-empty line
            -- this uses `shuf` from the GNU coreutils to get a random line
            local f = assert(io.popen("shuf " .. words_file, "r"))
            word = f:read("*l")
        until not(word == "") and not(word:match("^[ \t]*#.*"))
        return word
    end

    -- Keep track of history
    -- TODO find a better history system, currently moving
    -- cycling an array modulo hist_count
    -- FIXME current history system not working, first right
    -- click does nothing
    local hist = {}
    local hist_index = 1
    for i = 2, hist_count do
        hist[i] = 0
    end

    do
        local init_word = get_random_word()
        hist[1] = init_word
        -- Build the widget
        emotd_widget = wibox.widget {
            text = render_text(init_word),
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        }
    end

    emotd_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 1 or button == 3) then
            local result
            if button == 1 then -- New random word
                local word = get_random_word()
                hist_index = increment(hist_index, hist_count)
                hist[hist_index] = word
                result = word
            elseif button == 3 then -- Move back in history
                if not (#hist < 1) then
                    hist_index = decrement(hist_index, hist_count)
                    result = hist[hist_index]
                end
            end
            emotd_widget.text = render_text(result)
        end
    end)

    return emotd_widget
end

return setmetatable(emotd_widget, {
    __call = function(_self, ...)
        return worker(...)
    end
})
