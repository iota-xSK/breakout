local brick = {}
function brick.newBrick(x, y, w, h, callback)
  local Rect = {
    x = x,
    y = y,
    w = w,
    h = h,
    visible = true,
    callback = callback
  }

  function Rect:update(ball)
    if self.visible then
      local a_min_x = self.x
      local a_max_x = self.x + self.w

      local b_min_x = ball.x
      local b_max_x = ball.x + ball.w


      local a_min_y = self.y
      local a_max_y = self.y + self.h

      local b_min_y = ball.y
      local b_max_y = ball.y + ball.h

      if a_min_x < b_max_x and a_max_x > b_min_x
        and a_min_y < b_max_y and a_max_y > b_min_y
      then
        self.visible = false
        if self.callback ~= nil then
          self.callback()
        end
        if
         math.min(a_max_x, b_max_x) - math.max(a_min_x, b_min_x) >
         math.min(a_max_y, b_max_y) - math.max(a_min_y, b_min_y)
        then
          if ball.vy < 0 then
            ball.y = self.y + self.h
          else
            ball.y = self.y - ball.h
          end
          ball.vy = -ball.vy
        else
          if ball.vx < 0 then
            ball.x = self.x + self.w
          else
            ball.x = self.x - ball.w
          end
          ball.vx = -ball.vx
        end
      end
    end
  end

  function Rect:draw()
    if self.visible then
      love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
  end
  return Rect
end

return brick
