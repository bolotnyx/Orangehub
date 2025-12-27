-- Modules/Player.lua
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")

local PlayerFuncs = {}
PlayerFuncs.Humanoid = Hum
PlayerFuncs.Speed = Hum.WalkSpeed
PlayerFuncs.JumpPower = Hum.JumpPower

return PlayerFuncs
