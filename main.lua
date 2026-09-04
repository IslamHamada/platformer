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
    if key == "escape" then
        love.event.quit()
    end
    game.keypressed(key)
end

function love.gamepadpressed(joystick, button)
    game.gamepadpressed(joystick, button)
end
