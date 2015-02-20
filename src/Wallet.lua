require ("lib.lclass")

class "Wallet"

function Wallet:Wallet(game)
  self.game = game
  self.balance = 250
end

function Wallet:getBalance ()
  return math.floor(self.balance)
end

function Wallet:balanceAsString ()
  return tostring(math.floor(self.balance))
end

function Wallet:add (number)
  self.balance = self.balance + number
  return self.balance
end

function Wallet:withdraw (number)
  self.balance = self.balance - number
  return self.balance
end

function Wallet:onUpdate (dt)
  self:add(1 * dt)

  for _, planet in pairs(self.game.planets) do
    self.balance = self.balance + planet:income () * dt
  end

  for _, line in pairs(self.game.lines) do
    self.balance = self.balance + line:income () * dt
  end
end
