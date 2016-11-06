

UI = {
    help = false,
    messageTimer = 0,
    message = nil,
}

function UI.init()

end

function UI.update(dt)

    local sy = math.floor((WINDOW_H-300)/2)
    local sx = math.floor(WINDOW_W/2)

    love.graphics.setFont(font_title)
    suit.Label("Sprit3r", sx-100, sy, 200)
    love.graphics.setFont(font)


    if not UI.help then
        love.graphics.setFont(font_model)
        local str = "Drag and drop an image or voxel file here!"
        suit.Label(UI.message or str, sx-100, sy+210, 200)
        love.graphics.setFont(font)
    else
        local str="Sprit3r is a minimalist software used to display sprites in 3D. This is done using spritesheets,"..
        " where each tile represents one layer of the model. The software is not an image editor, but it will update the model in real time"..
        " while you edit your models in another software."
        suit.Label(str, sx-200, sy+75, 400)
        str = "Supported file formats: .png and .vox"
        suit.Label(str, sx-220, sy+185, 440)
        str = "Created by evgiz.net"
        suit.Label(str, sx-200, sy+225, 400)
    end

    if suit.Button(not UI.help and "Help/About" or "Back", WINDOW_W/2-75, WINDOW_H-45, 150, 25).hit then
        UI.help = not UI.help
    end
    if suit.Button("View Example", WINDOW_W/2-75, WINDOW_H-75, 150, 25).hit then
        viewer:new(love.filesystem.newFile("example.png", "r"))
    end

end

local img = love.graphics.newImage("example.png")
img:setFilter("nearest", "nearest")
local quads = nil

function UI.draw()
    if UI.help then return end

    local sy = math.floor((WINDOW_H-300)/2+150)
    local scale = 3

    if quads==nil then
        quads={}
        for i=1,10 do
            quads[i] = love.graphics.newQuad(i*32, 0, 32, 32, img:getWidth(), img:getHeight())
        end
    end
    for i=1,10 do
        love.graphics.draw(img, quads[i], WINDOW_W/2, sy-i*scale*2, math.rad(love.timer.getTime()*20), scale,scale, 16,16)
        love.graphics.draw(img, quads[i], WINDOW_W/2, sy-i*scale*2-1, math.rad(love.timer.getTime()*20), scale,scale, 16,16)
        love.graphics.draw(img, quads[i], WINDOW_W/2, sy-i*scale*2-2, math.rad(love.timer.getTime()*20), scale,scale, 16,16)
        love.graphics.draw(img, quads[i], WINDOW_W/2, sy-i*scale*2-3, math.rad(love.timer.getTime()*20), scale,scale, 16,16)
    end

end

return UI
