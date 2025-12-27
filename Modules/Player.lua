-- Modules/Player.lua
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local char = LP.Character or LP.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local PlayerFuncs = {}
PlayerFuncs.Humanoid = humanoid
PlayerFuncs.Speed = humanoid.WalkSpeed
PlayerFuncs.JumpPower = humanoid.JumpPower

return PlayerFuncs
