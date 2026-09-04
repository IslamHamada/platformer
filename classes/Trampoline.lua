local sprites      = require("sprites")
local physics      = require("physics")
local tween        = require("libraries.tween.tween")

local Trampoline   = {}
Trampoline.__index = Trampoline


function Trampoline:new(x, y, width, height)
    local trampoline = {
        x = x,
        y = y,
        width = width,
        height = height,
        id = "Trampoline",
        stretch = false,
        max_stretch_factor = 1,
        stretch_factor = 1,
        time = 1,
        timer = 0,
        tween1 = nil,
        tween2 = nil
    }
    setmetatable(trampoline, Trampoline)
    return trampoline
end

function Trampoline:update(dt)
    if self.stretch and not self.tween1 and not self.tween2 then
        self.tween1 = tween.new(self.time / 2, self, { stretch_factor = self.max_stretch_factor })
    end

    if self.tween1 then
        local done = self.tween1:update(dt)
        if done then
            self.tween1 = nil
            self.tween2 = tween.new(self.time / 2, self, { stretch_factor = 1 })
        end
    end

    if self.tween2 then
        local done = self.tween2:update(dt)
        if done then
            self.tween2 = nil
            self.stretch = false
        end
    end
end

function Trampoline:init_stretch(time, max_stretch_factor)
    self.time = time
    self.max_stretch_factor = max_stretch_factor
    self.stretch = true
end

function Trampoline:draw()
    -- love.graphics.draw(sprites.trampoline, self.x, self.y, 0,
    --     self.width / sprites.trampoline:getWidth(),
    --     self.height / sprites.trampoline:getHeight() * self.stretch_factor)

    love.graphics.draw(sprites.trampoline, self.x, self.y + self.height, 0,
        self.width / sprites.trampoline:getWidth(),
        self.height / sprites.trampoline:getHeight() * self.stretch_factor,
        0, sprites.trampoline:getHeight())
end

return Trampoline
