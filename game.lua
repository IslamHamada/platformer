local gameplay = require("gameplay")

local game = {}

function game.load()
    gameplay.load()
end

function game.update(dt)
    gameplay.update(dt)
end

function game.draw()
    gameplay.draw()
end

function game.keypressed(key)
    gameplay.keypressed(key)
end

function game.gamepadpressed(joystick, button)
    gameplay.gamepadpressed(joystick, button)
end

return game
