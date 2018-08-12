Class = require "lib/class"
push = require "lib/push"
require "lib/table_lenght"

require "Player"
require "Ball"

require "StateMachine"
require "states/TESTState"
require "states/BaseState"
require "states/StartState"
require "states/PlayState"
require "states/ServeState"
require "states/DoneState"

deltatime = 0.0
WINDOW_RES = {
    WIDTH = 1280,
    HEIGHT = 1280 / 16 * 9
}
VIRTUAL_RES = {
    WIDTH = 432,
    HEIGHT = 432 / 16 * 9
}

PlayerSpeed = 200

winningPlayer = 1

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Lua Game <3")

    math.randomseed(os.time())

    player1 = Player(5, math.floor(VIRTUAL_RES.HEIGHT / 2), 5, 20)
    player2 = Player(VIRTUAL_RES.WIDTH - 10, math.floor(VIRTUAL_RES.HEIGHT / 2), 5, 20)
    ball = Ball(VIRTUAL_RES.WIDTH / 2 - 2, VIRTUAL_RES.HEIGHT / 2 - 2, 4, 4)

    smallFont = love.graphics.newFont("font.ttf", 8)
    largeFont = love.graphics.newFont("font.ttf", 16)
    scoreFont = love.graphics.newFont("font.ttf", 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(
        VIRTUAL_RES.WIDTH,
        VIRTUAL_RES.HEIGHT,
        WINDOW_RES.WIDTH,
        WINDOW_RES.HEIGHT,
        {
            fullscreen = false,
            resizable = true,
            vsync = true
        }
    )
    gStateMachine =
        StateMachine {
        ["test"] = function()
            return TESTState()
        end,
        ["start"] = function()
            return StartState()
        end,
        ["serve"] = function()
            return ServeState()
        end,
        ["play"] = function()
            return PlayState()
        end,
        ["done"] = function()
            return DoneState()
        end
    }
    gStateMachine:change("start")

    gameState = "start"
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "done" then
            gameState = "serve"
            ball:reset()
            player1.score = 0
            player2.score = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.update(dt)
    if gameState == "serve" then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        elseif servingPlayer == 2 then
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == "play" then
        if ball.x < 0 then
            servingPlayer = 1
            player2.score = player2.score + 1
            if player2.score == 10 then
                winningPlayer = 2
                gameState = "done"
            else
                gameState = "serve"
            end
            ball:reset()
        elseif ball.x > VIRTUAL_RES.WIDTH - ball.width then
            servingPlayer = 2
            player1.score = player1.score + 1
            if player1.score == 10 then
                winningPlayer = 1
                gameState = "done"
            else
                gameState = "serve"
            end
            ball:reset()
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

    -- self.gStateMachine:update(dt)

    if love.keyboard.isDown("w") then
        player1.dy = -PlayerSpeed
    elseif love.keyboard.isDown("s") then
        player1.dy = PlayerSpeed
    else
        player1.dy = 0
    end
    if love.keyboard.isDown("up") then
        player2.dy = -PlayerSpeed
    elseif love.keyboard.isDown("down") then
        player2.dy = PlayerSpeed
    else
        player2.dy = 0
    end

    if gameState == "play" then
        ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:apply("start")
    -- love.graphics.clear(0.15, 0.17, 0.20, 1)

    displayScore()

    if gameState == "start" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_RES.WIDTH, "center")
        love.graphics.printf("Press Enter to begin!", 0, 20, VIRTUAL_RES.WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_RES.WIDTH, "center")
        love.graphics.printf("Press Enter to serve!", 0, 20, VIRTUAL_RES.WIDTH, "center")
    elseif gameState == "play" then
        -- no UI messages to display in play
    elseif gameState == "done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_RES.WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_RES.WIDTH, "center")
    end

    player1:render()
    player2:render()
    ball:render()
    displayDebugInfo()

    push:apply("end")
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1.score, VIRTUAL_RES.WIDTH / 2 - 40, VIRTUAL_RES.HEIGHT / 3)
    love.graphics.print(player2.score, VIRTUAL_RES.WIDTH / 2 + 20, VIRTUAL_RES.HEIGHT / 3)
end

function displayDebugInfo()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print(string.format("Ball: (%d, %d)", ball.x, ball.y), 10, 20)
    love.graphics.print(string.format("Ball DY: %d", ball.dx), 10, 26)
    displayFPS()
end

function displayFPS()
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
