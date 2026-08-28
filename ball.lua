local balllib = {}

function balllib.newBall(loseCallback)
  local ball = {
    x = 400,
    y = 400,
    w = 20,
    h = 20,
    vx = 100,
    vy = 100,
    loseCallback = loseCallback,
    wallHitSound = love.audio.newSource("wallhit.wav", "static")
  }

  function ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.x < 0 then
      self.x = 0
      self.vx = -self.vx
      love.audio.play(self.wallHitSound)
    end
    if self.y < 0 then
      self.y = 0
      self.vy = -self.vy
      love.audio.play(self.wallHitSound)
    end
    if self.y > love.graphics.getHeight() then
      self.loseCallback(self)
    end
    if self.x + self.w > love.graphics.getWidth() then
      self.x = love.graphics.getWidth() - self.w
      self.vx = -self.vx
      self.wallHitSound:setPitch(math.random() / 5 + 1)
      love.audio.play(self.wallHitSound)
    end
  end

  function ball:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.w, ball.h)
  end

  return ball
end

return balllib
