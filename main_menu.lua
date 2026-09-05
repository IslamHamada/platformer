local Button      = require("classes.UI.Button")
local Menu        = require("classes.UI.Menu")
local RadioButton = require("classes.UI.RadioButton")
local saving      = require("saving")
local map         = require("map")
local controls    = require("controls")

local main_menu   = {}

function main_menu.load(game)
    local main_menu_buttons = {
        [1] = Button:new(150, 40, "New Game", function()
            map.newGame(); game.state = "gameplay"
        end),
        [2] = Button:new(150, 40, "Options", function() main_menu.current_menu = main_menu.options_menu end),
        [3] = Button:new(150, 40, "Quit", function() love.event.quit() end)
    }

    if saving.data.progress.current_level > 1 then
        table.insert(main_menu_buttons, 1, Button:new(150, 40, "Continue", function() game.state = "gameplay" end))
    end

    main_menu.main_menu = Menu:new(main_menu_buttons)
    main_menu.main_menu.parent = nil

    local options_radio_buttons = {
        [1] = RadioButton:new("Fullscreen", { "On", "Off" }),
        [2] = RadioButton:new("VSync", { "On", "Adaptive", "Off" })
    }

    main_menu.options_menu = Menu:new(options_radio_buttons)
    main_menu.options_menu.parent = main_menu.main_menu

    main_menu.current_menu = main_menu.main_menu
    main_menu.selected_button_idx = 1

    -------------------------------------------------
    options_radio_buttons[1].selected_idx = saving.data.settings.fullscreen and 1 or 2

    local vsync = saving.data.settings.vsync
    if vsync == 1 then
        options_radio_buttons[2].selected_idx = 1
    elseif vsync == 0 then
        options_radio_buttons[2].selected_idx = 2
    elseif vsync == -1 then
        options_radio_buttons[2].selected_idx = 3
    end

    main_menu.apply_settings()
end

function main_menu.update(dt, game)
    main_menu.current_menu:update(dt)
    if #main_menu.main_menu.list == 3 and saving.data.progress.current_level > 1 then
        table.insert(main_menu.main_menu.list, 1, Button:new(150, 40, "Continue", function() game.state = "gameplay" end))
    end

    if controls.bindings.down.isPressed then
        main_menu.selected_button_idx = main_menu.selected_button_idx % #main_menu.current_menu.list + 1
    elseif controls.bindings.up.isPressed then
        main_menu.selected_button_idx = main_menu.selected_button_idx - 1
        if main_menu.selected_button_idx == 0 then
            main_menu.selected_button_idx = #main_menu.current_menu.list
        end
    elseif controls.bindings.jump.isPressed then
        if main_menu.current_menu == main_menu.main_menu then
            main_menu.current_menu.list[main_menu.selected_button_idx]:onclick()
            main_menu.selected_button_idx = 1
        else
            main_menu.current_menu.list[main_menu.selected_button_idx]:onclick()
            main_menu.apply_settings()
        end
    elseif controls.bindings.back.isPressed then
        if main_menu.current_menu.parent then
            main_menu.current_menu = main_menu.current_menu.parent
            main_menu.selected_button_idx = 1
        end
    elseif controls.bindings.move_right.isPressed then
        main_menu.current_menu.list[main_menu.selected_button_idx]:keypressed("right")
        main_menu.apply_settings()
    elseif controls.bindings.move_left.isPressed then
        main_menu.current_menu.list[main_menu.selected_button_idx]:keypressed("left")
        main_menu.apply_settings()
    end
end

function main_menu.draw()
    main_menu.current_menu:draw(main_menu.selected_button_idx)
end

function main_menu.apply_settings()
    local options = main_menu.options_menu.list
    for idx, option in ipairs(options) do
        if option.header == "Fullscreen" then
            love.window.setFullscreen(option.selected_idx == 1)
            saving.data.settings.fullscreen = option.selected_idx == 1
        elseif option.header == "VSync" then
            local val
            if option.selected_idx == 1 then
                val = 1
            elseif option.selected_idx == 2 then
                val = 0
            elseif option.selected_idx == 3 then
                val = -1
            end
            love.window.setVSync(val)
            saving.data.settings.vsync = val
        end
    end
    saving.save()
end

return main_menu
