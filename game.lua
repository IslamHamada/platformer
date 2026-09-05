local gameplay   = require("gameplay")
local main_menu  = require("main_menu")
local globals    = require("globals")
local pause_menu = require("pause_menu")
local saving     = require("saving")
local controls   = require("controls")

local game       = {}

function game.load()
    globals.load()
    game.state = "main_menu"

    saving.load()
    controls.load()
    main_menu.load(game)
    pause_menu.load(game)
    gameplay.load()
end

function game.update(dt)
    globals.update(dt)
    controls.update(dt, game)

    if game.state == "gameplay" then
        gameplay.update(dt, game)
    elseif game.state == "main_menu" then
        main_menu.update(dt, game)
    elseif game.state == "pause_menu" then
        pause_menu.update(dt)
    end
    controls.reset_isPresseds()
end

function game.draw()
    if game.state == "gameplay" then
        gameplay.draw()
    elseif game.state == "main_menu" then
        main_menu.draw()
    elseif game.state == "pause_menu" then
        pause_menu.draw()
    end
end

function game.keypressed(key)
    controls.keypressed(key)
end

function game.gamepadpressed(joystick, button)
    controls.gamepadpressed(joystick, button)
end

return game
