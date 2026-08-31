local ldtk = require("libraries.ldtk-love.ldtk")
local globals = require("globals")
local physics = require("physics")
local bump = require("libraries.bump.bump")

local map = {}

function map.load(player)
    map.currentLevel = nil
    map.currentLayers = {}
    map.collision_boxes = {}
    map.x_scale = 1
    map.y_scale = 1
    map.nextLevelTrigger = nil
    map.anchors = {}
    map.player = player
    ldtk:load("assets/map/world.ldtk")
    ldtk:goTo(4)
end

function map.update(dt)

end

function map.draw()
    love.graphics.push()
    love.graphics.scale(map.x_scale, map.y_scale)
    for _, layer in ipairs(map.currentLayers) do
        layer:draw()
    end
    love.graphics.pop()

    -- for _, box in ipairs(map.collision_boxes) do
    --     love.graphics.rectangle("line", box.x, box.y, box.width, box.height)
    -- end

    love.graphics.print(globals.width .. ", " .. globals.height, 10, 10)
end

function map.loadNextLevel()
    map.player.reset()
    ldtk:next()
end

function ldtk.onEntity(entity)
    if entity.id == "Solid" then
        physics.collision_world:add(entity, entity.x * map.x_scale, entity.y * map.y_scale, entity.width * map.x_scale,
            entity.height * map.y_scale)
        table.insert(map.collision_boxes,
            {
                x = entity.x * map.x_scale,
                y = entity.y * map.y_scale,
                width = entity.width * map.x_scale,
                height = entity.height * map.y_scale
            })
    elseif entity.id == "NextLevelTrigger" then
        map.nextLevelTrigger = {
            x = entity.x * map.x_scale,
            y = entity.y * map.y_scale,
            width = entity.width * map.x_scale,
            height = entity.height * map.y_scale
        }
    elseif entity.id == "Anchor" then
        table.insert(map.anchors, {
            x = entity.x * map.x_scale,
            y = entity.y * map.y_scale
        })
    elseif entity.id == "Trap" then
        physics.collision_world:add(entity, entity.x * map.x_scale, entity.y * map.y_scale, entity.width * map.x_scale,
            entity.height * map.y_scale)
    elseif entity.id == "SpawnPoint" then
        map.spawnPoint = {
            x = entity.x * map.x_scale,
            y = entity.y * map.y_scale
        }
    end
end

function ldtk.onLayer(layer)
    table.insert(map.currentLayers, layer)
end

function ldtk.onLevelLoaded(level)
    map.currentLayers = {}
    map.currentLevel = level
    map.collision_boxes = {}
    map.nextLevelTrigger = nil
    map.anchors = {}
    map.x_scale = globals.width / level.width
    map.y_scale = map.x_scale

    physics.collision_world = bump.newWorld()
end

function ldtk.onLevelCreated(level)
    map.player.x = map.spawnPoint.x
    map.player.y = map.spawnPoint.y

    physics.collision_world:add(map.player, map.player.x, map.player.y, map.player.width, map.player.height)
end

return map
