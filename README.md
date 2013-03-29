Gosu sample game and snippets
=============================

© 2013 Belén Albeza

This code backs the talk *Rapid Game Development with Ruby and Gosu* in the 4th edition of [Ruby Manor](http://www.rubymanor.org).

All source, images and audio files are distributed under the MIT license. See LICENSE for details.

Installation and requirements
-----------------------------

Ruby 1.9 and Rubygems are required. Then, install Gosu with:

```bash
$ gem install gosu
```

Sample game
-----------

The `game.rb` file contains a sample Gosu shooter game. It features: sprites, collisions, delta time, keyboard input, audio, font, etc.

You get points for each alien killed. The game ends when an alien destroys your ship.

Controls are:

  - Left and Right arrows: move ship
  - Space: shoot

Snippets
--------

The `snippets` folder contains code for some popular game development techniques:

- `create_window.rb`: create a Gosu Window
- `draw_image.rb`: how to load and draw an image
- `input.rb`: how to read user's input from the keyboard
- `delta_time.rb`: how to calculate and use delta time
