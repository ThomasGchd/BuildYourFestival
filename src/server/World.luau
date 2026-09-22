local M={}
local function part(parent,name,size,cf,color,material)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.Parent=parent;return p
end
function M.build(Config)
 local old=workspace:FindFirstChild("FestivalWorld");if old then old:Destroy() end
 local root=Instance.new("Folder");root.Name="FestivalWorld";root.Parent=workspace
 local ground=part(root,"Ground",Vector3.new(420,2,650),CFrame.new(0,-1,-100),Color3.fromRGB(47,94,53),Enum.Material.Grass)
 local avenue=part(root,"Festival Avenue",Vector3.new(62,.5,500),CFrame.new(0,.1,-60),Color3.fromRGB(62,62,68),Enum.Material.Concrete)
 local plaza=part(root,"Mainstage Plaza",Vector3.new(250,.5,130),CFrame.new(0,.12,-350),Color3.fromRGB(54,54,60),Enum.Material.Concrete)
 local plots=Instance.new("Folder");plots.Name="Plots";plots.Parent=root
 for row=0,3 do
  for _,side in ipairs({-1,1}) do
   local i=row*2+(side==1 and 2 or 1)
   local model=Instance.new("Model");model.Name="Plot"..i;model:SetAttribute("Index",i);model.Parent=plots
   local z=120-row*105;local x=side*125
   local floor=part(model,"Floor",Vector3.new(120,.6,85),CFrame.new(x,.2,z),Color3.fromRGB(60,112,65),Enum.Material.Grass)
   model.PrimaryPart=floor
   local sign=part(model,"OwnerSign",Vector3.new(30,8,1),CFrame.new(x-side*43,5,z+38),Color3.fromRGB(20,22,28),Enum.Material.Metal)
   local gui=Instance.new("BillboardGui");gui.Name="OwnerGui";gui.Size=UDim2.fromOffset(220,60);gui.StudsOffset=Vector3.new(0,5,0);gui.MaxDistance=80;gui.Parent=sign
   local txt=Instance.new("TextLabel");txt.Name="Text";txt.Size=UDim2.fromScale(1,1);txt.BackgroundTransparency=.15;txt.BackgroundColor3=Color3.fromRGB(18,20,26);txt.TextColor3=Color3.new(1,1,1);txt.Font=Enum.Font.GothamBold;txt.TextScaled=true;txt.Text="SLOT LIBRE";txt.Parent=gui
  end
 end
 local stage=Instance.new("Model");stage.Name="Mainstage";stage.Parent=root
 part(stage,"Deck",Vector3.new(190,7,48),CFrame.new(0,3.5,-410),Color3.fromRGB(20,21,27),Enum.Material.Metal)
 part(stage,"Back",Vector3.new(190,58,5),CFrame.new(0,31,-432),Color3.fromRGB(13,14,19),Enum.Material.Metal)
 part(stage,"Roof",Vector3.new(210,5,58),CFrame.new(0,62,-410),Color3.fromRGB(18,19,24),Enum.Material.Metal)
 local screen=part(stage,"Screen",Vector3.new(90,34,1),CFrame.new(0,36,-428.8),Color3.fromRGB(84,55,180),Enum.Material.Neon)
 local sound=Instance.new("Sound");sound.Name="Music";sound.Volume=.55;sound.RollOffMaxDistance=330;sound.RollOffMinDistance=35;sound.Parent=screen
 local console=part(stage,"MusicConsole",Vector3.new(12,5,5),CFrame.new(0,4,-372),Color3.fromRGB(32,35,43),Enum.Material.Metal)
 local prompt=Instance.new("ProximityPrompt");prompt.ActionText="CHOISIR LA MUSIQUE";prompt.ObjectText="MAINSTAGE • ROBUX";prompt.MaxActivationDistance=12;prompt.RequiresLineOfSight=false;prompt.Parent=console
 -- Lasers
 local fx=Instance.new("Folder");fx.Name="FX";fx.Parent=stage
 for i=1,20 do
  local x=-85+(i-1)*(170/19)
  local head=part(fx,"LaserHead",Vector3.new(1,1,1),CFrame.new(x,55,-410),Color3.fromHSV((i%6)/6,.8,1),Enum.Material.Neon)
  local target=part(fx,"LaserTarget",Vector3.new(.1,.1,.1),CFrame.new(x*1.3,3,-310),Color3.new(),Enum.Material.SmoothPlastic);target.Transparency=1;target.CanCollide=false
  local a=Instance.new("Attachment");a.Parent=head;local b=Instance.new("Attachment");b.Parent=target
  local beam=Instance.new("Beam");beam.Attachment0=a;beam.Attachment1=b;beam.Width0=.32;beam.Width1=.06;beam.FaceCamera=true;beam.LightEmission=1;beam.Color=ColorSequence.new(head.Color);beam.Parent=head
 end
 local spawn=Instance.new("SpawnLocation");spawn.Name="FestivalSpawn";spawn.Size=Vector3.new(16,1,12);spawn.Position=Vector3.new(0,1,205);spawn.Anchored=true;spawn.Neutral=true;spawn.Parent=root
 return {root=root,plots=plots,stage=stage,screen=screen,sound=sound,console=console}
end
return M