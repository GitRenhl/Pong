DoneState = Class {__includes = BaseState}

function DoneState:init()
    print "init: Done"
end

function DoneState:update(dt)
    if love.keyboard.isDown("kpenter") or love.keyboard.isDown("return") then
        print("RESET")
        gStateMachine:change("serve")
        if winningPlayer == 1 then
            servingPlayer = 2
        else
            servingPlayer = 1
        end
        player1.score = 0
        player2.score = 0
    end
end

function DoneState:render()
    love.graphics.setFont(largeFont)
    love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_RES.WIDTH, "center")
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_RES.WIDTH, "center")
end
