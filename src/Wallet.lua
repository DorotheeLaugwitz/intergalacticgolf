require ("lib.lclass")

class "Wallet"

function Wallet:Wallet()
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

