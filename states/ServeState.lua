ServeState = Class {__includes = BaseState}

function ServeState:init()
    ball:reset()
    print "init Serve"
    ball.dy = math.random(-50, 50)
    if servingPlayer == 1 then
        ball.dx = -math.random(140, 200)
    elseif servingPlayer == 2 then
        ball.dx = math.random(140, 200)
    end
end

function ServeState:update(dt)
    if love.keyboard.wasPressed("return") or love.keyboard.wasPressed("kpenter") then
        gameState = "play"
        gStateMachine:change("play")
    end
end

function ServeState:render()
    love.graphics.setFont(smallFont)
    love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_RES.WIDTH, "center")
    love.graphics.printf("Press Enter to serve!", 0, 20, VIRTUAL_RES.WIDTH, "center")
end
