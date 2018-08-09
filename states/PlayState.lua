PlayState = Class {__includes = BaseState}

function PlayState:init()
    print "init Play"
end
function PlayState:update(dt)
    ball:update(dt)

    if ball.x < 0 then
        servingPlayer = 1
        player2.score = player2.score + 1
        if player2.score == 10 then
            winningPlayer = 2
            gameState = "done"
            gStateMachine:change("done")
            ball.x = 0 -- for better look
        else
            gameState = "serve"
            gStateMachine:change("serve")
        end
    elseif ball.x > VIRTUAL_RES.WIDTH - ball.width then
        servingPlayer = 2
        player1.score = player1.score + 1
        if player1.score == 10 then
            winningPlayer = 1
            gameState = "done"
            gStateMachine:change("done")
            ball.x = VIRTUAL_RES.WIDTH - ball.width -- for better look
        else
            gameState = "serve"
            gStateMachine:change("serve")
        end
    end

    if ball:collides(player1) then
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + player1.width
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    -- print("Hit player1")    -- FOR DEBUG
    end
    if ball:collides(player2) then
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - ball.width
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    -- print("Hit player2")    -- FOR DEBUG
    end

    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    -- print("Hit TOP of screen")  -- FOR DEBUG
    end
    if ball.y >= VIRTUAL_RES.HEIGHT - ball.width then
        ball.y = VIRTUAL_RES.HEIGHT - ball.width
        ball.dy = -ball.dy
    -- print("Hit BOTTOM of screen")   -- FOR DEBUG
    end
end
function PlayState:render()
    -- no UI messages to display in play
end
