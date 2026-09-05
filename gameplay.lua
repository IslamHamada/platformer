local player   = require("player")
local map      = require("map")
local camera   = require("camera")
local controls = require("controls")
local globals  = require("globals")
local sounds   = require("sounds")
local saving   = require("saving")

local gameplay = {}

function gameplay.load()
    player.load()
    map.load(player)
    camera.load(player, map)
    sounds.load()
end

function gameplay.update(dt, game)
    if controls.bindings.start.isPressed then
        game.state = "pause_menu"
    end
    map.update(dt)
    player.update(dt, map)
    camera.update(dt, player, map)
end

function gameplay.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    map.draw()
    player.draw()
    love.graphics.pop()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("Resolution: " .. globals.width .. " x " .. globals.height, 10, 25)
    love.graphics.print("x_vel: " .. player.x_vel, 10, 40)
    love.graphics.print("x_acc: " .. player.x_acc, 10, 55)
end

return gameplay
