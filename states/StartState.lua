StartState = Class {__includes = BaseState}

function StartState:init()
    print "init Start"
end

function StartState:update(dt)
    if love.keyboard.wasPressed("return") or love.keyboard.wasPressed("kpenter") then
        gameState = "serve"
        gStateMachine:change("serve")
    end
end

function StartState:render()
    love.graphics.setFont(smallFont)
    love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_RES.WIDTH, "center")
    love.graphics.printf("Press Enter to begin!", 0, 20, VIRTUAL_RES.WIDTH, "center")
end
