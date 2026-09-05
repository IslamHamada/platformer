local globals           = require "globals"
local physics           = {}

physics.gravity         = globals.height * 3

physics.collision_world = nil

function physics.applyVelocity(object, dt)
    local goalX = object.x + object.x_vel * dt
    local goalY = object.y + object.y_vel * dt
    return goalX, goalY
end

function physics.applyAngularVelocity(object, dt)
    object.swing_angle = object.swing_angle + object.omega * dt
end

function physics.applyAcceleration(object, dt)
    object.x_vel = object.x_vel + object.x_acc * dt
    object.y_vel = object.y_vel + object.y_acc * dt
end

function physics.applyAngularAcceleration(object, dt)
    object.omega = object.omega + object.alpha * dt
end

function physics.applyGravity(object, dt)
    object.y_vel = object.y_vel + physics.gravity * dt
end

function physics.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end

return physics
