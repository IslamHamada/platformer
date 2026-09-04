local globals = require "globals"
local utils = require "utils"
local camera = {}

function camera.load(player, map)
    camera.y = map.currentLevel.height * map.y_scale - globals.height
    camera.x = 0

    camera.shake_factor = 0
    camera.shake = false
    camera.shake_time = 0
    camera.shake_timer = 0
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


    ------------------------------------------------------
    if camera.shake then
        camera.shake_timer = camera.shake_timer + dt
        if camera.shake_timer > camera.shake_time then
            camera.shake_timer = 0
            camera.shake = false
        end
        camera.x = math.random(-camera.shake_factor, camera.shake_factor)
        camera.y = camera.y + math.random(-camera.shake_factor, camera.shake_factor)
    end
end

function camera.init_shake(time, factor)
    camera.shake_time = time
    camera.shake_factor = factor
    camera.shake = true
end

return camera
