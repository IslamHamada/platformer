local sprites = {}

love.graphics.setDefaultFilter("nearest", "nearest")

sprites.player = {
    sprite   = love.graphics.newImage("assets/sprites/player/player.png"),
    idle     = love.graphics.newImage("assets/sprites/player/idle.png"),
    running  = love.graphics.newImage("assets/sprites/player/running.png"),
    climbing = love.graphics.newImage("assets/sprites/player/climbing.png"),
    jumping  = love.graphics.newImage("assets/sprites/player/jumping.png"),
    hooked   = love.graphics.newImage("assets/sprites/player/hooked.png")
}

sprites.trampoline = love.graphics.newImage("assets/sprites/trampoline/trampoline.png")

return sprites
