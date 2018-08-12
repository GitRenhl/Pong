Class = require "lib/class"
push = require "lib/push"
require "lib/count_length"

require "Player"
require "Ball"

require "StateMachine"
require "states/TESTState"
require "states/BaseState"
require "states/StartState"
require "states/PlayState"
require "states/ServeState"
require "states/DoneState"

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

    debug_info = false

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
    elseif key == "f1" then
        debug_info = not debug_info
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.isDown(key)
end

function love.update(dt)
    gStateMachine:update(dt)

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

    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:apply("start")
    love.graphics.clear(0, 0, 0, 1)

    displayScore()

    gStateMachine:render()

    player1:render()
    player2:render()
    ball:render()

    if debug_info then
        displayDebugInfo()
    end

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
