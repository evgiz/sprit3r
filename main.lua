vox_model   = require 'vox/vox_model'
vox_texture = require 'vox/vox_texture'

suit = require("suit")
ui = require("ui")
viewer = require("model_viewer")

function love.load(arg)

    WINDOW_W = love.graphics.getWidth()
    WINDOW_H = love.graphics.getHeight()

    love.graphics.setBackgroundColor(30, 30, 30, 255)

    font = love.graphics.newFont(14)
    love.graphics.setFont(font)
    font_title = love.graphics.newFont(50)
    font_model = love.graphics.newFont(18)

    workingDirectory = love.filesystem.getWorkingDirectory()
    if love.filesystem.isFused() then
        print("Is fused!")
        local success = love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
        print("Mounting "..(success and "successful" or "failed"))
    end

    UI.init()
end

local supportedTypes = {".png", ".jpg", ".vox"}
function isType(str, type)
   return string.sub(str,-string.len(type))==type
end

function love.filedropped(file)
    local name = file:getFilename()
    for i=1,#supportedTypes do
        if isType(name, supportedTypes[i]) then
            viewer:new(file, supportedTypes[i]==".vox")
            return
        end
    end
    ui.message = "File type not supported!"
end

function love.resize(w, h)
    WINDOW_W = w
    WINDOW_H = h
end

function love.textinput(t)
    suit.textinput(t)
end

function love.wheelmoved(x, y)
    viewer:wheelmoved(x,y)
end

function love.keypressed(key)
    suit.keypressed(key)
    viewer:keypressed(key)
end

function love.update(dt)
    if not viewer.model then
        ui.update(dt)
    end
    if viewer.model then
        viewer:update(dt)
    end
end

function love.draw()
    if not viewer.model then
        ui:draw()
    end
    if viewer.model then
        viewer:draw()
    end
    suit:draw()
    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.print("Evgiz 2016", WINDOW_W - love.graphics.getFont():getWidth("Evgiz 2016")-5, WINDOW_H-20)
    love.graphics.setColor(255, 255, 255, 255)

end
