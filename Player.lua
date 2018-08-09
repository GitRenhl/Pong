Player = Class {score = 0}

function Player:init(x, y, width, height, score)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0

    self.score = score
end

function Player:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_RES.HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Player:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
