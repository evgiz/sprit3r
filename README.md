# Sprit3r

Sprit3r is a small software which displays 3D models from spritesheets. Each tile in the sheet
represents one layer of the 3D model. The layers are then stacked on top of each other to achieve the effect.

![ScreenShot](img/sprit3r.gif?raw=true)

The model was rendered from this image:

![ScreenShot](img/sheet.png?raw=true)


Sprit3r is not a model editor, but the preview will refresh continuously as you edit it in another software. This makes it much easier to visualize what your art may
look like in a game or other piece of software using the same technique.

The software also supports .vox files, which is a binary format exported by MagicaVoxel.

## How to use

Sprit3r is cross platform, but requires LÖVE to run. You can download the latest version at https://love2d.org
Refer to the LÖVE docs if you are unfamiliar with running LÖVE projects. The simplest way is dragging the **sprit3r/src** folder onto your LÖVE application.

Note that a future update may break the code! Recommended version is LÖVE 11.1 

## About

Sprit3r was written in Lua using the LÔVE framework.

Thanks to vrld for the cool SUIT library used in the project.
https://github.com/vrld/SUIT

Thanks to kikito who wrote the parser for .vox files.

My post on the LÖVE forums:
https://love2d.org/forums/viewtopic.php?f=5&t=83059