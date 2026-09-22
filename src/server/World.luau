local Lighting=game:GetService("Lighting")
local M={}
local function part(parent,name,size,cf,color,material)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.Parent=parent;return p
end
local function textSign(parent,pos,size,text)
 local board=part(parent,"Sign",size,CFrame.new(pos),Color3.fromRGB(16,18,23),Enum.Material.Metal)
 local g=Instance.new("SurfaceGui");g.Face=Enum.NormalId.Front;g.Parent=board
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextColor3=Color3.new(1,1,1);t.Font=Enum.Font.GothamBlack;t.TextScaled=true;t.Parent=g
 return board
end
local function lamp(parent,pos)
 local pole=part(parent,"LightPole",Vector3.new(.8,15,.8),CFrame.new(pos+Vector3.new(0,7.5,0)),Color3.fromRGB(32,34,39),Enum.Material.Metal)
 local bulb=part(parent,"Lamp",Vector3.new(2.4,.7,2.4),CFrame.new(pos+Vector3.new(0,15,0)),Color3.fromRGB(255,210,135),Enum.Material.Neon)
 local l=Instance.new("PointLight");l.Range=32;l.Brightness=1.7;l.Color=bulb.Color;l.Parent=bulb
end
local function tree(parent,pos)
 part(parent,"Trunk",Vector3.new(2,11,2),CFrame.new(pos+Vector3.new(0,5.5,0)),Color3.fromRGB(91,62,42),Enum.Material.Wood)
 local crown=part(parent,"Tree",Vector3.new(10,10,10),CFrame.new(pos+Vector3.new(0,13,0)),Color3.fromRGB(45,104,56),Enum.Material.Grass);crown.Shape=Enum.PartType.Ball
end
local function booth(parent,pos,label,color)
 part(parent,label.."Base",Vector3.new(25,1,17),CFrame.new(pos),Color3.fromRGB(64,58,54),Enum.Material.WoodPlanks)
 part(parent,label.."Back",Vector3.new(25,10,1),CFrame.new(pos+Vector3.new(0,5,-8)),Color3.fromRGB(38,39,44),Enum.Material.Metal)
 local roof=part(parent,label.."Roof",Vector3.new(28,1,20),CFrame.new(pos+Vector3.new(0,10,0)),color,Enum.Material.Fabric)
 textSign(parent,pos+Vector3.new(0,7.5,8.6),Vector3.new(18,3,.5),label)
end
local function truss(parent,pos,height)
 part(parent,"Truss",Vector3.new(2,height,2),CFrame.new(pos+Vector3.new(0,height/2,0)),Color3.fromRGB(55,57,62),Enum.Material.DiamondPlate)
end
function M.build(Config)
 local old=workspace:FindFirstChild("FestivalWorld");if old then old:Destroy() end
 Lighting.ClockTime=19.3;Lighting.Brightness=2;Lighting.Ambient=Color3.fromRGB(80,84,110);Lighting.OutdoorAmbient=Color3.fromRGB(92,95,120)
 local bloom=Lighting:FindFirstChild("FestivalBloom") or Instance.new("BloomEffect");bloom.Name="FestivalBloom";bloom.Intensity=.7;bloom.Size=30;bloom.Threshold=1.2;bloom.Parent=Lighting
 local atmosphere=Lighting:FindFirstChild("FestivalAtmosphere") or Instance.new("Atmosphere");atmosphere.Name="FestivalAtmosphere";atmosphere.Density=.22;atmosphere.Haze=1.2;atmosphere.Parent=Lighting
 local root=Instance.new("Folder");root.Name="FestivalWorld";root.Parent=workspace
 part(root,"Ground",Vector3.new(650,2,900),CFrame.new(0,-1,-100),Color3.fromRGB(42,86,48),Enum.Material.Grass)
 part(root,"Festival Avenue",Vector3.new(82,.6,650),CFrame.new(0,.1,-70),Color3.fromRGB(57,58,65),Enum.Material.Asphalt)
 part(root,"Mainstage Plaza",Vector3.new(330,.6,170),CFrame.new(0,.12,-430),Color3.fromRGB(49,50,57),Enum.Material.Concrete)
 -- entrance
 for _,x in ipairs({-43,43}) do truss(root,Vector3.new(x,0,250),32) end
 part(root,"EntranceTop",Vector3.new(88,3,3),CFrame.new(0,31,250),Color3.fromRGB(35,37,43),Enum.Material.Metal)
 textSign(root,Vector3.new(0,25,248.3),Vector3.new(65,10,1),"BUILD YOUR FESTIVAL")
 -- avenue dressing
 for z=-310,210,52 do
  lamp(root,Vector3.new(-49,0,z));lamp(root,Vector3.new(49,0,z))
  if z%104==0 then tree(root,Vector3.new(-61,0,z));tree(root,Vector3.new(61,0,z)) end
 end
 booth(root,Vector3.new(-78,.5,205),"FOOD",Color3.fromRGB(238,90,67))
 booth(root,Vector3.new(78,.5,205),"BAR",Color3.fromRGB(82,164,255))
 booth(root,Vector3.new(-78,.5,-280),"MERCH",Color3.fromRGB(178,91,255))
 booth(root,Vector3.new(78,.5,-280),"INFO",Color3.fromRGB(65,214,158))
 -- barriers / central decoration
 for z=-320,180,40 do
  for _,x in ipairs({-39,39}) do part(root,"Barrier",Vector3.new(1,3,16),CFrame.new(x,1.5,z),Color3.fromRGB(118,120,125),Enum.Material.Metal) end
 end
 local plots=Instance.new("Folder");plots.Name="Plots";plots.Parent=root
 for row=0,3 do for _,side in ipairs({-1,1}) do
  local i=row*2+(side==1 and 2 or 1);local model=Instance.new("Model");model.Name="Plot"..i;model:SetAttribute("Index",i);model.Parent=plots
  local z=135-row*115;local x=side*155
  local floor=part(model,"Floor",Vector3.new(135,.7,96),CFrame.new(x,.2,z),Color3.fromRGB(53,96,57),Enum.Material.Grass);model.PrimaryPart=floor
  -- subtle plot trim instead of colored blocks
  for _,dz in ipairs({-47,47}) do part(model,"Trim",Vector3.new(136,.35,1),CFrame.new(x,.55,z+dz),Color3.fromRGB(90,92,98),Enum.Material.Metal) end
  for _,dx in ipairs({-67,67}) do part(model,"Trim",Vector3.new(1,.35,95),CFrame.new(x+dx,.55,z),Color3.fromRGB(90,92,98),Enum.Material.Metal) end
  local sign=part(model,"OwnerSign",Vector3.new(27,7,1),CFrame.new(x-side*53,4,z+41),Color3.fromRGB(20,22,28),Enum.Material.Metal)
  local gui=Instance.new("BillboardGui");gui.Name="OwnerGui";gui.Size=UDim2.fromOffset(210,52);gui.StudsOffset=Vector3.new(0,4,0);gui.MaxDistance=55;gui.Parent=sign
  local txt=Instance.new("TextLabel");txt.Name="Text";txt.Size=UDim2.fromScale(1,1);txt.BackgroundTransparency=.15;txt.BackgroundColor3=Color3.fromRGB(18,20,26);txt.TextColor3=Color3.new(1,1,1);txt.Font=Enum.Font.GothamBold;txt.TextScaled=true;txt.Text="SLOT LIBRE";txt.Parent=gui
 end end
 -- huge mainstage
 local stage=Instance.new("Model");stage.Name="Mainstage";stage.Parent=root
 part(stage,"Deck",Vector3.new(230,8,60),CFrame.new(0,4,-505),Color3.fromRGB(18,19,24),Enum.Material.Metal)
 part(stage,"Back",Vector3.new(230,74,6),CFrame.new(0,38,-533),Color3.fromRGB(11,12,16),Enum.Material.Metal)
 part(stage,"Roof",Vector3.new(250,6,72),CFrame.new(0,77,-505),Color3.fromRGB(20,21,27),Enum.Material.Metal)
 for _,x in ipairs({-112,-75,75,112}) do truss(stage,Vector3.new(x,7,-500),68) end
 local screen=part(stage,"Screen",Vector3.new(105,42,1),CFrame.new(0,43,-529.5),Color3.fromRGB(88,53,210),Enum.Material.Neon)
 for _,x in ipairs({-83,83}) do part(stage,"SideScreen",Vector3.new(42,32,1),CFrame.new(x,41,-529),Color3.fromRGB(38,170,255),Enum.Material.Neon) end
 textSign(stage,Vector3.new(0,68,-529),Vector3.new(100,10,1),"MAINSTAGE")
 local sound=Instance.new("Sound");sound.Name="Music";sound.Volume=.65;sound.RollOffMaxDistance=440;sound.RollOffMinDistance=45;sound.Parent=screen
 local console=part(stage,"MusicConsole",Vector3.new(13,5,6),CFrame.new(0,3,-455),Color3.fromRGB(32,35,43),Enum.Material.Metal)
 local prompt=Instance.new("ProximityPrompt");prompt.ActionText="CHOISIR LA MUSIQUE";prompt.ObjectText="MAINSTAGE • ROBUX";prompt.MaxActivationDistance=12;prompt.RequiresLineOfSight=false;prompt.Parent=console
 -- FOH
 part(root,"FOH",Vector3.new(32,3,22),CFrame.new(0,1.5,-340),Color3.fromRGB(30,31,36),Enum.Material.Metal)
 textSign(root,Vector3.new(0,5,-328.5),Vector3.new(20,4,.5),"FOH")
 -- crowd markers
 local crowd=Instance.new("Folder");crowd.Name="Crowd";crowd.Parent=root
 for row=1,8 do for col=-7,7 do
  if math.abs(col)>1 or row>2 then
   local body=part(crowd,"FestivalGoer",Vector3.new(1.5,3.5,1.2),CFrame.new(col*10,1.75,-385-row*9),Color3.fromHSV(((row*15+col)%100)/100,.55,.9),Enum.Material.SmoothPlastic);body.CanCollide=false
   local head=part(crowd,"Head",Vector3.new(1.5,1.5,1.5),CFrame.new(col*10,4.2,-385-row*9),Color3.fromRGB(224,180,145));head.Shape=Enum.PartType.Ball;head.CanCollide=false
  end
 end end
 -- laser rig
 local fx=Instance.new("Folder");fx.Name="FX";fx.Parent=stage
 for i=1,28 do
  local x=-105+(i-1)*(210/27);local head=part(fx,"LaserHead",Vector3.new(1.2,1.2,1.2),CFrame.new(x,69,-495),Color3.fromHSV((i%8)/8,.85,1),Enum.Material.Neon)
  local target=part(fx,"LaserTarget",Vector3.new(.1,.1,.1),CFrame.new(x*1.25,4,-355-(i%4)*14),Color3.new());target.Transparency=1;target.CanCollide=false
  local a=Instance.new("Attachment");a.Parent=head;local b=Instance.new("Attachment");b.Parent=target
  local beam=Instance.new("Beam");beam.Attachment0=a;beam.Attachment1=b;beam.Width0=.4;beam.Width1=.08;beam.FaceCamera=true;beam.LightEmission=1;beam.Color=ColorSequence.new(head.Color);beam.Parent=head
 end
 local spawn=Instance.new("SpawnLocation");spawn.Name="FestivalSpawn";spawn.Size=Vector3.new(18,1,14);spawn.Position=Vector3.new(0,1,285);spawn.Anchored=true;spawn.Neutral=true;spawn.Parent=root
 return {root=root,plots=plots,stage=stage,screen=screen,sound=sound,console=console}
end
return M