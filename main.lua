--[[local bricklib = require("brick")
local paddlelib = require("paddle")
local balllib = require("ball")


local bricks = {}
function gameLoss(ball)
    ball.y = 400
    ball.x = 400

    ball.vx = 0
    ball.vy = 0

    for k,v in ipairs(bricks) do
      v.visible = true
    end
end

local ball = balllib.newBall(gameLoss)
local paddle = paddlelib.new(500, 100)

function love.load()
   for i=1,8 do
     for j=1,8 do
       local brick = bricklib.newBrick((i-1)*love.graphics.getWidth()/8, 100 + (j-1)*30, love.graphics.getWidth()/8, 20)
       table.insert(bricks, brick)
     end
   end
 end



function love.update(dt)
  paddle:update(dt, ball)
  for k,v in ipairs(bricks) do
    v:update(ball)
  end
  ball:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  for k,v in ipairs(bricks) do
    v:draw()
  end
  love.graphics.setColor(1, 1, 1)
  paddle:draw()
  ball:draw()
end

function love.keypressed(key, scancode, isrepeat)
   if key == "space" then
     ball.x = 400
     ball.y = 200
     ball.vx = 0
     ball.vy = 50
   end
end
]]

local gamelib = require("game")

game = gamelib.new()
function love.load()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  game:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  game:keyboardPressed(key, scancode, isrepeat)
end
