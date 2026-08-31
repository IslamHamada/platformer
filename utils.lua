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

function utils.angleBetween(x1, y1, x2, y2)
    local dot = x1 * x2 + y1 * y2
    local det = x1 * y2 - y1 * x2
    return math.atan2(det, dot)
end

return utils
