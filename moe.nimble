# Package

version       = "0.2.1"
author        = "fox0430"
description   = "A command lined based text editor"
license       = "GPLv3"
srcDir        = "src"
bin           = @["moe"]

# Dependencies

requires "nim >= 1.2"
requires "https://github.com/walkre-niboshi/nim-ncurses >= 1.0.2"
requires "unicodedb >= 0.9.0"
requires "parsetoml >= 0.4.0"
