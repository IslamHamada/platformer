local globals   = require("globals")
local physics   = require("physics")
local utils     = require("utils")
local tween     = require("libraries.tween.tween")
local controls  = require("controls")
local sprites   = require("sprites")
local Animation = require("libraries.Animation.Animation")
local camera    = require("camera")
local sounds    = require("sounds")
local player    = {}

function player.load(map)
    player.sprite = sprites.player.sprite
    player.animations = {
        idle = Animation:new(sprites.player.idle, 1, 4, 4, 0.2),
        running = Animation:new(sprites.player.running, 1, 5, 5, 0.1),
        climbing = Animation:new(sprites.player.climbing, 1, 4, 4, 0.2),
        jumping = Animation:new(sprites.player.jumping, 1, 1, 1, 0.1),
        hooked = Animation:new(sprites.player.hooked, 1, 1, 1, 0.1)
    }
    player.state = "idle"
    player.animations.frame_idx = 1
    player.animations.timer = 0
    player.orientation = 1


    player.sprite_scale = 4
    player.sprite_x_offset = 20
    player.sprite_y_offset = 60

    player.width = 40
    player.height = 121

    player.climbing_speed = 600
    player.movement_acceleration = 60000
    player.max_movement_speed = 800
    player.air_movement_acceleration = 200
    player.air_movement_speed = 600
    player.jump_speed = 1000
    player.wall_jump_x_speed = 600
    player.wall_jump_y_speed = 1000

    player.x_vel = 0
    player.y_vel = 0
    player.x_acc = 0
    player.y_acc = 0

    player.is_climbing = false
    player.friction_factor = 100
    player.air_drag_factor = 1
    -- player.omega_loss_rate = 2

    player.max_climbing_stamina = 0.75
    player.climbing_stamina = player.max_climbing_stamina

    player.max_active_anchor_distance = 300
    player.swing_speed = 3
    player.omega = 0
    player.swing_angle = 0
    player.anchor = nil
    player.anchor_dist = -1

    player.reset_tween = nil

    player.trampoline_speed = 1200

    player.was_hooked = false

    player.dead = false

    player.alpha = 0

    player.jumping = false

    player.wall_jumping = false

    player.time_since_wall_jump = 0
    player.coyote_timer = 0
    player.coyote_time = 0.2
end

function player.update(dt, map)
    player.state_machine[player.state].update()

    player.x_acc = 0
    player.y_acc = 0

    player.time_since_wall_jump = player.time_since_wall_jump + dt

    if not player.dead then
        if not controls.bindings.hook.isDown then
            player.hooked = false
            player.anchor = nil
            if player.was_hooked then
                player.x_vel = -2 * player.anchor_dist * player.omega * math.sin(player.swing_angle)
                player.y_vel = 2 * player.anchor_dist * player.omega * math.cos(player.swing_angle)
                player.was_hooked = false
            end
            player.anchor_dist = -1
            player.omega = 0
            player.swing_angle = 0
        end


        if player.hooked then
            player.jumping = false
            player.wall_jumping = false
            player.is_climbing = false

            if player.omega == 0 then
                if player.x_vel > 0 then
                    player.omega = -player.swing_speed
                    player.orientation = -1
                else
                    player.omega = player.swing_speed
                    player.orientation = 1
                end
            end
            -- if player.omega > 0 then
            --     player.alpha = physics.gravity / player.anchor_dist * math.cos(player.swing_angle)
            -- else
            --     player.alpha = -physics.gravity / player.anchor_dist * math.cos(player.swing_angle)
            -- end
            -- physics.applyAngularAcceleration(player, dt)
            -- physics.applyAngularVelocity(player, dt)
            player.x_vel = -player.anchor_dist * player.omega * math.sin(player.swing_angle)
            player.y_vel = player.anchor_dist * player.omega * math.cos(player.swing_angle)
            player.swing_angle = player.swing_angle + player.omega * dt
        else
            if player.grounded then
                if controls.bindings.move_right.isDown then
                    player.x_acc = player.movement_acceleration
                    player.orientation = 1
                elseif controls.bindings.move_left.isDown then
                    player.x_acc = -player.movement_acceleration
                    player.orientation = -1
                end
            else
                if not player.wall_jumping or player.time_since_wall_jump > 0.5 then
                    if controls.bindings.move_right.isDown then
                        player.x_vel = player.air_movement_speed
                        player.orientation = 1
                    elseif controls.bindings.move_left.isDown then
                        player.x_vel = -player.air_movement_speed
                        player.orientation = -1
                    end
                end
            end
        end

        if player.touching_wall_left then
            if player.x_vel < 0 then
                player.x_vel = -10
            end
            if player.x_acc < 0 then
                player.x_acc = 0
            end
        end

        if player.touching_wall_right then
            if player.x_vel > 0 then
                player.x_vel = 10
            end
            if player.x_acc > 0 then
                player.x_acc = 0
            end
        end

        if not player.hooked then
            if player.grounded then
                player.x_vel = player.x_vel - player.x_vel * player.friction_factor * dt
            else
                player.x_vel = player.x_vel - player.x_vel * player.air_drag_factor * dt
            end
        end

        if controls.bindings.climb.isDown and (player.touching_wall_right or player.touching_wall_left) and player.climbing_stamina > 0 then
            player.y_vel = -player.climbing_speed
            player.climbing_stamina = player.climbing_stamina - dt
            player.is_climbing = true
            player.jumping = false
        else
            player.is_climbing = false
        end

        if (player.touching_wall_left or player.touching_wall_right) then
            if controls.bindings.jump.isPressed then
                controls.consume_jump()
                player.is_climbing = false
                player.wall_jumping = true
                player.time_since_wall_jump = 0
                player.y_vel = -player.wall_jump_y_speed
                if player.touching_wall_left then
                    player.x_vel = player.wall_jump_x_speed
                elseif player.touching_wall_right then
                    player.x_vel = -player.wall_jump_x_speed
                end
                sounds.jump:play()
            end
        end

        if not player.is_climbing and not player.hooked then
            physics.applyGravity(player, dt)
        end

        if player.grounded then
            player.coyote_timer = player.coyote_time
            player.climbing_stamina = player.max_climbing_stamina
        end

        if not player.hooked and controls.bindings.hook.isDown then
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
                    player.was_hooked = true
                    sounds.hook:play()
                    break
                end
            end
        end

        if player.hooked then
            player.jumping = false
            if controls.bindings.move_right.isPressed then
                if player.y < player.anchor.y then
                    player.omega = player.swing_speed
                else
                    player.omega = -player.swing_speed
                end
            elseif controls.bindings.move_left.isPressed then
                if player.y < player.anchor.y then
                    player.omega = -player.swing_speed
                else
                    player.omega = player.swing_speed
                end
            end
        end

        if controls.bindings.jump.isPressed then
            if player.grounded or player.coyote_timer > 0 then
                controls.consume_jump()
                player.y_vel = -player.jump_speed
                player.jumping = true
                player.coyote_timer = 0
                sounds.jump:play()
            end
        end

        if player.jumping and not controls.bindings.jump.isDown and player.y_vel < 0 then
            player.y_vel = player.y_vel * 0.5
            player.jumping = false
        end

        physics.applyAcceleration(player, dt)
        player.x_vel = math.min(player.x_vel, player.max_movement_speed)
        player.x_vel = math.max(player.x_vel, -player.max_movement_speed)

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
                    player.jumping = false
                    player.wall_jumping = false
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
                camera.init_shake(0.2, 5)
                player.reset()
                if not player.reset_tween then
                    player.reset_tween = tween.new(0.5, player, { x = map.spawnPoint.x, y = map.spawnPoint.y })
                    player.dead = true
                    sounds.death:play()
                end
            elseif col.other.id == "Trampoline" then
                if col.normal.y == -1 then
                    col.other:init_stretch(0.25, 2)
                    player.y_vel = -player.trampoline_speed
                    player.jumping = false
                    player.wall_jumping = false
                    sounds.bounce:play()
                end
            end
        end

        if physics.aabb(player.x, player.y, player.width, player.height, map.nextLevelTrigger.x, map.nextLevelTrigger.y, map.nextLevelTrigger.width, map.nextLevelTrigger.height) then
            map.loadNextLevel()
        end

        player.coyote_timer = player.coyote_timer - dt
    end

    if player.reset_tween then
        local complete = player.reset_tween:update(dt)
        physics.collision_world:update(player, player.x, player.y)
        if complete then
            player.reset_tween = nil
            player.dead = false
        end
    end

    local animation = player.animations[player.state]
    player.animations.timer = player.animations.timer + dt
    if player.animations.timer >= animation.quad_duration then
        player.animations.frame_idx = player.animations.frame_idx % animation.n_quads + 1
        player.animations.timer = 0
    end
end

function player.draw()
    -- love.graphics.rectangle("line", player.x, player.y, player.width, player.height)
    -- love.graphics.draw(player.sprite, player.x + player.sprite_x_offset, player.y + player.sprite_y_offset, 0,
    --     player.sprite_scale, player.sprite_scale)

    if player.hooked then
        love.graphics.line(player.x + player.width / 2, player.y + player.height / 2, player.anchor.x + 48,
            player.anchor.y + 48)
    end

    local animation = player.animations[player.state]
    love.graphics.draw(animation.sprite, animation.quads[player.animations.frame_idx], player.x + player.sprite_x_offset,
        player.y + player.sprite_y_offset, 0,
        player.sprite_scale * player.orientation, player.sprite_scale, player.sprite:getWidth() / 2,
        player.sprite:getHeight() / 2)
end

function player.collisionFilter(item, other)
    if other.id == "Solid" then
        return "slide"
    elseif other.id == "Trap" then
        return "cross"
    elseif other.id == "Trampoline" then
        return "slide"
    end
end

function player.reset()
    player.x_vel = 0
    player.y_vel = 0
    player.x_acc = 0
    player.y_acc = 0
    player.grounded = false
    player.touching_wall_right = false
    player.touching_wall_left = false
    player.is_climbing = false
    player.hooked = false
    player.wall_jumping = false
    player.anchor = nil
    player.anchor_dist = -1
    player.omega = 0
    player.swing_angle = 0
    player.climbing_stamina = player.max_climbing_stamina
end

player.state_machine = {
    idle = {
        update = function(dt)
            if player.grounded and (controls.bindings.move_right.isDown or controls.bindings.move_left.isDown) then
                player.setState("running")
            elseif player.is_climbing then
                player.setState("climbing")
            elseif player.hooked then
                player.setState("hooked")
            elseif player.y_vel < 0 then
                player.setState("jumping")
            end

            -- if player.y_vel > 0 then
            --     player.setState("fall")
            -- end
        end,
    },
    running = {
        update = function(dt)
            love.audio.play(sounds.walk)
            if not controls.bindings.move_right.isDown and not controls.bindings.move_left.isDown then
                player.setState("idle")
            elseif player.is_climbing then
                player.setState("climbing")
            elseif player.hooked then
                player.setState("hooked")
            elseif player.y_vel < 0 then
                player.setState("jumping")
            end

            -- if player.y_vel > 0 then
            --     player.setState("fall")
            -- end
        end,
    },
    jumping = {
        update = function(dt)
            if player.grounded then
                player.setState("idle")
            elseif player.hooked then
                player.setState("hooked")
            elseif player.is_climbing then
                player.setState("climbing")
            end
        end,
    },
    climbing = {
        update = function(dt)
            sounds.climb:play()
            if not controls.bindings.climb.isDown or (not player.touching_wall_left and not player.touching_wall_right) then
                player.setState("idle")
            end
        end,
    },
    hooked = {
        update = function(dt)
            if not player.hooked then
                player.setState("idle")
            end
        end,
    }
}

function player.setState(state)
    player.animations.timer = 0
    player.animations.frame_idx = 1
    player.state = state
end

return player
