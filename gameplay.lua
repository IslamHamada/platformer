local player   = require("player")
local map      = require("map")
local camera   = require("camera")

local gameplay = {}

function gameplay.load()
    player.load()
    map.load(player)
    camera.load(player, map)
end

function gameplay.update(dt)
    map.update(dt)
    player.update(dt, map)
    camera.update(dt, player, map)
end

function gameplay.draw()
    love.graphics.push()
    love.graphics.translate(0, -camera.y)
    map.draw()
    player.draw()
    love.graphics.pop()
end

function gameplay.keypressed(key)
    player.keypressed(key)
end

return gameplay
