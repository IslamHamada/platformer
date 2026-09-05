local utils = {}

function utils.lerp(a, b, t)
    return a + (b - a) * t
end

function utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function utils.length(x1, y1)
    return math.sqrt(x1 ^ 2 + y1 ^ 2)
end

return utils
