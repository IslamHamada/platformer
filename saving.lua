local saving_state = {}

saving_state.file = "save.json"
saving_state.data = {
    settings = {
        fullscreen = true,
        vsync = 1
    },
    progress = {
        current_level = 1,
    }
}

function saving_state.load()
    if love.filesystem.getInfo(saving_state.file) then
        local file = love.filesystem.read(saving_state.file)
        saving_state.data = json.decode(file)
    end
end

function saving_state.save()
    local encoded_data = json.encode(saving_state.data)
    love.filesystem.write(saving_state.file, encoded_data)
end

return saving_state
