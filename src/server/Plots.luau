local Players=game:GetService("Players")
local M={};local owners={}
local styles={
 Mainstage={label="MAIN STAGE",main=Color3.fromRGB(31,34,42),accent=Color3.fromRGB(116,88,235),secondary=Color3.fromRGB(55,205,225)},
 Cave={label="CAVE",main=Color3.fromRGB(20,22,25),accent=Color3.fromRGB(220,55,48),secondary=Color3.fromRGB(245,135,55)},
 Boiler={label="BOILER",main=Color3.fromRGB(38,39,43),accent=Color3.fromRGB(235,185,65),secondary=Color3.fromRGB(220,75,65)},
 Warehouse={label="WAREHOUSE",main=Color3.fromRGB(31,33,36),accent=Color3.fromRGB(210,220,225),secondary=Color3.fromRGB(95,150,255)},
 OpenAir={label="OPEN AIR",main=Color3.fromRGB(46,50,45),accent=Color3.fromRGB(255,174,62),secondary=Color3.fromRGB(105,215,160)},
 Hard={label="HARD STAGE",main=Color3.fromRGB(24,25,29),accent=Color3.fromRGB(235,45,58),secondary=Color3.fromRGB(245,245,245)},
 Beach={label="BEACH",main=Color3.fromRGB(54,65,67),accent=Color3.fromRGB(50,205,220),secondary=Color3.fromRGB(255,190,80)}
}
local palettes={
 Purple={Color3.fromRGB(116,88,235),Color3.fromRGB(55,205,225)},Red={Color3.fromRGB(235,55,65),Color3.fromRGB(255,145,55)},
 Green={Color3.fromRGB(65,210,135),Color3.fromRGB(245,205,70)},Blue={Color3.fromRGB(55,135,245),Color3.fromRGB(80,225,235)},
 Pink={Color3.fromRGB(235,75,180),Color3.fromRGB(135,90,245)},Mono={Color3.fromRGB(235,238,242),Color3.fromRGB(120,125,135)}
}
local festivalNames={NOVA=true,PULSE=true,ECLIPSE=true,RAVE=true,IMPACT=true,HORIZON=true,VOID=true,UNITY=true}
local decorModes={Clean=true,Industrial=true,Festive=true}
local function getPlot(world,i)return world.plots:FindFirstChild("Plot"..i)end
local function part(parent,name,size,pos,color,material)
 local x=Instance.new("Part");x.Name=name;x.Size=size;x.Position=pos;x.Anchored=true;x.Color=color;x.Material=material or Enum.Material.Metal;x.Parent=parent;return x
end
local function branchLevel(p,key)return p:GetAttribute(key.."Level") or 0 end
local function cost(Config,key,level)local b=Config.Branches[key];return math.floor(b.base*(b.growth^level))end
local function person(parent,pos,index)
 local m=Instance.new("Model");m.Name="FestivalGoer";m.Parent=parent
 local shirts={Color3.fromRGB(32,34,40),Color3.fromRGB(80,110,210),Color3.fromRGB(170,65,105),Color3.fromRGB(45,145,105),Color3.fromRGB(205,145,55)}
 local skins={Color3.fromRGB(241,205,170),Color3.fromRGB(190,135,95),Color3.fromRGB(112,76,58)}
 local shirt=shirts[index%#shirts+1];local skin=skins[index%#skins+1]
 local torso=part(m,"Torso",Vector3.new(1.7,2.3,.9),pos+Vector3.new(0,3,0),shirt,Enum.Material.SmoothPlastic);torso.CanCollide=false
 local head=part(m,"Head",Vector3.new(1.35,1.35,1.35),pos+Vector3.new(0,4.9,0),skin,Enum.Material.SmoothPlastic);head.Shape=Enum.PartType.Ball;head.CanCollide=false
 for _,x in ipairs({-.43,.43})do local leg=part(m,"Leg",Vector3.new(.58,2,.65),pos+Vector3.new(x,1.05,0),Color3.fromRGB(25,27,32));leg.CanCollide=false end
 for _,x in ipairs({-1.05,1.05})do local arm=part(m,"Arm",Vector3.new(.48,2,.48),pos+Vector3.new(x,3.05,0),skin);arm.CanCollide=false end
end
local function setShowLights(plot,enabled)
 local build=plot:FindFirstChild("PlayerBuild");if not build then return end
 for _,v in build:GetDescendants()do
  if v:IsA("SpotLight")or v:IsA("PointLight")or v:IsA("Beam")then v.Enabled=enabled end
  if v:IsA("BasePart")and(v.Name=="LightLens"or v.Name=="FloorLens")then v.Material=enabled and Enum.Material.Neon or Enum.Material.SmoothPlastic;v.Transparency=enabled and 0 or .25 end
 end
end
local function clearEventCrowd(plot)
 local old=plot:FindFirstChild("EventCrowd");if old then old:Destroy()end
end
local function spawnEventCrowd(plot,player)
 clearEventCrowd(plot)
 local folder=Instance.new("Folder");folder.Name="EventCrowd";folder.Parent=plot
 local pos=plot.Floor.Position;local side=pos.X>0 and 1 or -1
 local wanted=math.min(22,8+math.floor(branchLevel(player,"Crowd")*.8)+math.floor(branchLevel(player,"Marketing")*.5))
 local TweenService=game:GetService("TweenService")
 task.spawn(function()
  for i=1,wanted do
   if not player.Parent or not player:GetAttribute("EventActive") or not folder.Parent then break end
   local z=pos.Z-4+((i*17)%49);local start=Vector3.new(pos.X-side*82,.1,z)
   person(folder,start,i)
   local model=folder:GetChildren()[#folder:GetChildren()]
   local dx=((i*23)%65)-32;local dz=((i*31)%30)-4;local target=pos+Vector3.new(dx,.1,dz)
   if model and model:IsA("Model") then
    for _,v in model:GetChildren()do if v:IsA("BasePart")then
     local offset=v.Position-start;TweenService:Create(v,TweenInfo.new(1.8+(i%4)*.22,Enum.EasingStyle.Linear),{Position=target+offset}):Play()
    end end
   end
   task.wait(.28)
  end
 end)
end
local function flightCase(parent,pos)
 local body=part(parent,"ProFlightCase",Vector3.new(6,3.5,4.5),pos,Color3.fromRGB(24,25,28),Enum.Material.DiamondPlate)
 for _,x in ipairs({-2.85,2.85})do for _,y in ipairs({-1.5,1.5})do part(parent,"CaseCorner",Vector3.new(.3,.3,4.7),pos+Vector3.new(x,y,0),Color3.fromRGB(145,148,153),Enum.Material.Metal)end end
 for _,x in ipairs({-2.4,2.4})do for _,z in ipairs({-1.8,1.8})do local wheel=part(parent,"CaseWheel",Vector3.new(.65,.65,.45),pos+Vector3.new(x,-2,z),Color3.fromRGB(10,10,12),Enum.Material.SmoothPlastic);wheel.Shape=Enum.PartType.Ball end end
 return body
end
local function festivalBarrier(parent,pos)
 part(parent,"BarrierRail",Vector3.new(9,.35,.35),pos+Vector3.new(0,2.5,0),Color3.fromRGB(150,153,158),Enum.Material.Metal)
 for _,x in ipairs({-4.2,4.2})do part(parent,"BarrierPost",Vector3.new(.35,5,.35),pos+Vector3.new(x,1.2,0),Color3.fromRGB(150,153,158),Enum.Material.Metal);part(parent,"BarrierFoot",Vector3.new(1.6,.25,2),pos+Vector3.new(x,-1.2,0),Color3.fromRGB(95,98,104),Enum.Material.Metal)end
 for x=-3.3,3.3,1.1 do part(parent,"BarrierBar",Vector3.new(.14,4.2,.14),pos+Vector3.new(x,1.2,0),Color3.fromRGB(115,118,123),Enum.Material.Metal)end
end
local function buildStage(plot,player)
 local old=plot:FindFirstChild("PlayerBuild");if old then old:Destroy()end
 local f=Instance.new("Folder");f.Name="PlayerBuild";f.Parent=plot
 local styleKey=player:GetAttribute("StageStyle")or"Mainstage";local baseStyle=styles[styleKey]or styles.Mainstage
 local palette=palettes[player:GetAttribute("FestivalPalette")or"Purple"];local s={main=baseStyle.main,accent=palette and palette[1]or baseStyle.accent,secondary=palette and palette[2]or baseStyle.secondary};local pos=plot.Floor.Position
 local stage=branchLevel(player,"Stage");local sound=branchLevel(player,"Sound");local lights=branchLevel(player,"Lights");local fx=branchLevel(player,"FX");local crowd=branchLevel(player,"Crowd");local stands=branchLevel(player,"Stands")
 local tier=math.floor(stage/5);local prestige=player:GetAttribute("Prestige")or 0
 local function sign(text,offset,size)
  local board=part(f,"Sign",size or Vector3.new(24,4,.6),pos+offset,Color3.fromRGB(20,23,29),Enum.Material.Metal)
  local g=Instance.new("SurfaceGui");g.Face=Enum.NormalId.Front;g.Parent=board
  local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextColor3=Color3.new(1,1,1);t.Font=Enum.Font.GothamBold;t.TextSize=22;t.TextWrapped=false;t.TextXAlignment=Enum.TextXAlignment.Center;t.TextYAlignment=Enum.TextYAlignment.Center;t.Parent=g;local pad=Instance.new("UIPadding");pad.PaddingLeft=UDim.new(0,8);pad.PaddingRight=UDim.new(0,8);pad.Parent=t
 end

 -- The slot starts almost empty: one DJ table, decks and a cable case.
 local booth=part(f,"DJTable",Vector3.new(12,4,4.5),pos+Vector3.new(0,2,-27),Color3.fromRGB(28,30,35),Enum.Material.Metal)
 local deck=part(f,"DJDeck",Vector3.new(9,.8,3),pos+Vector3.new(0,4.4,-26.5),Color3.fromRGB(12,13,16),Enum.Material.SmoothPlastic)
 for _,x in ipairs({-2.7,2.7})do local jog=part(f,"JogWheel",Vector3.new(2,.3,2),pos+Vector3.new(x,4.95,-26.5),Color3.fromRGB(70,72,78),Enum.Material.Metal);jog.Shape=Enum.PartType.Cylinder;jog.Orientation=Vector3.new(0,0,90)end
 flightCase(f,pos+Vector3.new(10,2,-27))
 sign("DJ",Vector3.new(0,7,-29),Vector3.new(10,2.5,.5))
 local deckPrompt=Instance.new("ProximityPrompt");deckPrompt.ActionText="PRENDRE LES PLATINES";deckPrompt.ObjectText="PLATINES DJ";deckPrompt.RequiresLineOfSight=false;deckPrompt.MaxActivationDistance=10;deckPrompt.Parent=deck
 deckPrompt.Triggered:Connect(function(pp)
  if pp~=player then return end
  if not pp:GetAttribute("EventActive") then return end
  local remote=game:GetService("ReplicatedStorage"):FindFirstChild("FestivalUpgrade");if remote then remote:FireClient(pp,"DJ_OPEN")end
 end)

 -- Stage branch constructs a real venue around the original booth.
 if stage>=1 then part(f,"StageDeck",Vector3.new(38,2,22),pos+Vector3.new(0,1,-29),Color3.fromRGB(35,37,42),Enum.Material.Metal)end
 if stage>=2 then
  for n=1,3 do part(f,"Step",Vector3.new(14+n*5,.55,2.8),pos+Vector3.new(0,.3+n*.3,-15-n*2.5),Color3.fromRGB(62,64,70),Enum.Material.Metal)end
  part(f,"FrontApron",Vector3.new(46,1.2,6),pos+Vector3.new(0,1.2,-15),Color3.fromRGB(25,27,32),Enum.Material.Metal)
 end
 if stage>=3 then for _,x in ipairs({-25,25})do part(f,"StageWing",Vector3.new(10,10,22),pos+Vector3.new(x,5,-29),Color3.fromRGB(30,32,37),Enum.Material.Metal)end end
 if stage>=4 then
  for _,x in ipairs({-30,30})do for _,z in ipairs({-39,-19})do part(f,"VerticalTruss",Vector3.new(2,24,2),pos+Vector3.new(x,12,z),Color3.fromRGB(88,90,96),Enum.Material.DiamondPlate)end end
  part(f,"TopTruss",Vector3.new(62,2,2),pos+Vector3.new(0,24,-39),Color3.fromRGB(88,90,96),Enum.Material.DiamondPlate)
 end
 if stage>=5 then part(f,"Roof",Vector3.new(70,3,30),pos+Vector3.new(0,26,-29),Color3.fromRGB(22,24,29),Enum.Material.Metal)end
 if stage>=7 then
  local frame=part(f,"ScreenFrame",Vector3.new(40,16,2),pos+Vector3.new(0,14,-40),Color3.fromRGB(15,17,21),Enum.Material.Metal)
  part(f,"StageScreen",Vector3.new(35,11,.5),pos+Vector3.new(0,14,-38.9),Color3.fromRGB(38,55,75),Enum.Material.SmoothPlastic)
 end
 if stage>=10 then for _,x in ipairs({-40,40})do part(f,"OuterTower",Vector3.new(4,31,4),pos+Vector3.new(x,15.5,-29),Color3.fromRGB(52,55,61),Enum.Material.DiamondPlate)end end
 if stage>=15 then part(f,"MegaRoof",Vector3.new(96,4,38),pos+Vector3.new(0,34,-29),Color3.fromRGB(18,20,25),Enum.Material.Metal)end
 if stage>=20 then for _,x in ipairs({-48,48})do part(f,"SideScreen",Vector3.new(15,20,2),pos+Vector3.new(x,18,-34),Color3.fromRGB(28,42,58),Enum.Material.SmoothPlastic)end end
 if stage>=25 then part(f,"FestivalCrown",Vector3.new(105,5,5),pos+Vector3.new(0,40,-31),s.accent,Enum.Material.SmoothPlastic)end
 if stage>=30 then
  for _,x in ipairs({-56,56})do part(f,"MegaPylon",Vector3.new(5,44,5),pos+Vector3.new(x,22,-31),Color3.fromRGB(42,45,52),Enum.Material.DiamondPlate);part(f,"PylonAccent",Vector3.new(6,3,6),pos+Vector3.new(x,43,-31),s.secondary,Enum.Material.Neon)end
 end
 if stage>=35 then
  part(f,"SkylineHeader",Vector3.new(118,5,6),pos+Vector3.new(0,47,-31),Color3.fromRGB(18,20,25),Enum.Material.Metal)
  for _,x in ipairs({-42,-21,0,21,42})do part(f,"HeaderPixel",Vector3.new(12,2,.8),pos+Vector3.new(x,47,-27.6),x%42==0 and s.accent or s.secondary,Enum.Material.Neon)end
 end
 if stage>=40 then
  part(f,"FinalCrown",Vector3.new(128,3,4),pos+Vector3.new(0,53,-31),s.accent,Enum.Material.Neon)
  for _,x in ipairs({-60,-30,0,30,60})do part(f,"FinalSpire",Vector3.new(2,12,2),pos+Vector3.new(x,58,-31),Color3.fromRGB(72,75,84),Enum.Material.DiamondPlate)end
  sign((player:GetAttribute("FestivalName")or"NOVA").." • HEADLINER",Vector3.new(0,51,-27),Vector3.new(38,4,.7))
 end
 -- Venue archetypes change the architecture, not only its colour.
 if styleKey=="Cave" then
  if stage>=1 then
   part(f,"CaveBack",Vector3.new(54,16,4),pos+Vector3.new(0,8,-42),Color3.fromRGB(18,19,21),Enum.Material.Concrete)
   for _,x in ipairs({-29,29})do part(f,"CaveWall",Vector3.new(6,18,30),pos+Vector3.new(x,9,-29),Color3.fromRGB(24,25,27),Enum.Material.Concrete)end
  end
  if stage>=4 then
   part(f,"CaveCeiling",Vector3.new(64,4,34),pos+Vector3.new(0,19,-29),Color3.fromRGB(17,18,20),Enum.Material.Concrete)
   for x=-24,24,12 do part(f,"CavePipe",Vector3.new(2,2,31),pos+Vector3.new(x,16,-28),Color3.fromRGB(65,67,70),Enum.Material.Metal)end
  end
  if stage>=7 then sign("UNDERGROUND",Vector3.new(0,13,-39),Vector3.new(28,4,.6))end
 elseif styleKey=="Boiler" then
  if stage>=1 then
   part(f,"BoilerPlatform",Vector3.new(30,2,18),pos+Vector3.new(0,1,-25),Color3.fromRGB(50,51,55),Enum.Material.DiamondPlate)
   -- crowd surrounds the booth: boiler-room feeling.
   for _,z in ipairs({-39,-11})do part(f,"BoilerRail",Vector3.new(58,2,1),pos+Vector3.new(0,1,z),Color3.fromRGB(105,108,112),Enum.Material.Metal)end
  end
  if stage>=4 then
   for _,x in ipairs({-34,34})do part(f,"BoilerTower",Vector3.new(3,20,3),pos+Vector3.new(x,10,-25),Color3.fromRGB(73,75,80),Enum.Material.DiamondPlate)end
   part(f,"BoilerTruss",Vector3.new(70,3,3),pos+Vector3.new(0,20,-25),Color3.fromRGB(73,75,80),Enum.Material.DiamondPlate)
  end
  if stage>=7 then sign("360° BOOTH",Vector3.new(0,9,-37),Vector3.new(24,3,.6))end
 elseif styleKey=="Warehouse" then
  if stage>=1 then
   part(f,"WarehouseBack",Vector3.new(76,22,3),pos+Vector3.new(0,11,-43),Color3.fromRGB(42,43,46),Enum.Material.Brick)
   for _,x in ipairs({-38,38})do part(f,"WarehouseWall",Vector3.new(3,22,38),pos+Vector3.new(x,11,-27),Color3.fromRGB(45,46,49),Enum.Material.Brick)end
  end
  if stage>=4 then
   for x=-30,30,15 do part(f,"WarehouseRafter",Vector3.new(2,2,38),pos+Vector3.new(x,21,-27),Color3.fromRGB(78,80,84),Enum.Material.Metal)end
   part(f,"WarehouseRoof",Vector3.new(80,3,40),pos+Vector3.new(0,23,-27),Color3.fromRGB(28,29,32),Enum.Material.Metal)
  end
  if stage>=7 then sign("WAREHOUSE",Vector3.new(0,14,-41),Vector3.new(28,4,.6))end
 elseif styleKey=="OpenAir" then
  if stage>=1 then for _,x in ipairs({-32,32})do part(f,"OpenMast",Vector3.new(2,20,2),pos+Vector3.new(x,10,-29),Color3.fromRGB(95,98,94),Enum.Material.Metal)end end
  if stage>=4 then
   local canopy=part(f,"OpenCanopy",Vector3.new(72,2,30),pos+Vector3.new(0,24,-29),Color3.fromRGB(72,76,69),Enum.Material.Fabric);canopy.Transparency=.08
   for _,x in ipairs({-42,42})do for _,z in ipairs({-40,-18})do part(f,"OpenPole",Vector3.new(1.2,24,1.2),pos+Vector3.new(x,12,z),Color3.fromRGB(80,83,78),Enum.Material.Metal)end end
  end
  if stage>=7 then for _,x in ipairs({-48,48})do part(f,"OpenBanner",Vector3.new(8,18,.4),pos+Vector3.new(x,11,-25),x<0 and s.accent or s.secondary,Enum.Material.Fabric)end end
 elseif styleKey=="Hard" then
  if stage>=1 then for _,x in ipairs({-31,31})do part(f,"HardPillar",Vector3.new(9,20,12),pos+Vector3.new(x,10,-34),Color3.fromRGB(25,26,30),Enum.Material.Concrete)end end
  if stage>=4 then
   for _,x in ipairs({-42,-22,22,42})do local blade=part(f,"HardBlade",Vector3.new(7,30,5),pos+Vector3.new(x,17,-38),Color3.fromRGB(32,33,38),Enum.Material.Metal);blade.Orientation=Vector3.new(0,0,x<0 and -12 or 12)end
   part(f,"HardHeader",Vector3.new(88,7,6),pos+Vector3.new(0,31,-38),Color3.fromRGB(20,21,25),Enum.Material.Metal)
  end
  if stage>=7 then sign("HARD STAGE",Vector3.new(0,24,-34),Vector3.new(32,5,.8))end
 elseif styleKey=="Beach" then
  if stage>=1 then
   local sand=part(f,"BeachDeck",Vector3.new(105,.3,62),pos+Vector3.new(0,.72,8),Color3.fromRGB(194,165,112),Enum.Material.Sand);sand.CanCollide=false
   for _,x in ipairs({-34,34})do part(f,"PalmPole",Vector3.new(2,16,2),pos+Vector3.new(x,8,-24),Color3.fromRGB(104,73,47),Enum.Material.Wood)end
  end
  if stage>=4 then part(f,"BeachCanopy",Vector3.new(66,2,28),pos+Vector3.new(0,22,-29),Color3.fromRGB(235,226,194),Enum.Material.Fabric)end
  if stage>=7 then for _,x in ipairs({-45,45})do part(f,"BeachSail",Vector3.new(10,14,.5),pos+Vector3.new(x,9,-18),x<0 and s.accent or s.secondary,Enum.Material.Fabric)end end
 end

 -- Sound grows from tiny pole speakers into a proper festival PA.
 if sound>=1 then
  for _,x in ipairs({-13,13})do
   part(f,"SpeakerPole",Vector3.new(.7,6,.7),pos+Vector3.new(x,3,-17),Color3.fromRGB(65,67,72),Enum.Material.Metal)
   local top=part(f,"SpeakerTop",Vector3.new(4.2,5,3.2),pos+Vector3.new(x,7,-17),Color3.fromRGB(15,16,19),Enum.Material.SmoothPlastic)
   local cone=part(f,"SpeakerCone",Vector3.new(2.4,2.4,.25),pos+Vector3.new(x,7,-15.35),Color3.fromRGB(48,50,55),Enum.Material.Metal);cone.Shape=Enum.PartType.Cylinder;cone.Orientation=Vector3.new(90,0,0)
  end
 end
 if sound>=2 then for _,x in ipairs({-13,13})do part(f,"Sub",Vector3.new(6.5,4.5,5),pos+Vector3.new(x,2.25,-18),Color3.fromRGB(11,12,15),Enum.Material.SmoothPlastic)end end
 if sound>=4 then for _,x in ipairs({-23,23})do
  part(f,"PAStand",Vector3.new(1,12,1),pos+Vector3.new(x,6,-20),Color3.fromRGB(70,72,78),Enum.Material.Metal)
  for y=7,13,3 do part(f,"PACabinet",Vector3.new(5.5,2.5,3.5),pos+Vector3.new(x,y,-19),Color3.fromRGB(12,13,16),Enum.Material.SmoothPlastic)end
 end end
 if sound>=8 then for _,x in ipairs({-31,31})do for y=11,23,3 do
  local cab=part(f,"LineArray",Vector3.new(6,2.4,3.5),pos+Vector3.new(x,y,-24),Color3.fromRGB(9,10,13),Enum.Material.SmoothPlastic);cab.Orientation=Vector3.new(math.min((y-11)*1.3,12),0,0)
 end end end
 if sound>=12 then for _,x in ipairs({-25,-17,-9,9,17,25})do part(f,"SubArray",Vector3.new(7,5.5,6),pos+Vector3.new(x,2.75,-14),Color3.fromRGB(8,9,11),Enum.Material.SmoothPlastic)end end

 -- Lighting has obvious tiers: floor lights -> wash rig -> moving heads -> arena rig.
 if lights>0 then
  local count=math.min(4+lights,12)
  for i=1,count do
   local x=-27+(i-1)*(54/math.max(1,count-1));local y=stage>=5 and 23 or 9
   local lamp=part(f,"StageLight",Vector3.new(1.5,1.5,2),pos+Vector3.new(x,y,-18),Color3.fromRGB(35,37,43),Enum.Material.Metal)
   local col=(i%2==0 and s.accent or s.secondary)
   local lens=part(f,"LightLens",Vector3.new(1.05,1.05,.18),pos+Vector3.new(x,y,-16.92),col,Enum.Material.Neon);lens.CanCollide=false
   local sp=Instance.new("SpotLight");sp.Range=55+lights*2;sp.Angle=42;sp.Brightness=2+math.min(lights,12)*.12;sp.Color=col;sp.Face=Enum.NormalId.Front;sp.Shadows=false;sp.Parent=lens
   local target=part(f,"LightTarget",Vector3.new(.1,.1,.1),pos+Vector3.new(x*1.25,1,16+(i%3)*7),col);target.Transparency=1;target.CanCollide=false
   local aa=Instance.new("Attachment");aa.Parent=lens;local bb=Instance.new("Attachment");bb.Parent=target
   local beam=Instance.new("Beam");beam.Attachment0=aa;beam.Attachment1=bb;beam.Width0=.25;beam.Width1=2.4;beam.Transparency=NumberSequence.new(.18,.88);beam.Color=ColorSequence.new(col);beam.LightEmission=1;beam.FaceCamera=true;beam.Parent=lens
  end
 end
 if lights>=3 then for _,x in ipairs({-22,0,22})do
  local floorLamp=part(f,"FloorWash",Vector3.new(2,1.2,2),pos+Vector3.new(x,1,-13),Color3.fromRGB(28,30,36),Enum.Material.Metal)
  local lens=part(f,"FloorLens",Vector3.new(1.3,.18,1.3),pos+Vector3.new(x,1.65,-13),s.accent,Enum.Material.Neon);lens.CanCollide=false;local sp=Instance.new("PointLight");sp.Range=28;sp.Brightness=1.5;sp.Color=s.accent;sp.Parent=lens
 end end
 if lights>=6 and stage>=4 then
  for i=1,6 do
   local x=-25+(i-1)*10;local head=part(f,"MovingHead",Vector3.new(2,2,2),pos+Vector3.new(x,22,-37),Color3.fromRGB(25,27,32),Enum.Material.Metal)
   local target=part(f,"LightTarget",Vector3.new(.1,.1,.1),pos+Vector3.new(x*1.8,2,18+(i%2)*14),s.accent);target.Transparency=1;target.CanCollide=false
   local aa=Instance.new("Attachment");aa.Parent=head;local bb=Instance.new("Attachment");bb.Parent=target
   local beam=Instance.new("Beam");beam.Attachment0=aa;beam.Attachment1=bb;beam.Width0=.16;beam.Width1=.7;beam.Transparency=NumberSequence.new(.35,.82);beam.Color=ColorSequence.new(i%2==0 and s.accent or s.secondary);beam.LightEmission=.65;beam.FaceCamera=true;beam.Parent=head
  end
 end
 if lights>=12 and stage>=5 then
  for _,x in ipairs({-35,35})do
   local tower=part(f,"LightTower",Vector3.new(2,28,2),pos+Vector3.new(x,14,-24),Color3.fromRGB(70,72,78),Enum.Material.DiamondPlate)
   local wash=Instance.new("PointLight");wash.Range=48;wash.Brightness=1.5;wash.Color=s.secondary;wash.Parent=tower
  end
 end
 if fx>=5 and stage>=5 then
  for i=1,math.min(4,math.floor(fx/5))do local x=-24+(i-1)*16;local head=part(f,"FXHead",Vector3.new(1.2,1.2,1.2),pos+Vector3.new(x,23,-20),Color3.fromRGB(30,32,38),Enum.Material.Metal);local a=Instance.new("Attachment");a.Parent=head;local target=part(f,"FXTarget",Vector3.new(.1,.1,.1),pos+Vector3.new(x*1.4,3,20),s.accent);target.Transparency=1;target.CanCollide=false;local b=Instance.new("Attachment");b.Parent=target;local beam=Instance.new("Beam");beam.Attachment0=a;beam.Attachment1=b;beam.Width0=.06;beam.Width1=.015;beam.Color=ColorSequence.new(s.accent);beam.LightEmission=.6;beam.FaceCamera=true;beam.Enabled=false;beam.Parent=head end
 end

 -- Grounds stay readable and functional, without glowing blocks.
 if crowd>=1 then
  local visible=math.min(36,4+crowd*3)
  for i=1,visible do local col=((i-1)%8)-3.5;local row=math.floor((i-1)/8);person(f,pos+Vector3.new(col*7+((i%3)-1)*.8,.1,3+row*8),i)end
 end
 if crowd>=1 then part(f,"DanceFloor",Vector3.new(100,.16,42),pos+Vector3.new(0,.61,13),Color3.fromRGB(45,47,52),Enum.Material.Slate).CanCollide=false end
 if crowd>=4 then for _,x in ipairs({-42,42})do for z=-2,28,10 do festivalBarrier(f,pos+Vector3.new(x,1.3,z))end end end
 if crowd>=8 then for _,x in ipairs({-31,31})do part(f,"EntryPost",Vector3.new(2,12,2),pos+Vector3.new(x,6,48),Color3.fromRGB(50,52,58),Enum.Material.Metal)end;part(f,"EntryArch",Vector3.new(64,2,2),pos+Vector3.new(0,12,48),Color3.fromRGB(50,52,58),Enum.Material.Metal);sign("ENTREE FESTIVAL",Vector3.new(0,10.5,47.2),Vector3.new(28,3,.5))end
 if stands>=1 then
  local names={"BAR","FOOD","MERCH","VIP","TOKENS","INFO"}
  for i=1,math.min(stands,6)do
   local side=i%2==0 and 1 or -1;local row=math.ceil(i/2);local base=pos+Vector3.new(side*67,0,30-row*16)
   part(f,"KioskFloor",Vector3.new(17,.6,11),base+Vector3.new(0,.3,0),Color3.fromRGB(58,54,50),Enum.Material.WoodPlanks)
   part(f,"KioskBack",Vector3.new(17,7,.7),base+Vector3.new(0,3.5,-5),Color3.fromRGB(38,40,46),Enum.Material.Metal)
   part(f,"Counter",Vector3.new(17,3,2),base+Vector3.new(0,1.5,4),Color3.fromRGB(68,70,76),Enum.Material.Metal)
   part(f,"Awning",Vector3.new(19,.7,12),base+Vector3.new(0,7,0),i%2==0 and s.accent or s.secondary,Enum.Material.Fabric)
   sign(names[i]or"STAND",base-pos+Vector3.new(0,5.5,4.7),Vector3.new(11,2.3,.45))
  end
 end
 if branchLevel(player,"Staff")>=5 then for _,x in ipairs({-70,70})do part(f,"StaffTent",Vector3.new(16,7,12),pos+Vector3.new(x,3.5,-5),Color3.fromRGB(38,40,45),Enum.Material.Fabric)end end
 local marketing=branchLevel(player,"Marketing");local staff=branchLevel(player,"Staff")
 if stage>=2 or lights>=2 then
  for i=0,10 do local t=i/10;local x=-42+t*84;local bulb=part(f,"PlotFestoon",Vector3.new(.4,.4,.4),pos+Vector3.new(x,12-math.sin(t*math.pi)*2,36),Color3.fromRGB(255,198,125),Enum.Material.Neon);bulb.Shape=Enum.PartType.Ball;bulb.CanCollide=false end
 end
 if (player:GetAttribute("DecorMode")or"Festive")=="Industrial" and stage>=2 then
  for _,x in ipairs({-56,56})do part(f,"IndustrialTotem",Vector3.new(3,15,3),pos+Vector3.new(x,7.5,30),Color3.fromRGB(54,57,62),Enum.Material.DiamondPlate)end
 elseif (player:GetAttribute("DecorMode")or"Festive")=="Clean" and stage>=2 then
  for _,x in ipairs({-54,54})do part(f,"CleanTotem",Vector3.new(2,10,2),pos+Vector3.new(x,5,32),s.accent,Enum.Material.SmoothPlastic)end
 end
 if crowd>=3 then
  for _,x in ipairs({-52,52})do local pole=part(f,"FestivalFlagPole",Vector3.new(.35,12,.35),pos+Vector3.new(x,6,35),Color3.fromRGB(72,74,80),Enum.Material.Metal);local flag=part(f,"FestivalFlag",Vector3.new(4,2.6,.18),pos+Vector3.new(x+(x<0 and 2 or -2),10.5,35),x<0 and s.accent or s.secondary,Enum.Material.Fabric);flag.CanCollide=false end
 end
 if marketing>=1 then sign(player:GetAttribute("FestivalName")or"NOVA",Vector3.new(0,5,45),Vector3.new(30,4,.6))end
 if marketing>=4 then for _,x in ipairs({-48,48})do part(f,"BannerPole",Vector3.new(1,12,1),pos+Vector3.new(x,6,43),Color3.fromRGB(55,57,62),Enum.Material.Metal);part(f,"Banner",Vector3.new(7,8,.35),pos+Vector3.new(x,8,42.4),s.accent,Enum.Material.Fabric)end end
 if marketing>=8 then part(f,"FestivalGateway",Vector3.new(86,3,3),pos+Vector3.new(0,17,47),Color3.fromRGB(42,44,50),Enum.Material.Metal);for _,x in ipairs({-41,41})do part(f,"GatewayPost",Vector3.new(3,18,3),pos+Vector3.new(x,9,47),Color3.fromRGB(42,44,50),Enum.Material.Metal)end;sign("WELCOME",Vector3.new(0,15.2,46.2),Vector3.new(28,4,.6))end
 if staff>=1 then part(f,"CrewDesk",Vector3.new(12,4,6),pos+Vector3.new(-68,2,37),Color3.fromRGB(35,38,44),Enum.Material.Metal);sign("CREW",Vector3.new(-68,6,34),Vector3.new(10,2.5,.5))end
 if staff>=4 then part(f,"SecurityCabin",Vector3.new(14,8,10),pos+Vector3.new(68,4,38),Color3.fromRGB(40,43,48),Enum.Material.Metal);sign("SECURITE",Vector3.new(68,7.5,32.7),Vector3.new(11,2.3,.5))end
 if prestige>0 then local mon=part(f,"RebirthMonument",Vector3.new(4,8+math.min(prestige,10),4),pos+Vector3.new(0,4,42),s.accent,Enum.Material.SmoothPlastic);local light=Instance.new("PointLight");light.Brightness=.25;light.Range=10;light.Color=s.accent;light.Parent=mon end
end
function M.assign(player,world,Config)
 if player:GetAttribute("PlotIndex")then return end
 for i=1,Config.PlotCount do if not owners[i]then
  owners[i]=player;player:SetAttribute("PlotIndex",i);player:SetAttribute("Cash",Config.StartCash);player:SetAttribute("Fans",0);player:SetAttribute("StageStyle","Mainstage")
  player:SetAttribute("FestivalPalette","Purple");player:SetAttribute("FestivalName","NOVA");player:SetAttribute("DecorMode","Festive");player:SetAttribute("Prestige",0);player:SetAttribute("RebirthTokens",0);player:SetAttribute("DJCombo",0);player:SetAttribute("TutorialStep",1);player:SetAttribute("EventActive",false);player:SetAttribute("EventHype",0);player:SetAttribute("EventTime",0);player:SetAttribute("LastEventPayout",0);player:SetAttribute("LastEventFans",0);player:SetAttribute("ActivityScore",0);player:SetAttribute("LastActivity",0)
  for key in pairs(Config.Branches)do player:SetAttribute(key.."Level",0)end
  local plot=getPlot(world,i);do
   local ownerSign=plot:FindFirstChild("OwnerSign")
   local ownerGui=ownerSign and ownerSign:FindFirstChild("OwnerGui")
   if ownerGui then
    local oldText=ownerGui:FindFirstChild("Text");if oldText then oldText.Visible=false end
    local card=ownerGui:FindFirstChild("PlayerCard") or Instance.new("Frame");card.Name="PlayerCard";card.Size=UDim2.fromScale(1,1);card.BackgroundColor3=Color3.fromRGB(16,18,24);card.BackgroundTransparency=.06;card.BorderSizePixel=0;card.Parent=ownerGui
    local avatar=card:FindFirstChild("Avatar") or Instance.new("ImageLabel");avatar.Name="Avatar";avatar.Size=UDim2.fromOffset(48,48);avatar.Position=UDim2.fromOffset(3,2);avatar.BackgroundTransparency=1;avatar.Parent=card
    local name=card:FindFirstChild("Name") or Instance.new("TextLabel");name.Name="Name";name.Position=UDim2.fromOffset(57,2);name.Size=UDim2.new(1,-60,1,-4);name.BackgroundTransparency=1;name.TextColor3=Color3.new(1,1,1);name.Font=Enum.Font.GothamBold;name.TextScaled=true;name.TextXAlignment=Enum.TextXAlignment.Left;name.Parent=card
    name.Text=player.DisplayName
    task.spawn(function()
     local ok,img=pcall(function()return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180)end)
     if ok and avatar.Parent then avatar.Image=img end
    end)
   end
  end;buildStage(plot,player)
  -- Upgrades are UI-driven: keep the physical festival clean and readable.
  local upgradeRemote=game:GetService("ReplicatedStorage"):FindFirstChild("FestivalUpgrade")
  if not upgradeRemote then upgradeRemote=Instance.new("RemoteEvent");upgradeRemote.Name="FestivalUpgrade";upgradeRemote.Parent=game:GetService("ReplicatedStorage") end
  if not upgradeRemote:GetAttribute("ServerBound") then
   upgradeRemote:SetAttribute("ServerBound",true)
   upgradeRemote.OnServerEvent:Connect(function(pp,action,key,value)
    if action=="DJ_HIT" then
     if not pp:GetAttribute("EventActive") then return end
     local rating=tonumber(key)or 0;rating=math.clamp(rating,0,3)
     pp:SetAttribute("EventHype",math.min(100,(pp:GetAttribute("EventHype")or 0)+({0,3,7,12})[rating+1]))
     if rating>=2 then pp:SetAttribute("DJCombo",(pp:GetAttribute("DJCombo")or 0)+1) else pp:SetAttribute("DJCombo",0) end
    elseif action=="ACTIVITY" then
     if not pp:GetAttribute("EventActive")then return end
     local now=os.clock();local last=pp:GetAttribute("LastActivity")or 0;if now-last<4 then return end;pp:SetAttribute("LastActivity",now)
     local bonus=key=="CROWD"and 4 or(key=="FX"and 5 or(key=="SERVICE"and 3 or 0));if bonus<=0 then return end
     pp:SetAttribute("EventHype",math.min(100,(pp:GetAttribute("EventHype")or 0)+bonus))
     pp:SetAttribute("ActivityScore",(pp:GetAttribute("ActivityScore")or 0)+1)
    elseif action=="START_EVENT" then
     if pp:GetAttribute("EventActive") then return end
     local tutorial=pp:GetAttribute("TutorialStep")or 1;if tutorial==1 then pp:SetAttribute("TutorialStep",2) elseif tutorial==4 then pp:SetAttribute("TutorialStep",5) end;local eventLength=45+math.min(45,math.floor((branchLevel(pp,"Stage")+branchLevel(pp,"Crowd"))/8)*5);pp:SetAttribute("EventActive",true);pp:SetAttribute("EventHype",45);pp:SetAttribute("EventTime",eventLength);pp:SetAttribute("EventVisitors",math.max(8,12+branchLevel(pp,"Crowd")*3+branchLevel(pp,"Marketing")*2));local pi=pp:GetAttribute("PlotIndex");local eventPlot=pi and getPlot(world,pi);if eventPlot then spawnEventCrowd(eventPlot,pp);setShowLights(eventPlot,true)end
     task.spawn(function()
      for remaining=(pp:GetAttribute("EventTime")or 45),1,-1 do
       if not pp.Parent then return end
       pp:SetAttribute("EventTime",remaining)
       local hype=pp:GetAttribute("EventHype")or 0
       local crowdLv=branchLevel(pp,"Crowd");local marketing=branchLevel(pp,"Marketing")
       local quality=branchLevel(pp,"Stage")+branchLevel(pp,"Sound")+branchLevel(pp,"Lights");local floor=math.min(78,42+math.floor(quality/4));pp:SetAttribute("EventHype",math.clamp(math.max(floor,hype-(remaining%6==0 and 1 or 0)),0,100))
       task.wait(1)
      end
      local hype=pp:GetAttribute("EventHype")or 0;local crowdLv=branchLevel(pp,"Crowd");local standsLv=branchLevel(pp,"Stands")
      local stageLv=branchLevel(pp,"Stage");local soundLv=branchLevel(pp,"Sound");local marketingLv=branchLevel(pp,"Marketing");local staffLv=branchLevel(pp,"Staff");local baseEvent=190+stageLv*20+soundLv*15+crowdLv*17+standsLv*28+marketingLv*18+staffLv*12;local prestige=pp:GetAttribute("Prestige")or 0;local tokens=pp:GetAttribute("RebirthTokens")or 0;local permanent=1+prestige*.20+tokens*.04;local payout=math.floor(baseEvent*(.9+hype/500)*permanent);local gainedFans=math.floor(12+crowdLv*3+marketingLv*3+hype*.12)
      pp:SetAttribute("Cash",(pp:GetAttribute("Cash")or 0)+payout);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+gainedFans);pp:SetAttribute("LastEventPayout",payout);pp:SetAttribute("LastEventFans",gainedFans);pp:SetAttribute("EventActive",false);pp:SetAttribute("EventTime",0);pp:SetAttribute("EventVisitors",0);if eventPlot then clearEventCrowd(eventPlot);setShowLights(eventPlot,false)end
     end)
    elseif action=="BUY" and Config.Branches[key] then
     if pp:GetAttribute("EventActive") then return end
     local lv=branchLevel(pp,key);local branch=Config.Branches[key];if lv>=branch.max then return end
     local price=cost(Config,key,lv);local cash=pp:GetAttribute("Cash")or 0;if cash<price then return end
     pp:SetAttribute("Cash",cash-price);pp:SetAttribute(key.."Level",lv+1);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+10+(lv+1)*5)
     local ts=pp:GetAttribute("TutorialStep")or 1
     if ts==2 and key=="Stage" then pp:SetAttribute("TutorialStep",3) elseif ts==3 and key=="Crowd" then pp:SetAttribute("TutorialStep",4) end
     local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp) end
    elseif action=="STYLE" and styles[key] then if pp:GetAttribute("EventActive")then return end;pp:SetAttribute("StageStyle",key);local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp) end
    elseif action=="CUSTOMIZE" then
     if pp:GetAttribute("EventActive")then return end
     local kind=tostring(key);value=tostring(value)
     if kind=="PALETTE" and palettes[value]then pp:SetAttribute("FestivalPalette",value)
     elseif kind=="NAME" and festivalNames[value]then pp:SetAttribute("FestivalName",value)
     elseif kind=="DECOR" and decorModes[value]then pp:SetAttribute("DecorMode",value)else return end
     local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp)end
    elseif action=="REBIRTH" then
     local prestige=pp:GetAttribute("Prestige")or 0;local price=Config.PrestigeBaseCost*(prestige+1)^2;if (pp:GetAttribute("Cash")or 0)<price then return end
     pp:SetAttribute("Cash",Config.StartCash);pp:SetAttribute("Prestige",prestige+1);pp:SetAttribute("RebirthTokens",(pp:GetAttribute("RebirthTokens")or 0)+1+math.floor(prestige/3));for k in pairs(Config.Branches)do pp:SetAttribute(k.."Level",0)end
     local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp) end
    end
   end)
  end
  local mc=part(plot,"SlotMusicConsole",Vector3.new(10,4,5),plot.Floor.Position+Vector3.new(0,2,23),Color3.fromRGB(24,26,32),Enum.Material.Metal)
  local ss=Instance.new("Sound");ss.Name="SlotMusic";ss.Volume=.55;ss.RollOffMode=Enum.RollOffMode.InverseTapered;ss.RollOffMinDistance=12;ss.RollOffMaxDistance=95;ss.Looped=true;ss.Parent=mc
  local mp=Instance.new("ProximityPrompt");mp.ActionText="MUSIQUE SUIVANTE";mp.RequiresLineOfSight=false;mp.MaxActivationDistance=12;mp.Parent=mc;local mi=1
  local function playMusic()local e=Config.Music[mi];if e then ss:Stop();ss.SoundId=e.soundId;ss:Play();mp.ObjectText="DJ • "..e.genre.." • "..e.name end end
  mp.Triggered:Connect(function(pp)if pp==player then mi=mi%#Config.Music+1;playMusic()end end);playMusic()

  break
 end end
end
local danceSlots={nil,nil};local danceActive=false
local function setupDanceBattle(world)
 local ReplicatedStorage=game:GetService("ReplicatedStorage")
 local remote=ReplicatedStorage:FindFirstChild("DanceBattleRemote")or Instance.new("RemoteEvent");remote.Name="DanceBattleRemote";remote.Parent=ReplicatedStorage
 local arena=world.root:FindFirstChild("DanceBattleArena");if not arena then return end
 local function refresh()
  for i=1,2 do local q=arena:FindFirstChild("Queue"..i);local pr=q and q:FindFirstChild("DanceQueuePrompt");if pr then pr.ObjectText=danceSlots[i]and(danceSlots[i].DisplayName.." • PRÊT")or("DANCE BATTLE • JOUEUR "..i)end end
 end
 local function begin()
  if danceActive or not danceSlots[1]or not danceSlots[2]then return end;danceActive=true
  local a,b=danceSlots[1],danceSlots[2];if not a.Parent or not b.Parent then danceActive=false;return end
  local scores={[a]=0,[b]=0};local lastHit={[a]=0,[b]=0};local started=os.clock()
  remote:FireClient(a,"START",b.DisplayName);remote:FireClient(b,"START",a.DisplayName)
  local conn;conn=remote.OnServerEvent:Connect(function(pl,action,rating)
   if action~="HIT"or scores[pl]==nil or os.clock()-started>25 then return end
   if os.clock()-lastHit[pl]<.18 then return end;lastHit[pl]=os.clock()
   local r=math.clamp(tonumber(rating)or 0,0,3);scores[pl]+=({0,10,25,50})[r+1]
  end)
  task.delay(25,function()
   if conn then conn:Disconnect()end
   local sa,sb=scores[a]or 0,scores[b]or 0
   if a.Parent then a:SetAttribute("Cash",(a:GetAttribute("Cash")or 0)+(sa>=sb and 90 or 45));a:SetAttribute("Fans",(a:GetAttribute("Fans")or 0)+(sa>=sb and 12 or 6));remote:FireClient(a,"END",sa,sb,sa>=sb)end
   if b.Parent then b:SetAttribute("Cash",(b:GetAttribute("Cash")or 0)+(sb>sa and 90 or 45));b:SetAttribute("Fans",(b:GetAttribute("Fans")or 0)+(sb>sa and 12 or 6));remote:FireClient(b,"END",sb,sa,sb>sa)end
   danceSlots={nil,nil};danceActive=false;refresh()
  end)
 end
 for i=1,2 do local q=arena:FindFirstChild("Queue"..i);local pr=q and q:FindFirstChild("DanceQueuePrompt");if pr then pr.Triggered:Connect(function(pl)
   if danceActive then return end
   for n=1,2 do if danceSlots[n]==pl then danceSlots[n]=nil;refresh();return end end
   if danceSlots[i]and danceSlots[i]~=pl then return end;danceSlots[i]=pl;refresh();begin()
  end)end end
 refresh()
end
function M.start(world,Config)
 setupDanceBattle(world)
 Players.PlayerRemoving:Connect(function(p)local i=p:GetAttribute("PlotIndex");if i then owners[i]=nil;local plot=getPlot(world,i);if plot then do
    local gui=plot.OwnerSign:FindFirstChild("OwnerGui");if gui then
     local card=gui:FindFirstChild("PlayerCard");if card then card:Destroy()end
     local txt=gui:FindFirstChild("Text");if txt then txt.Visible=true;txt.Text="SLOT LIBRE"end
    end
   end;for _,x in plot:GetChildren()do if x.Name~="Floor" and x.Name~="Trim" and x.Name~="OwnerSign" then x:Destroy()end end end end end)
 task.spawn(function()while task.wait(2)do for _,p in Players:GetPlayers()do
  local prestige=p:GetAttribute("Prestige")or 0;local stage=branchLevel(p,"Stage");local sound=branchLevel(p,"Sound");local crowd=branchLevel(p,"Crowd");local stands=branchLevel(p,"Stands");local marketing=branchLevel(p,"Marketing");local staff=branchLevel(p,"Staff")
  local income=10+stage*8+sound*5+crowd*6+stands*14+marketing*10+staff*8;income=math.floor(income*(1+prestige*.25+(p:GetAttribute("RebirthTokens")or 0)*.05))
  local total=0;for key in pairs(Config.Branches)do total+=branchLevel(p,key)end
  local phase=Config.TycoonPhases[1].name;local nextNeed=nil
  for _,info in ipairs(Config.TycoonPhases)do if total>=info.need then phase=info.name else nextNeed=info.need;break end end
  p:SetAttribute("FestivalPhase",phase);p:SetAttribute("IncomePerTick",income);p:SetAttribute("NextPhaseNeed",nextNeed or -1)
  -- Cash comes from festivals; the loop is active rather than AFK.
 end end end)
end
return M