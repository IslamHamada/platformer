local globals = require "globals"
local utils = require "utils"
local camera = {}

function camera.load(player, map)
    camera.y = map.currentLevel.height * map.y_scale - globals.height
end

function camera.update(dt, player, map)
    local targetY
    if player.y > map.currentLevel.height * map.y_scale - globals.height / 2 then
        targetY = map.currentLevel.height * map.y_scale - globals.height
    elseif player.y < globals.height / 2 then
        targetY = 0
    else
        targetY = player.y - globals.height / 2
    end

    camera.y = utils.lerp(camera.y, targetY, dt * 5)
end

return camera
