local gameplay = require("gameplay")

local game = {}

function game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
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

return game
