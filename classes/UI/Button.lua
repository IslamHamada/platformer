local Component = require "classes.UI.Component"

local Button = {}
Button.__index = Button
setmetatable(Button, Component)

function Button:new(width, height, text, onclick)
    local button = Component:new2(width, height)
    setmetatable(button, Button)
    button.text = text
    button.onclick = onclick
    return button
end

function Button:update(dt)
end

function Button:draw()
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
    local text_width = love.graphics.getFont():getWidth(self.text)
    local text_height = love.graphics.getFont():getHeight()
    love.graphics.push()
    love.graphics.translate((self.width - text_width) / 2, (self.height - text_height) / 2)
    love.graphics.print(self.text, 0, 0)
    love.graphics.pop()
end

function Button:keypressed(key)

end

return Button
