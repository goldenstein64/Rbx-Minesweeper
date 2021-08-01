local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
  local playerGui = player.PlayerGui

local load = require(ReplicatedStorage.DepLoader)
  local Roact = load("Roact")

local Minesweeper = require(ReplicatedStorage.Minesweeper) -- ./src

local presets = {
  easy = {
    size = Vector2.new(9, 9),
    mineCount = 10
  },
  medium = {
    size = Vector2.new(16, 16),
    mineCount = 40
  },
  hard = {
    size = Vector2.new(30, 16),
    mineCount = 99
  },
  extreme = {
    size = Vector2.new(30, 24),
    mineCount = 180
  }
}

local gameElement = Roact.createElement(Minesweeper, presets.hard)

local hostElement = Roact.createElement("ScreenGui", nil, {
  ParentFrame = Roact.createElement("Frame", {
    Size = UDim2.new(0.8, 0, 0.8, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1
  }, {
    Minesweeper = gameElement
  })
})

Roact.mount(hostElement, playerGui)