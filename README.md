## `emotd` - a simple `awesome` widget that helps you develop your emotional literacy

`emotd` is a simple and sweet widget for the `awesome` X11 window manager. It displays a feeling word, picked at random from a user-defined text file, in your `awesome` status bar.

You can set the word to another random word by simply clicking on the widget. The idea is that you can cycle through different words until you find one that describes your current mood.

`emotd` stands for "emotion of the day". Credits to my dad for finding this name.

### installation

Once you have the code somewhere on your filesystem, installing is easy.
1. Copy the `.emotd_words` file to your home folder (`~/`).
2. Your `rc.lua` awesome config file is, by default, found in the `~/.config/awesome/` directory.
3. In that directory, create a subdirectory (e.g. `my-widgets`).
4. Copy the `emotd.lua` file to that directory[^1].
5. Edit your `rc.lua` file according to the following directives (`-- ...` denotes an ellipsis):
  ```lua
  -- ...
  -- put this at the top of the document, near the other `require` statements
  local widget_emotd = require("my-widgets.emotd")
  -- ...
  -- there should be a line like the following somewhere in your rc.lua
  awful.screen.connect_for_each_screen(function(s)
  -- ...
      s.mywibox:setup {
      -- ...
      { -- Right widgets
          -- the following line is there in the default rc.lua
          layout = wibox.layout.fixed.horizontal,
          -- add your emotd widget right here to have it appear at the
          -- right of the left-aligned section of your status bar
          widget_emotd(), -- that's all you need for a default emotd configuration
          -- ...
  ```
6. [optional] See the [arguments](#argumentssettings) section to change the `emotd` configuration.

[^1]: you may, instead, create symlinks to the `emotd.lua` and `~/.emotd_words` files that lie in your cloned repository. This is useful if you intend on making modifications to the widget's source. To do this, run `ln -sv <your-repository-location>/emotd.lua ~/.config/awesome/my-widgets/emotd.lua` and `ln -sv <your-repository-location>/.emotd_words ~/.emotd_words`.

### what is emotional literacy?

This widget was greatly inspired by the [EQI.org](http://eqi.org/elit.htm) website, which defines emotional literacy as

> The ability to express feelings with specific feeling words, in 3 word sentences. (S. Hein, 1996)

Being able to express our own feeling is important for mental health. It lets us identify patterns in the evolution of our emotions, as well as the conditions that lead to the reproduction of these patterns, which allows us to develop strategies in order to to either avoid or better reproduce these conditions. At the very least, being able to finally word out an emotion we have been struggling for some time is often, in of itself, a relief. 

As any skill, emotional literacy can be practiced. This is where `emotd` may help: throughout your day, whenever you put your eyes on your status bar, you may choose to cycle through a few words until you find one that fits your current mood. This process will let you keep track of how your mood evolves as your day goes by. You might even learn a few new words along the way!

### words file

The default location of the words file is `~/.emotd_words`. You can change this location via the [arguments](#argumentssettings). A sample words file, shamelessly copied from [this webpage](http://www.psychpage.com/learning/library/assess/feelings.html), is given in this repository.

Your contents of the words file should follow this syntax:
- one word (can include whitespace) per line
- empty lines are ignored
- lines whose first non-whitespace character is `#` are treated as comments and ignored

### history

`emotd` allows you to cycle back through the history of the words that appeard in the widget in this session. This is meant to let you skim through the words quickly without having to worry about clicking away from the right word. By default only a few words are remembered by default, but you can change this number via the [arguments](#argumentssettings).

**NB:** the history feature is currently badly implemented and broken. It should *basically* work but it needs improvement. For example, you can't go back and then forward again in history: moving forward after moving back will overwrite the history that you backed through with new random words. Contributions welcome!

### arguments/settings

When calling `emotd` from your `rc.lua` configuration file, you can customize some aspects of its behaviour by passing a table as a parameter to the `emotd` call. If this table is omitted, the default settings will be used.

| table index | default value | explanation |
| ----------- | ------------- | ----------- |
| `words_file` |  `~/.emotd_words` | the file containing the feeling words |
| `prefix` | `""` | a prefix that will appear before the word displayed in the widget |
| `suffix` | `""` | a suffix that will appear after the word displayed in the widget |
| `hist_count` | `10` | the number of words kept in history |

Here is an example of a custom `emotd` call in your `rc.lua`:
```lua
-- ...
widget_emotd({
    prefix = "| ",
    suffix = " |",
    hist_count = 20,
}),
-- ...
```
