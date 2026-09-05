local globals = {}


globals.width, globals.height = love.graphics.getDimensions()

function globals.load()

end

function globals.update(dt)
    globals.width, globals.height = love.graphics.getDimensions()
end

return globals
