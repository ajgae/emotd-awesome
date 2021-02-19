## `emotd` - a simple `awesome` widget that helps you develop your emotional literacy

`emotd` is a simple and sweet widget for the `awesome` X11 window manager. It displays a feeling word, picked at random from a user-defined text file, in your `awesome` status bar.

You can set the word to another random word by simply clicking on the widget. The idea is that you can cycle through different words until you find one that describes your current mood.

`emotd` stands for "emotion of the day". Credits to my dad for finding this name.

### what is emotional literacy?

This widget was greatly inspired by the [EQI.org](http://eqi.org/elit.htm) website, which defines emotional literacy as

> The ability to express feelings with specific feeling words, in 3 word sentences. (S. Hein, 1996)

Being able to express our own feeling is important for mental health. It lets us identify patterns in the evolution of our emotions, as well as the conditions that lead to the reproduction of these patterns, which allows us to develop strategies in order to to either avoid or better reproduce these conditions. At the very least, being able to finally word out an emotion we have been struggling for some time is often, in of itself, a relief. 

As any skill, emotional literacy can be practiced. This is where `emotd` may help: throughout your day, whenever you put your eyes on your status bar, you may choose to cycle through a few words until you find one that fits your current mood. This process will let you keep track of how your mood evolves as your day goes by. You might even learn a few new words along the way!

### words file

The default location of the words file is `~/.emotd_words`. You can change this by specifying [arguments](#arguments/settings) when calling `emotd` from your `rc.lua` configuration file.

Your contents of the words file should follow this syntax:
- one word (can include whitespace) per line
- empty lines are ignored
- lines whose first non-whitespace character is `#` are treated as comments and ignored

### arguments/settings

<!-- TODO -->
