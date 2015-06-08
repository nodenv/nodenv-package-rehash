# rbenv-gem-rehash

**Never run `rbenv rehash` again.** This rbenv plugin automatically
runs `rbenv rehash` every time you install or uninstall a gem.

## Installation

Make sure you have rbenv 0.4.0 or later, then run:

    git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

## Usage

1. `gem install` a gem that provides executables.
2. Marvel at how you no longer need to type `rbenv rehash`.

## How It Works

rbenv-gem-rehash consists of two parts: a RubyGems plugin and an rbenv
plugin.

The RubyGems plugin hooks into the `gem install` and `gem uninstall`
commands to run `rbenv rehash` afterwards, ensuring newly installed
gem executables are visible to rbenv.

The rbenv plugin is responsible for making the RubyGems plugin visible
to RubyGems. It hooks into the `rbenv exec` command that rbenv's shims
use to invoke Ruby programs and configures the environment so that
RubyGems can discover the plugin.
