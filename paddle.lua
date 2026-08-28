local paddle = {}


function paddle.new(y, width)
  local pad = {
    x = 0,
    y = y,
    width = width,
    hits = 0,
    hitSound = love.audio.newSource("paddleHit.wav", "static")
  }
  local LUT = { -- TODO: add last from https://archive.org/details/super-breakout-game-manual-atari-2600-1981/page/4/mode/2up
    {
      {-50*5, -30*5},
      {-60*5, -20*5},
      {-40*5, -40*5},
    },
    {
       {-40*5, -45*5},
       {-65*5, -30*5},
       {-30*5, -50*5},
    },
    {
      {40*5, -45*5},
      {65*5, -30*5},
      {30*5, -50*5},
    },
    {
      {50*5, -30*5},
      {60*5, -20*5},
      {40*5, -40*5},
    },
  }

  function pad:update(dt, ball)
    self.x = love.mouse.getX() - self.width/2
    if ball.y + ball.h > self.y
      and ball.y < self.y
      and ball.x < self.x + self.width
      and ball.x + ball.w > self.x
    then
      ball.y = ball.y - ((ball.y + ball.h) - self.y)
      local localpos = (ball.x + ball.h/2) - self.x
      for k,v in ipairs(LUT) do
        if localpos < k*width/4 then
          for k2, v2 in ipairs(v) do
            if math.min(self.hits, 8*3) <= 8*k2 then
              ball.vx = v2[1]
              ball.vy = v2[2]
              break
            end
          end
          break
        end
      end
      self.hits = self.hits + 1
      self.hitSound:setPitch(math.random()/5 + 1)
      love.audio.play(self.hitSound)
    end
  end

  function pad:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, 20)
  end
  return pad
end

return paddle
