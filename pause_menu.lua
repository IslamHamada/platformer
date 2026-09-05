local Button = require("classes.UI.Button")
local Menu = require("classes.UI.Menu")
local controls = require("controls")

local pause_menu = {}

function pause_menu.load(game)
    pause_menu.options = {
        [1] = Button:new(150, 40, "Resume", function() game.state = "gameplay" end),
        [2] = Button:new(150, 40, "Return to Main Menu", function() game.state = "main_menu" end),
        [3] = Button:new(150, 40, "Quit", function() love.event.quit() end)
    }

    pause_menu.menu = Menu:new(pause_menu.options)

    pause_menu.selected_button_idx = 1
end

function pause_menu.update(dt)
    pause_menu.menu:update(dt)

    if controls.bindings.down.isPressed then
        pause_menu.selected_button_idx = pause_menu.selected_button_idx % #pause_menu.menu.list + 1
    elseif controls.bindings.up.isPressed then
        pause_menu.selected_button_idx = pause_menu.selected_button_idx - 1
        if pause_menu.selected_button_idx == 0 then
            pause_menu.selected_button_idx = #pause_menu.menu.list
        end
    elseif controls.bindings.jump.isPressed then
        pause_menu.menu.list[pause_menu.selected_button_idx]:onclick()
    elseif controls.bindings.start.isPressed then
        pause_menu.options[1].onclick()
        pause_menu.selected_button_idx = 1
    end
end

function pause_menu.draw()
    pause_menu.menu:draw(pause_menu.selected_button_idx)
end

return pause_menu
