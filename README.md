# Sprit3r

Sprit3r is a small software which displays 3D models from spritesheets. Each tile in the sheet
represents one layer of the 3D model. The layers are then stacked on top of each other to achieve the effect.

![ScreenShot](http://i.imgur.com/qJN5bG2.gif)

The model was rendered from this image:
![ScreenShot](http://i.imgur.com/ms2MbQu.png)


Sprit3r is not a model editor, but the preview will refresh continuously as you edit it in another software. This makes it much easier to visualize what your art may
look like in a game or other piece of software using the same technique.

The software also supports .vox files, which is a binary format for exported by MagicaVoxel.

## About

Sprit3r was written in Lua using the LÖVE framework.

Thanks to vrld for the cool SUIT library used in the project.
https://github.com/vrld/SUIT

Thanks to kiktio who wrote the parser for .vox files.


My post on the LÖVE forums:
https://love2d.org/forums/viewtopic.php?f=5&t=83059
