local Component = require "classes.UI.Component"

local RadioButton = {}
RadioButton.__index = RadioButton
setmetatable(RadioButton, Component)

function RadioButton:new(header, options)
    local radio_button = {
        header = header,
        options = options,
        selected_idx = 1,
    }
    setmetatable(radio_button, RadioButton)
    return radio_button
end

function RadioButton:update(dt)

end

function RadioButton:draw()
    love.graphics.print(self.header .. ": " .. self.options[self.selected_idx])
end

function RadioButton:keypressed(key)
    if key == "left" then
        self.selected_idx = self.selected_idx - 1
        if self.selected_idx == 0 then
            self.selected_idx = #self.options
        end
    elseif key == "right" then
        self.selected_idx = self.selected_idx % #self.options + 1
    end
end

function RadioButton:onclick()
    self.selected_idx = self.selected_idx % #self.options + 1
end

return RadioButton
