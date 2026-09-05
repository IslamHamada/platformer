local Animation = {}

Animation.__index = Animation

function Animation:new(sprite, rows, columns, n_quads, quad_duration)
    local new_animation = {
        sprite = sprite,
        rows = rows,
        columns = columns,
        n_quads = n_quads,
        quad_duration = quad_duration
    }
    setmetatable(new_animation, Animation)

    new_animation.quad_width = new_animation.sprite:getWidth() / new_animation.columns
    new_animation.quad_height = new_animation.sprite:getHeight() / new_animation.rows
    new_animation.quad_duration = quad_duration
    new_animation.quads = {}

    for i = 1, new_animation.n_quads do
        new_animation.quads[i] = love.graphics.newQuad((i - 1) * new_animation.quad_width, 0,
            new_animation.quad_width, new_animation.quad_height,
            new_animation.sprite:getWidth(), new_animation.sprite:getHeight())
    end

    return new_animation
end

return Animation
