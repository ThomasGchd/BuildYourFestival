local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage.Shared.Config)
local modules=script.Parent
local World=require(modules.World)
local Plots=require(modules.Plots)
local Music=require(modules.Music)
local world=World.build(Config)
Plots.start(world,Config)
Music.start(world,Config)
Players.PlayerAdded:Connect(function(p) Plots.assign(p,world,Config) end)
for _,p in Players:GetPlayers() do Plots.assign(p,world,Config) end