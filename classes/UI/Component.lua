local Component = {}
Component.__index = Component

function Component:new(x, y, width, height)
    local component = {
        x = x,
        y = y,
        width = width,
        height = height,
    }
    setmetatable(component, Component)
    return component
end

function Component:new2(width, height)
    local component = {
        width = width,
        height = height,
    }
    setmetatable(component, Component)
    return component
end

return Component
