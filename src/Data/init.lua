local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local GoodSignal = load("GoodSignal")
local Array2D = load("Array2D")

local DataCell = require(script.DataCell)

local Data = {}
Data.__index = Data

function Data.new(props)
	local self = {
		size = props.size,
		mineCount = props.mineCount,
	}

	self.cellsLeft = self.size.X * self.size.Y - self.mineCount
	self.minesLeft, self.setMinesLeft = Roact.createBinding(self.mineCount)
	self.time, self.setTime = Roact.createBinding(0)
	self.face, self.setFace = Roact.createBinding("🙂")

	self.cellChanged = GoodSignal.new()
	self.reseted = GoodSignal.new()

	local cells = Array2D.new()
	self.cells = cells
	for x = 1, self.size.X do
		for y = 1, self.size.Y do
			local cell = DataCell.new(self, x, y)
			cells:set(x, y, cell)
			cell.changed:Connect(function(newState)
				self:onStateChanged(cell, newState)
			end)
		end
	end

	setmetatable(self, Data)

	return self
end

function Data:onStateChanged(cell, newState)
	if newState == "open" then
		self.cellsLeft -= 1
	elseif newState == "flagged" then
		self.setMinesLeft(self.minesLeft:getValue() - 1)
	elseif newState == "closed" then
		self.setMinesLeft(self.minesLeft:getValue() + 1)
	end

	self.cellChanged:Fire(cell)
end

return Data
