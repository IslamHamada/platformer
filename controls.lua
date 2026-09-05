local controls = {}

function controls.load()
    controls.gamepad = love.joystick.getJoysticks()[1]

    controls.bindings = {
        move_left  = { keys = { "a", "left" }, buttons = { "dpleft" }, axis = "leftx", axis_dir = -1, isDown = false, isPressed = false },
        move_right = { keys = { "d", "right" }, buttons = { "dpright" }, axis = "leftx", axis_dir = 1, isDown = false, isPressed = false },
        jump       = { keys = { "space", "return" }, buttons = { "a" }, isDown = false, isPressed = false },
        hook       = { keys = { "k" }, buttons = { "righttrigger" }, isDown = false, isPressed = false },
        climb      = { keys = { "j" }, buttons = { "lefttrigger" }, isDown = false, isPressed = false },
        down       = { keys = { "s", "down" }, buttons = { "dpdown" }, axis = "lefty", axis_dir = -1, isDown = false, isPressed = false },
        up         = { keys = { "w", "up" }, buttons = { "dpup" }, axis = "lefty", axis_dir = 1, isDown = false, isPressed = false },
        start      = { keys = { "escape" }, buttons = { "start" }, isDown = false, isPressed = false },
        back       = { keys = { "backspace" }, buttons = { "b" }, isDown = false, isPressed = false }
    }

    controls.jump_buffer_time = 0.2
    controls.jump_buffer_timer = 0
    controls.jump_buffered = false
end

local function checkGamepadDown(joystick, button, axis_dir)
    if button == "lefttrigger" then
        return joystick:getGamepadAxis("triggerleft") > 0.3
    elseif button == "righttrigger" then
        return joystick:getGamepadAxis("triggerright") > 0.3
    elseif button == "leftx" then
        local axis_val = joystick:getGamepadAxis("leftx")
        if axis_dir == -1 then
            return axis_val < -0.3
        elseif axis_dir == 1 then
            return axis_val > 0.3
        end
    elseif button == "lefty" then
        local axis_val = joystick:getGamepadAxis("lefty")
        if axis_dir == -1 then
            return axis_val < -0.3
        elseif axis_dir == 1 then
            return axis_val > 0.3
        end
    end
    return joystick:isGamepadDown(button)
end

function controls.update(dt, game)
    for action, val in pairs(controls.bindings) do
        local isDown = false
        for _, button in ipairs(val.keys) do
            isDown = isDown or love.keyboard.isDown(button)
        end

        if controls.gamepad then
            for _, button in ipairs(val.buttons) do
                isDown = isDown or checkGamepadDown(controls.gamepad, button)
            end

            if val.axis then
                isDown = isDown or checkGamepadDown(controls.gamepad, val.axis, val.axis_dir)
            end
        end

        controls.bindings[action].isDown = isDown
    end

    if game.state == "gameplay" then
        if controls.jump_buffered then
            controls.jump_buffer_timer = controls.jump_buffer_timer + dt
            if controls.jump_buffer_timer > controls.jump_buffer_time then
                controls.jump_buffered = false
                controls.jump_buffer_timer = 0
            else
                controls.bindings.jump.isPressed = true
            end
        end
    end
end

function controls.reset_isPresseds()
    for action, _ in pairs(controls.bindings) do
        controls.bindings[action].isPressed = false
    end
end

function controls.keypressed(key)
    for action, val in pairs(controls.bindings) do
        for _, button in ipairs(val.keys) do
            if button == key then
                controls.bindings[action].isPressed = true
                if action == "jump" then
                    controls.jump_buffered = true
                    controls.jump_buffer_timer = 0
                end
                return
            end
        end
    end
end

function controls.gamepadpressed(joystick, button)
    for action, val in pairs(controls.bindings) do
        for _, b in ipairs(val.buttons) do
            if button == b then
                controls.bindings[action].isPressed = true
                if action == "jump" then
                    controls.jump_buffered = true
                    controls.jump_buffer_timer = 0
                end
                return
            end
        end
    end
end

function controls.consume_jump()
    controls.jump_buffered = false
    controls.jump_buffer_timer = 0
    controls.bindings.jump.isPressed = false
end

return controls
