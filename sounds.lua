local sounds = {
    walk = love.audio.newSource("assets/sounds/walk.ogg", "static"),
    jump = love.audio.newSource("assets/sounds/jump.ogg", "static"),
    climb = love.audio.newSource("assets/sounds/climb.ogg", "static"),
    bounce = love.audio.newSource("assets/sounds/bounce.mp3", "static"),
    death = love.audio.newSource("assets/sounds/death.mp3", "static"),
    hook = love.audio.newSource("assets/sounds/hook.wav", "static")
}

function sounds.load()
    sounds.walk:setPitch(0.5)
    sounds.walk:setVolume(0.5)

    sounds.jump:setLooping(false)
    sounds.climb:setPitch(0.75)
end

return sounds
