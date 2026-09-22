local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage.Shared.Config)
local modules=script.Parent

-- Boot each system independently so one optional feature can never erase the whole game.
local function loadModule(name)
 local ok,result=pcall(function() return require(modules:WaitForChild(name)) end)
 if not ok then warn("[BYF] "..name.." require failed: "..tostring(result));return nil end
 return result
end

local World=loadModule("World")
local Plots=loadModule("Plots")
local Music=loadModule("Music")
local ShowFX=loadModule("ShowFX")

local world
if World then
 local ok,result=pcall(function() return World.build(Config) end)
 if ok then world=result else warn("[BYF] WORLD BUILD FAILED: "..tostring(result)) end
end

-- Emergency world: the player must NEVER spawn into an empty Studio baseplate.
if not world then
 warn("[BYF] Starting emergency festival world")
 local old=workspace:FindFirstChild("FestivalWorld");if old then old:Destroy()end
 local root=Instance.new("Folder");root.Name="FestivalWorld";root.Parent=workspace
 local function block(name,size,pos,color)
  local x=Instance.new("Part");x.Name=name;x.Size=size;x.Position=pos;x.Anchored=true;x.Color=color;x.Material=Enum.Material.SmoothPlastic;x.Parent=root;return x
 end
 block("Ground",Vector3.new(850,2,850),Vector3.new(0,0,-100),Color3.fromRGB(37,75,45))
 block("Festival Avenue",Vector3.new(90,1,650),Vector3.new(0,1,-60),Color3.fromRGB(52,54,62))
 local plots=Instance.new("Folder");plots.Name="Plots";plots.Parent=root
 for row=0,3 do for _,side in ipairs({-1,1})do
  local i=row*2+(side==1 and 2 or 1);local model=Instance.new("Model");model.Name="Plot"..i;model.Parent=plots
  local floor=Instance.new("Part");floor.Name="Floor";floor.Size=Vector3.new(175,1,112);floor.Position=Vector3.new(side*205,1,135-row*125);floor.Anchored=true;floor.Color=Color3.fromRGB(49,91,55);floor.Parent=model
  local sign=Instance.new("Part");sign.Name="OwnerSign";sign.Size=Vector3.new(20,6,1);sign.Position=floor.Position+Vector3.new(-side*70,4,48);sign.Anchored=true;sign.Parent=model
  local g=Instance.new("BillboardGui");g.Name="OwnerGui";g.Size=UDim2.fromOffset(180,45);g.Parent=sign
  local t=Instance.new("TextLabel");t.Name="Text";t.Size=UDim2.fromScale(1,1);t.Text="SLOT LIBRE";t.TextScaled=true;t.Parent=g
 end end
 local stage=Instance.new("Model");stage.Name="Mainstage";stage.Parent=root
 local screen=Instance.new("Part");screen.Name="Screen";screen.Size=Vector3.new(100,40,2);screen.Position=Vector3.new(0,35,-515);screen.Anchored=true;screen.Color=Color3.fromRGB(95,55,210);screen.Parent=stage
 local sound=Instance.new("Sound");sound.Name="Music";sound.Parent=screen
 local console=block("MusicConsole",Vector3.new(10,5,5),Vector3.new(0,3,-450),Color3.fromRGB(30,32,38));console.Parent=stage
 local prompt=Instance.new("ProximityPrompt");prompt.ActionText="CHOISIR LA MUSIQUE";prompt.Parent=console
 world={root=root,plots=plots,stage=stage,screen=screen,sound=sound,console=console}
end

if Plots and world then
 local ok,err=pcall(function() Plots.start(world,Config) end);if not ok then warn("[BYF] Plots.start failed: "..tostring(err))end
 local function assign(p)local good,e=pcall(function()Plots.assign(p,world,Config)end);if not good then warn("[BYF] Plot assign failed: "..tostring(e))end end
 Players.PlayerAdded:Connect(assign);for _,p in Players:GetPlayers()do assign(p)end
end
if Music and world then local ok,e=pcall(function()Music.start(world,Config)end);if not ok then warn("[BYF] Music failed: "..tostring(e))end end
if ShowFX and world then local ok,e=pcall(function()ShowFX.start(world)end);if not ok then warn("[BYF] ShowFX failed: "..tostring(e))end end
