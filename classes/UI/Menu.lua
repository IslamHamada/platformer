local globals = require "globals"
local Component = require "classes.UI.Component"
local Menu = {}
Menu.__index = Menu
setmetatable(Menu, Component)

function Menu:new(list)
    local menu = {
        list = list,
        x = globals.width / 2,
        y = globals.height / 2
    }
    setmetatable(menu, Menu)
    return menu
end

function Menu:update(dt)
    for _, component in ipairs(self.list) do
        component:update(dt)
    end
    self.x = (globals.width - 150) / 2
    self.y = globals.height / 2
end

function Menu:draw(selected_idx)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    for idx, component in ipairs(self.list) do
        love.graphics.translate(0, 50)
        if idx == selected_idx then
            love.graphics.setColor(1, 1, 0)
        end
        component:draw()
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.pop()
end

return Menu
