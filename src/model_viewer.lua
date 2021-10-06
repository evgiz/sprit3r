
ModelViewer =
{
    model = false,
    isVox = false,
    src,
    file,
    image,
    quads,
    quadWidth=16,
    quadHeight=16,
    updateTimer=0,
    animationTimer = 0,
    animation_frame = 1,
    widthInput  = {text="16"},
    heightInput = {text="16"},
    spaceInput  = {text="1"},
    framesInput = {text="1"},
    hideUI = false,
    --View
    rotation = 0,
    layer_spacing = 1,
    animation_frames = 1,
    voxelMode = false,
    autoRotate = true,
    rotateDir = 1,
    flip = false,
    rotate_speed = 30,
    rotateSlider = {value = 50, min = 0, max = 150},
    zoom = 1,
    nearest=true,
    animation = false,

}


function ModelViewer:new(file, isVox)
    self.src = file:getFilename()
    self.file = file
    self.model = true
    self.zoom = 1

    self.isVox = isVox or false
    if self.isVox then
        self.loading = false
        self:loadModel()
    else
        self:loadImage()
    end

    self:createQuads(true)

end

function ModelViewer:loadModel()
    self.file:open("r")
    local model = vox_model.new(self.file:read())
    self.file:close()

    local tex = vox_texture.new(model)
    tex.canvas:setFilter("nearest","nearest")
    self.canvas = tex.canvas
    self.quadWidth = tex.sizeX
    self.quadHeight = tex.sizeZ
    self.image = love.graphics.newImage(tex.canvas:newImageData())
    self.image:setFilter(self.nearest and "nearest" or "linear", self.nearest and "nearest" or "linear")
end

function ModelViewer:loadImage()
    self.file:open("r")
    local imageData = love.image.newImageData(self.file)
    self.file:close()
    self.image = love.graphics.newImage(imageData)
    self.image:setFilter(self.nearest and "nearest" or "linear", self.nearest and "nearest" or "linear")

    self.quadWidth=self.image:getHeight() / self.animation_frames
    self.quadHeight=self.quadWidth
    self.stack_layers = self.image:getWidth() / self.quadWidth

    self.heightInput.text   = self.quadWidth..""
    self.widthInput.text    = self.quadHeight..""

    return true
end

function ModelViewer:wheelmoved(x,y)
    if x+y>0 then
        self.zoom = math.min(5, self.zoom*1.25)
    else
        self.zoom = math.max(.25, self.zoom*0.75)
    end
end

function ModelViewer:keypressed(key)
    if key=="h" and not self.loading then
        self.hideUI = not self.hideUI
    end
    if key=="v" then
        self.voxelMode = not self.voxelMode
    end
    if key=="f" then
        self.flip = not self.flip
    end
    if key=="space" or key=="r" then
        self.autoRotate = not self.autoRotate
    end
end

function ModelViewer:update(dt)

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        self.rotation = self.rotation - math.max(100, self.rotate_speed*1.5)*dt
        self.rotateDir = -1
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        self.rotation = self.rotation + math.max(100, self.rotate_speed*1.5)*dt
        self.rotateDir = 1
    elseif self.autoRotate then
        self.rotation = self.rotation + self.rotate_speed*dt*self.rotateDir
    end

    if tonumber(self.spaceInput.text)==nil then
        self.layer_spacing = 1
    else
        self.layer_spacing = tonumber(self.spaceInput.text) or 1
    end

    if tonumber(self.framesInput.text) == nil then
        self.animation_frames = 1
    else
        self.animation_frames = tonumber(self.framesInput.text) or 1
    end

    if self.model then
        if self.animation then
            self.animationTimer = self.animationTimer+dt
            if self.animationTimer > 0.1 then
                self.animationTimer = 0
                self.animation_frame = self.animation_frame + 1
                if self.animation_frame > self.animation_frames then
                    self.animation_frame = 1
                end
            end
        else
            self.animation_frame = 1
        end
        self.updateTimer = self.updateTimer+dt
        if self.updateTimer>.5 then
            self.updateTimer = 0
            if self.isVox then
                self:loadModel()
            else
                self:loadImage()
            end
            self:createQuads()
        end
    end

    if self.model and not self.hideUI then
        local back   = suit.Button("Menu", 10, 10, 100, 30)
        if back.hit then
            self.model = false
            self.loading = false
        end

        if suit.Button("Zoom In", 10,WINDOW_H-80,100,30).hit then
            self.zoom = math.min(5, self.zoom*1.25)
        end
        if suit.Button("Zoom Out", 10,WINDOW_H-40,100,30).hit then
            self.zoom = math.max(.25, self.zoom*0.75)
        end

        suit.Label("Hide GUI - H", 10,WINDOW_H-105,100)

        if suit.Button(self.voxelMode and "Voxel" or "Flat", WINDOW_W-110,10,100,30).hit then self.voxelMode = not self.voxelMode end

        if suit.Button(self.nearest and "Nearest" or "Linear", WINDOW_W-110,50,100,30).hit then
            self.nearest = not self.nearest
            local str = self.nearest and "nearest" or "linear"
            self.image:setFilter(str, str)
        end

        if suit.Button(self.animation and 'Animation' or 'Static', WINDOW_W-110,90,100,30).hit then self.animation = not self.animation end

        if suit.Button(self.autoRotate and "Auto Rotate" or "Stationary", WINDOW_W-110,130,100,30).hit then self.autoRotate = not self.autoRotate end

        self.rotate_speed = math.floor(self.rotateSlider.value)
        suit.Label("Speed: "..self.rotate_speed, WINDOW_W-110,160,100,30)
        suit.Slider(self.rotateSlider, WINDOW_W-100,180,80,30)

        if suit.Button(self.flip and "Flip ON" or "Flip OFF", WINDOW_W-110,220,100,30).hit then self.flip = not self.flip end

        suit.Label("Layer height", WINDOW_W-110,250,50,30)
        suit.Input(self.spaceInput, WINDOW_W-50,260,40,30)

        if self.animation then
            suit.Label("Number of frames", WINDOW_W-110,290,50,30)
            suit.Input(self.framesInput, WINDOW_W-50,300,40,30)
        end
    end
end

function ModelViewer:createQuads(first)
    self.quads = {}

    local steps = self.image:getWidth()/self.quadWidth
    local animation_frames = self.animation_frames - 1
    for x=0, animation_frames do
        for i=1,steps do
            self.quads[i + (x * self.stack_layers)] = love.graphics.newQuad((i-1)*self.quadWidth, x * self.quadHeight, self.quadWidth, self.quadHeight, self.image)
        end
    end

    if first then
        if not self.isVox then
            self.layer_spacing = math.floor(math.max(((self.quadWidth+self.quadHeight)/3)/#self.quads, 1)+.5)
        else
            self.layer_spacing = 1
        end
        self.spaceInput.text = self.layer_spacing..""
    end

end

function ModelViewer:draw()
    if  self.model then
        if not self.hideUI then love.graphics.print(self.src, WINDOW_W/2 - font_model:getWidth(self.src)/2, 10) end
        self:drawModel(WINDOW_W/2,WINDOW_H/2)
    end
end

function ModelViewer:drawModel(x,y)
    local scale = 100/math.max(self.quadWidth, #self.quads) * self.zoom
    local sy = #self.quads/2 * self.layer_spacing*scale

    for i=1,self.stack_layers do
        local quad_index = (self.stack_layers * (self.animation_frame - 1)) + i
        local index = self.flip and #self.quads-quad_index+1 or quad_index

        for j=1,math.max(1,self.layer_spacing)*scale do
            if not self.quads[index] then
                break
            end
            love.graphics.draw(self.image, self.quads[index], x, y+sy - i*scale*self.layer_spacing - j, math.rad(self.rotation), scale,scale,self.quadWidth/2, self.quadHeight/2)
            if j>1 and not self.voxelMode then break end
        end
    end

end

return ModelViewer
