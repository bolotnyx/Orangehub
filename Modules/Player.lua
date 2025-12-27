-- Modules/Player.lua
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local PlayerFuncs = {}

PlayerFuncs.Speed = 16
PlayerFuncs.JumpPower = 50

Humanoid.WalkSpeed = PlayerFuncs.Speed
Humanoid.JumpPower = PlayerFuncs.JumpPower

return PlayerFuncs
