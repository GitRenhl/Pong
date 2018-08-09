Class = require "class"
gameState = Class {current = 0}

function gameState:init(state)
    self.current = state
    self.Level = {
        START = 0,
        PLAY = 1,
        DONE = 2,
        SERVE = 3,
        PAUSE = 4
    }
end

function gameState:get(dt)
    return self.current
end

function gameState:set(state)
    self.current = state
end

gameState = gameState()
