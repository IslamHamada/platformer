local player   = require("player")
local map      = require("map")
local camera   = require("camera")
local controls = require("controls")

local gameplay = {}

function gameplay.load()
    player.load()
    map.load(player)
    camera.load(player, map)
    controls.load()
end

function gameplay.update(dt)
    map.update(dt)
    controls.update(dt)
    player.update(dt, map)
    controls.reset_isPresseds()
    camera.update(dt, player, map)
end

function gameplay.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    map.draw()
    player.draw()
    love.graphics.pop()

    love.graphics.print("x_vel: " .. player.x_vel, 10, 10)
    love.graphics.print("x_acc: " .. player.x_acc, 10, 25)
end

function gameplay.keypressed(key)
    -- player.keypressed(key)
    controls.keypressed(key)
end

function gameplay.gamepadpressed(joystick, button)
    controls.gamepadpressed(joystick, button)
end

return gameplay
