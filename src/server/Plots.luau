local Players=game:GetService("Players")
local M={};local owners={}
local styles={
 Neon={main=Color3.fromRGB(91,55,220),accent=Color3.fromRGB(40,225,255),secondary=Color3.fromRGB(255,55,190)},
 Industrial={main=Color3.fromRGB(37,40,46),accent=Color3.fromRGB(255,104,38),secondary=Color3.fromRGB(230,215,190)},
 Nature={main=Color3.fromRGB(48,102,58),accent=Color3.fromRGB(245,201,69),secondary=Color3.fromRGB(95,210,125)}
}
local function getPlot(world,i)return world.plots:FindFirstChild("Plot"..i)end
local function part(parent,name,size,pos,color,material)
 local x=Instance.new("Part");x.Name=name;x.Size=size;x.Position=pos;x.Anchored=true;x.Color=color;x.Material=material or Enum.Material.Metal;x.Parent=parent;return x
end
local function branchLevel(p,key)return p:GetAttribute(key.."Level") or 0 end
local function cost(Config,key,level)local b=Config.Branches[key];return math.floor(b.base*(b.growth^level))end
local function buildStage(plot,player)
 local old=plot:FindFirstChild("PlayerBuild");if old then old:Destroy()end
 local f=Instance.new("Folder");f.Name="PlayerBuild";f.Parent=plot
 local s=styles[player:GetAttribute("StageStyle")] or styles.Neon;local pos=plot.Floor.Position
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
 part(f,"FlightCase",Vector3.new(5,3,4),pos+Vector3.new(10,1.5,-27),Color3.fromRGB(45,47,52),Enum.Material.DiamondPlate)
 sign("DJ",Vector3.new(0,7,-29),Vector3.new(10,2.5,.5))
 local deckPrompt=Instance.new("ProximityPrompt");deckPrompt.ActionText="MIXER";deckPrompt.ObjectText="PLATINES DJ";deckPrompt.RequiresLineOfSight=false;deckPrompt.MaxActivationDistance=10;deckPrompt.Parent=deck
 deckPrompt.Triggered:Connect(function(pp)
  if pp~=player then return end
  local combo=(pp:GetAttribute("DJCombo")or 0)+1;pp:SetAttribute("DJCombo",combo);pp:SetAttribute("Cash",(pp:GetAttribute("Cash")or 0)+20+combo*3);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+5+math.floor(combo/3));if (pp:GetAttribute("TutorialStep")or 1)==4 then pp:SetAttribute("TutorialStep",5) end;deckPrompt.ObjectText="PLATINES DJ • COMBO x"..combo
  task.delay(4,function()if pp.Parent then pp:SetAttribute("DJCombo",0);if deckPrompt.Parent then deckPrompt.ObjectText="PLATINES DJ"end end end)
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

 -- Sound is its own visible progression: no speakers at the beginning.
 for i=1,math.min(sound,12)do
  local side=i%2==0 and 1 or -1;local row=math.ceil(i/2);local x=side*(18+math.min(row,3)*7);local y=5+math.floor((row-1)/3)*10
  part(f,"Speaker",Vector3.new(6,9,5),pos+Vector3.new(x,y,-17),Color3.fromRGB(11,12,15),Enum.Material.SmoothPlastic)
 end
 if sound>=10 then for _,x in ipairs({-36,36})do part(f,"SubStack",Vector3.new(12,8,8),pos+Vector3.new(x,4,-15),Color3.fromRGB(9,10,12),Enum.Material.SmoothPlastic)end end

 -- Lighting starts only after buying it; fixtures attach to the stage rather than floating around the field.
 if lights>0 then
  local count=math.min(lights,10)
  for i=1,count do
   local x=-27+(i-1)*(54/math.max(1,count-1));local y=stage>=5 and 23 or 9
   local lamp=part(f,"StageLight",Vector3.new(1.5,1.5,2),pos+Vector3.new(x,y,-18),Color3.fromRGB(35,37,43),Enum.Material.Metal)
   local sp=Instance.new("SpotLight");sp.Range=38;sp.Angle=34;sp.Brightness=.45;sp.Color=s.secondary;sp.Face=Enum.NormalId.Front;sp.Parent=lamp
  end
 end
 if fx>=5 and stage>=5 then
  for i=1,math.min(4,math.floor(fx/5))do local x=-24+(i-1)*16;local head=part(f,"FXHead",Vector3.new(1.2,1.2,1.2),pos+Vector3.new(x,23,-20),Color3.fromRGB(30,32,38),Enum.Material.Metal);local a=Instance.new("Attachment");a.Parent=head;local target=part(f,"FXTarget",Vector3.new(.1,.1,.1),pos+Vector3.new(x*1.4,3,20),s.accent);target.Transparency=1;target.CanCollide=false;local b=Instance.new("Attachment");b.Parent=target;local beam=Instance.new("Beam");beam.Attachment0=a;beam.Attachment1=b;beam.Width0=.06;beam.Width1=.015;beam.Color=ColorSequence.new(s.accent);beam.LightEmission=.6;beam.FaceCamera=true;beam.Enabled=false;beam.Parent=head end
 end

 -- Grounds stay readable and functional, without glowing blocks.
 if crowd>=1 then part(f,"DanceFloor",Vector3.new(100,.16,42),pos+Vector3.new(0,.61,13),Color3.fromRGB(45,47,52),Enum.Material.Slate).CanCollide=false end
 if crowd>=4 then for _,x in ipairs({-42,42})do for z=-2,28,15 do part(f,"Barrier",Vector3.new(1,2.5,11),pos+Vector3.new(x,1.25,z),Color3.fromRGB(105,108,113),Enum.Material.Metal)end end end
 if crowd>=8 then for _,x in ipairs({-31,31})do part(f,"EntryPost",Vector3.new(2,12,2),pos+Vector3.new(x,6,48),Color3.fromRGB(50,52,58),Enum.Material.Metal)end;part(f,"EntryArch",Vector3.new(64,2,2),pos+Vector3.new(0,12,48),Color3.fromRGB(50,52,58),Enum.Material.Metal);sign("ENTREE FESTIVAL",Vector3.new(0,10.5,47.2),Vector3.new(28,3,.5))end
 if stands>=1 then
  for i=1,math.min(stands,6)do local side=i%2==0 and 1 or -1;local row=math.ceil(i/2);local vendor=part(f,"Vendor",Vector3.new(15,7,10),pos+Vector3.new(side*67,3.5,30-row*16),Color3.fromRGB(42,44,50),Enum.Material.Metal);local g=Instance.new("SurfaceGui");g.Face=Enum.NormalId.Front;g.Parent=vendor;local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;local names={"BAR","FOOD","MERCH","VIP","TOKENS","INFO"};t.Text=names[i]or"STAND";t.TextColor3=Color3.new(1,1,1);t.Font=Enum.Font.GothamBold;t.TextScaled=true;t.Parent=g end
 end
 if branchLevel(player,"Staff")>=5 then for _,x in ipairs({-70,70})do part(f,"StaffTent",Vector3.new(16,7,12),pos+Vector3.new(x,3.5,-5),Color3.fromRGB(38,40,45),Enum.Material.Fabric)end end
 if prestige>0 then local mon=part(f,"RebirthMonument",Vector3.new(4,8+math.min(prestige,10),4),pos+Vector3.new(0,4,42),s.accent,Enum.Material.SmoothPlastic);local light=Instance.new("PointLight");light.Brightness=.25;light.Range=10;light.Color=s.accent;light.Parent=mon end
end
local function pad(plot,name,offset,color,callback)
 local p=part(plot,name,Vector3.new(5,4,3),plot.Floor.Position+offset+Vector3.new(0,2,0),Color3.fromRGB(25,28,34),Enum.Material.Metal)
 local trim=part(plot,name.."Glow",Vector3.new(4.2,.18,2.2),plot.Floor.Position+offset+Vector3.new(0,4.1,0),color,Enum.Material.SmoothPlastic);trim.CanCollide=false
 local pr=Instance.new("ProximityPrompt");pr.RequiresLineOfSight=false;pr.MaxActivationDistance=10;pr.Parent=p;pr.Triggered:Connect(callback);return p,pr
end
local function refreshPrompt(pr,Config,key,player)
 local lv=branchLevel(player,key);local b=Config.Branches[key];pr.ActionText=lv>=b.max and "MAX" or ("AMELIORER • $"..cost(Config,key,lv));pr.ObjectText=b.label.." • NIV."..lv
end
function M.assign(player,world,Config)
 if player:GetAttribute("PlotIndex")then return end
 for i=1,Config.PlotCount do if not owners[i]then
  owners[i]=player;player:SetAttribute("PlotIndex",i);player:SetAttribute("Cash",Config.StartCash);player:SetAttribute("Fans",0);player:SetAttribute("StageStyle","Neon");player:SetAttribute("Prestige",0);player:SetAttribute("RebirthTokens",0);player:SetAttribute("DJCombo",0);player:SetAttribute("TutorialStep",1)
  for key in pairs(Config.Branches)do player:SetAttribute(key.."Level",0)end
  local plot=getPlot(world,i);plot.OwnerSign.OwnerGui.Text.Text=player.DisplayName.." • FESTIVAL";buildStage(plot,player)
  -- Upgrades are UI-driven: keep the physical festival clean and readable.
  local upgradeRemote=game:GetService("ReplicatedStorage"):FindFirstChild("FestivalUpgrade")
  if not upgradeRemote then upgradeRemote=Instance.new("RemoteEvent");upgradeRemote.Name="FestivalUpgrade";upgradeRemote.Parent=game:GetService("ReplicatedStorage") end
  if not upgradeRemote:GetAttribute("ServerBound") then
   upgradeRemote:SetAttribute("ServerBound",true)
   upgradeRemote.OnServerEvent:Connect(function(pp,action,key)
    if action=="BUY" and Config.Branches[key] then
     local lv=branchLevel(pp,key);local branch=Config.Branches[key];if lv>=branch.max then return end
     local price=cost(Config,key,lv);local cash=pp:GetAttribute("Cash")or 0;if cash<price then return end
     pp:SetAttribute("Cash",cash-price);pp:SetAttribute(key.."Level",lv+1);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+10+(lv+1)*5)
     local ts=pp:GetAttribute("TutorialStep")or 1
     if ts==1 and key=="Sound" then pp:SetAttribute("TutorialStep",2) elseif ts==2 and key=="Stage" then pp:SetAttribute("TutorialStep",3) elseif ts==3 and key=="Crowd" then pp:SetAttribute("TutorialStep",4) end
     local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp) end
    elseif action=="STYLE" and styles[key] then pp:SetAttribute("StageStyle",key);local pi=pp:GetAttribute("PlotIndex");local target=pi and getPlot(world,pi);if target then buildStage(target,pp) end
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
function M.start(world,Config)
 Players.PlayerRemoving:Connect(function(p)local i=p:GetAttribute("PlotIndex");if i then owners[i]=nil;local plot=getPlot(world,i);if plot then plot.OwnerSign.OwnerGui.Text.Text="SLOT LIBRE";for _,x in plot:GetChildren()do if x.Name~="Floor" and x.Name~="Trim" and x.Name~="OwnerSign" then x:Destroy()end end end end end)
 task.spawn(function()while task.wait(2)do for _,p in Players:GetPlayers()do
  local prestige=p:GetAttribute("Prestige")or 0;local stage=branchLevel(p,"Stage");local sound=branchLevel(p,"Sound");local crowd=branchLevel(p,"Crowd");local stands=branchLevel(p,"Stands");local marketing=branchLevel(p,"Marketing");local staff=branchLevel(p,"Staff")
  local income=10+stage*8+sound*5+crowd*6+stands*14+marketing*10+staff*8;income=math.floor(income*(1+prestige*.25+(p:GetAttribute("RebirthTokens")or 0)*.05))
  p:SetAttribute("Cash",(p:GetAttribute("Cash")or 0)+income);p:SetAttribute("Fans",(p:GetAttribute("Fans")or 0)+math.max(1,crowd+math.floor(marketing*.7)+prestige*3))
 end end end)
end
return M