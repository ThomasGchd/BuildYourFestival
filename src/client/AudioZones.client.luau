local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer

local function getMainSound()
 local world=workspace:FindFirstChild("FestivalWorld")
 local stage=world and world:FindFirstChild("Mainstage")
 local screen=stage and stage:FindFirstChild("Screen")
 return screen and screen:FindFirstChild("Music")
end

RunService.RenderStepped:Connect(function()
 local character=player.Character
 local root=character and character:FindFirstChild("HumanoidRootPart")
 local sound=getMainSound()
 if not root or not sound then return end
 local pos=root.Position
 local inAvenue=math.abs(pos.X)<=62 and pos.Z>=-350 and pos.Z<=285
 local inArena=math.abs(pos.X)<=175 and pos.Z>=-535 and pos.Z<-350
 local target=(inAvenue or inArena) and .72 or 0
 sound.Volume=sound.Volume+(target-sound.Volume)*.12
end)
