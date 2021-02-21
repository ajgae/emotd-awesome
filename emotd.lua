------------------------------------------------------------------
-- `emotd` - A SIMPLE `awesome` WIDGET THAT HELPS YOU DEVELOP
-- YOUR EMOTIONAL LITERACY
--
-- Whenever you feel like it, scroll through random feeling
-- words until you find one that describes your current mood.
--
-- @author: categorille at protonmail dot com
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

    -- Cyclic array modulo `hist_count` containing recent words
    local hist = {}
    -- Current index we are at in the history array
    -- (always `1 <= hist_index <= hist_count`)
    local hist_index = 1
    -- How far back we are in history, 1 means not in history
    local hist_back_index = 1

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

    -- React to clicks
    emotd_widget:connect_signal("button::press", function(_, _, _, button)
        -- Only react to right and left clicks
        if (button == 1 or button == 3) then
            local result
            -- Left click
            if button == 1 then
                hist_index = increment(hist_index, hist_count)
                -- New random word, overriding the oldest history slot
                if hist_back_index == 1 then 
                    local word = get_random_word()
                    hist[hist_index] = word
                    result = word
                -- Go forward existing history
                else 
                    hist_back_index = hist_back_index - 1
                    result = hist[hist_index]
                end
            -- Right click, go back history
            elseif button == 3 then
                -- Can't go back further than `hist_count`
                if not (hist_back_index == hist_count)
                -- Can't go back if there is no history
                   and not (hist[decrement(hist_index, hist_count)] == nil)
                   then
                    hist_back_index = hist_back_index + 1
                    hist_index = decrement(hist_index, hist_count)
                end
                result = hist[hist_index]
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
