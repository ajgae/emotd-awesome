# `emotd` - a simple `awesome` widget that helps you develop your emotional literacy

`emotd` is a simple and sweet widget for the `awesome` X11 window manager. It displays a feeling word, picked at random from a user-defined text file, in your `awesome` status bar.

You can set the word to another random word by simply clicking on the widget. The idea is that you can cycle through the different words until you find one that describes your current mood.

`emotd` stands for "emotion of the day". Credits to my dad for finding this name.

## What is emotional literacy?

This widget was in large part inspired by the [EQI.org](http://eqi.org/elit.htm) website. It defines emotional literacy as

> The ability to express feelings with specific feeling words, in 3 word sentences. (S. Hein, 1996)

Being able to express our own feeling is important: it lets us identify patterns in the evolution of our emotions, as well as the conditions that lead to the apparition of these patterns, to then develop strategies that allow us to either avoid or reproduce these conditions. At the very least, being able to finally word out an emotion we have been struggling for some time is often, in of itself, a relief. 

As any skill, emotional literacy can be practiced. This is where `emotd` may help: throughout your day, whenever you put your eyes on your status bar, you may choose to cycle through a few words until you find one that fits your current mood. This process will let you keep track of how your mood evolves as your day goes by. You might even learn a few new words along the way!

## Word file syntax

Your contents of your words file should follow this syntax:
- one word (can include whitespace) per line
- empty lines are ignored
- lines whose first non-whitespace character is `#` are considered comments and ignored
