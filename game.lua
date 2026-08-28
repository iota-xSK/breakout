local bricklib = require("brick")
local paddlelib = require("paddle")
local balllib = require("ball")

local gamelib = {}

local gameStateMachine = {
  ["idle"] = {
    ["start"] =  function(game)
      game.gameState = "playing"
      print("starting")
      game.ball.y = 400
      game.ball.x = 400

      game.ball.vx = math.cos(math.random()*math.pi) * 300
      game.ball.vy = math.sin(math.random()*math.pi) * 300
      game.paddle.hits = 0
    end,
  },
  ["playing"] = {
    ["game end"] = function(game)
      game.gameState = "idle"
        game.ball.y = 400
        game.ball.x = 400

        game.ball.vx = 0
        game.ball.vy = 0
        game.paddle.hits = 0

        for k,v in ipairs(game.bricks) do
          v.visible = true
        end
        game.points = 0
    end
  }
}

function gamelib.new()
  local game = {
  }

  game.gameState = "idle"

  game.bricks = {}

  local lossSound = love.audio.newSource("loss.wav", "static")
  function game.gameLoss(ball)
    gameStateMachine[game.gameState]["game end"](game)
    love.audio.play(lossSound)
  end

  local font = love.graphics.newFont("DepartureMono-1.500/DepartureMono-Regular.otf", 40)
  local clickSound = love.audio.newSource("click.wav", "static")

  game.ball = balllib.newBall(game.gameLoss)
  game.paddle = paddlelib.new(500, 100)
  game.points = 0

  local colorLUT = {
    {0.9176, 0.5020, 0.2824},
    {0.8588, 0.9176, 0.2823},
    {0.3804, 0.9176, 0.2824},
    {0.2823, 0.9176, 0.6588},
    {0.2823, 0.6980, 0.9176},
    {0.2823, 0.6980, 0.9176},
    {0.3412, 0.2824, 0.9176},
    {0.8196, 0.2824, 0.9176},
    {0.9176, 0.2824, 0.5372}
    }
  for i=1,8 do
    for j=1,8 do
      local brick = bricklib.newBrick(
        (i-1)*love.graphics.getWidth()/8,
        100 + (j-1)*30,
        love.graphics.getWidth()/8, 20,
        colorLUT[j],
        function()
          clickSound:setPitch(math.random() / 5 + 1)
          love.audio.play(clickSound)
          game.points = game.points + 1
          if game.points >= 64 then
           gameStateMachine[game.gameState]["game end"](game)
          end
        end
      )
      table.insert(game.bricks, brick)
    end
   end

   function game:update(dt)
     if game.gameState == "idle" then
      self.paddle:update(dt, self.ball)
     elseif game.gameState == "playing" then
      self.paddle:update(dt, self.ball)
      for k,v in ipairs(self.bricks) do
        v:update(self.ball)
      end
      self.ball:update(dt)
     end
   end


   function game:draw()
     love.graphics.setFont(font)
     love.graphics.setColor(1, 1, 1)
     for k,v in ipairs(self.bricks) do
       v:draw()
     end
     self.paddle:draw()
     self.ball:draw()
     love.graphics.setColor(1, 1, 1)
     love.graphics.print(tostring(self.points), love.graphics.getWidth()/2 - 40, 40)
   end

   function game:keyboardPressed(key, scancode, isrepeat)
     if key == "space" then
      if game.gameState == "idle" then
        gameStateMachine[game.gameState]["start"](game)
      end
     end
   end
   return game
end

return gamelib
