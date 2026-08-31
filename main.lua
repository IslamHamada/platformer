if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local game = require("game")

function love.load()
    game.load()
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
end

function love.keypressed(key)
    game.keypressed(key)
end
