local globals = require("globals")
local physics = require("physics")
local utils   = require("utils")
local tween   = require("libraries.tween.tween")
local player  = {}

function player.load(map)
    -- player.x = globals.width * 0.1
    -- player.y = globals.height * 0.8
    player.width = 50
    player.height = 50

    player.movement_speed = 600
    player.jump_speed = 700

    player.x_vel = 0
    player.y_vel = 0

    player.is_climbing = false
    player.vel_loss_rate = 5
    -- player.omega_loss_rate = 2

    player.max_climbing_stamina = 1
    player.climbing_stamina = player.max_climbing_stamina

    player.max_active_anchor_distance = 400
    player.swing_speed = 3
    player.omega = 0
    player.swing_angle = 0
    player.anchor = nil
    player.anchor_dist = -1

    player.reset_tween = nil
end

function player.update(dt, map)
    if not love.keyboard.isDown("f") then
        player.hooked = false
        player.anchor = nil
        player.anchor_dist = -1
        player.omega = 0
        player.swing_angle = 0
    end

    if player.hooked then
        if player.omega == 0 then
            if player.x_vel > 0 then
                player.omega = -player.swing_speed
            else
                player.omega = player.swing_speed
            end
        end
        player.x_vel = -player.anchor_dist * player.omega * math.sin(player.swing_angle)
        player.y_vel = player.anchor_dist * player.omega * math.cos(player.swing_angle)

        player.swing_angle = player.swing_angle + player.omega * dt
    else
        if love.keyboard.isDown("d") then
            player.x_vel = player.movement_speed
        elseif love.keyboard.isDown("a") then
            player.x_vel = -player.movement_speed
        end
    end

    if not player.hooked then
        player.x_vel = player.x_vel - player.x_vel * player.vel_loss_rate * dt
    end

    if love.keyboard.isDown("e") and (player.touching_wall_right or player.touching_wall_left) and player.climbing_stamina > 0 then
        player.y_vel = -player.movement_speed
        player.climbing_stamina = player.climbing_stamina - dt
        player.is_climbing = true
    else
        player.is_climbing = false
    end

    if not player.is_climbing and not player.hooked then
        physics.applyGravity(player, dt)
    end

    if player.grounded then
        player.climbing_stamina = player.max_climbing_stamina
    end

    if not player.hooked and love.keyboard.isDown("f") then
        table.sort(map.anchors,
            function(a, b)
                return utils.distance(player.x, player.y, a.x, a.y) < utils.distance(player.x, player.y, b.x, b.y)
            end)
        for _, anchor in ipairs(map.anchors) do
            local dist = utils.distance(player.x, player.y, anchor.x, anchor.y)
            if dist <= player.max_active_anchor_distance then
                player.hooked = true
                player.anchor = anchor
                player.anchor_dist = dist
                player.swing_angle = math.atan2(player.y - anchor.y, player.x - anchor.x)
                player.climbing_stamina = player.max_climbing_stamina
                break
            end
        end
    end

    local newX, newY = physics.applyVelocity(player, dt)
    local actualX, actualY, cols, len = physics.collision_world:move(player, newX, newY, player.collisionFilter)
    player.x, player.y = actualX, actualY


    player.grounded = false
    player.touching_wall_right = false
    player.touching_wall_left = false
    for i = 1, len do
        local col = cols[i]
        if col.other.id == "Solid" then
            if col.normal.y == -1 and player.y_vel > 0 then
                player.y_vel = 0
                player.grounded = true
            end

            if col.normal.y == 1 and player.y_vel < 0 then
                player.y_vel = 0
            end

            if col.normal.x == 1 then
                -- player.x_vel = 0
                player.touching_wall_left = true
            end

            if col.normal.x == -1 then
                -- player.x_vel = 0
                player.touching_wall_right = true
            end
        elseif col.other.id == "Trap" then
            player.reset()
            if not player.reset_tween then
                player.reset_tween = tween.new(0.5, player, { x = map.spawnPoint.x, y = map.spawnPoint.y })
            end
        end
    end

    if physics.aabb(player.x, player.y, player.width, player.height, map.nextLevelTrigger.x, map.nextLevelTrigger.y, map.nextLevelTrigger.width, map.nextLevelTrigger.height) then
        map.loadNextLevel()
    end

    if player.reset_tween then
        local complete = player.reset_tween:update(dt)
        if complete then
            player.reset_tween = nil
        end
    end
end

function player.draw()
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

function player.keypressed(key)
    if key == "space" then
        if player.grounded then
            player.y_vel = -player.jump_speed
        end
    end

    if player.hooked then
        if key == "d" then
            if player.y < player.anchor.y then
                player.omega = player.swing_speed
            else
                player.omega = -player.swing_speed
            end
        elseif key == "a" then
            if player.y < player.anchor.y then
                player.omega = -player.swing_speed
            else
                player.omega = player.swing_speed
            end
        end
    end
end

function player.collisionFilter(item, other)
    if other.id == "Solid" then
        return "slide"
    elseif other.id == "Trap" then
        return "cross"
    end
end

function player.reset()
    player.x_vel = 0
    player.y_vel = 0
    player.grounded = false
    player.touching_wall_right = false
    player.touching_wall_left = false
    player.is_climbing = false
    player.hooked = false
    player.anchor = nil
    player.anchor_dist = -1
    player.omega = 0
    player.swing_angle = 0
    player.climbing_stamina = player.max_climbing_stamina
end

return player
