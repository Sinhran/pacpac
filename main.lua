_G.love = require("love")


function love.load()
  love.graphics.setBackgroundColor(0,0,0)
  math.randomseed(os.time())

  _G.pacman = {
    x = 100,
    y = 200,
    radius = 15,
    alpha = 0.5,
    beta = 5.5,
    beta_full = false,
    beta_min = true,
    direction = "right"
  }

  _G.food = {}

  function createFood()
    return {
      x = math.random(0, love.graphics.getWidth()),
      y = math.random(0, love.graphics.getHeight()),
      eaten = false
    }
  end

  for i = 1, 10 do
    table.insert(food, createFood())
  end

  function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
  end

end

function love.update(dt)

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  if love.keyboard.isDown("right") then
    if pacman.x + pacman.radius * 2 < screen_width then
      pacman.x = pacman.x + 2
    end
    pacman.direction = "right"
  elseif love.keyboard.isDown("left") then
    if pacman.x - pacman.radius * 2 > 0 then
      pacman.x = pacman.x - 2
    end
    pacman.direction = "left"
  elseif love.keyboard.isDown("up") then
    if pacman.y - pacman.radius * 2 > 0 then
      pacman.y = pacman.y - 2
    end
    pacman.direction = "up"
  elseif love.keyboard.isDown("down") then
    if pacman.y + pacman.radius * 2 < screen_height then
      pacman.y = pacman.y + 2
    end
    pacman.direction = "down"
  end

  if pacman.beta_full == false then
    pacman.beta = pacman.beta + dt
  end
  if pacman.beta_min == false then
    pacman.beta = pacman.beta - dt
  end
  if pacman.beta >= 6.28 then
    pacman.beta_full = true
    pacman.beta_min = false
  end
  if pacman.beta <= 5.5 then
    pacman.beta_full = false
    pacman.beta_min = true
  end

  for _, food in ipairs(food) do
    if not food.eaten and distance(pacman.x, pacman.y, food.x, food.y) < pacman.radius then
      food.eaten = true
    end
  end

end

function love.draw()
  love.graphics.setColor(1,0,0)
  for _, food in ipairs(food) do
    if not food.eaten then
      love.graphics.circle("fill", food.x, food.y, 5)
    end
  end

  love.graphics.setColor(1, 1, 0)

  love.graphics.push()
  love.graphics.translate(pacman.x, pacman.y)
  if pacman.direction == "left" then
      love.graphics.rotate(math.pi)
  elseif pacman.direction == "up" then
      love.graphics.rotate(-math.pi / 2)
  elseif pacman.direction == "down" then
      love.graphics.rotate(math.pi / 2)
  end

  love.graphics.arc("fill", 0, 0, pacman.radius, pacman.alpha, pacman.beta)

  love.graphics.pop()

end
