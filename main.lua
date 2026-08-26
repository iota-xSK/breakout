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
