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
 -- Festival identity grows with progression.
 if prestige>0 then
  local monument=part(f,"RebirthMonument",Vector3.new(5,10+math.min(prestige,10)*1.5,5),pos+Vector3.new(0,5,43),s.accent,Enum.Material.Neon)
  local light=Instance.new("PointLight");light.Brightness=.6;light.Range=18;light.Color=s.accent;light.Parent=monument
 end
 part(f,"Stage",Vector3.new(48+math.min(stage,20)*3,2,30+tier*4),pos+Vector3.new(0,1,-30),s.main)
 part(f,"LED",Vector3.new(34+math.min(stage,20)*2.4,10+math.min(stage,15),1),pos+Vector3.new(0,10+math.min(stage,15)*.45,-45),s.accent,Enum.Material.Neon)
 local booth=part(f,"DJBooth",Vector3.new(14+tier*2,4,5),pos+Vector3.new(0,4,-20),Color3.fromRGB(20,21,26))
 -- Playable deck: simple performance controls directly on the personal stage.
 local deck=part(f,"DJDeck",Vector3.new(10,1,3.5),pos+Vector3.new(0,6.2,-18.8),Color3.fromRGB(10,11,14),Enum.Material.SmoothPlastic)
 for _,x in ipairs({-3.2,3.2})do local jog=part(f,"JogWheel",Vector3.new(2.4,.35,2.4),pos+Vector3.new(x,6.85,-18.8),Color3.fromRGB(55,58,65),Enum.Material.Metal);jog.Shape=Enum.PartType.Cylinder;jog.Orientation=Vector3.new(0,0,90)end
 local deckPrompt=Instance.new("ProximityPrompt");deckPrompt.ActionText="MIXER";deckPrompt.ObjectText="PLATINES DJ";deckPrompt.RequiresLineOfSight=false;deckPrompt.MaxActivationDistance=10;deckPrompt.Parent=deck
 deckPrompt.Triggered:Connect(function(pp)
  if pp~=player then return end
  local combo=(pp:GetAttribute("DJCombo")or 0)+1;pp:SetAttribute("DJCombo",combo)
  pp:SetAttribute("Cash",(pp:GetAttribute("Cash")or 0)+20+combo*3);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+5+math.floor(combo/3))
  deckPrompt.ObjectText="PLATINES DJ • COMBO x"..combo
  task.delay(4,function()if pp.Parent then pp:SetAttribute("DJCombo",0);if deckPrompt.Parent then deckPrompt.ObjectText="PLATINES DJ" end end end)
 end)
 if stage>=5 then part(f,"Roof",Vector3.new(78+tier*6,3,34),pos+Vector3.new(0,27+tier,-31),Color3.fromRGB(23,24,29))end
 if stage>=10 then for _,x in ipairs({-44,44})do part(f,"Tower",Vector3.new(4,28+tier*3,4),pos+Vector3.new(x,14,-31),Color3.fromRGB(28,30,35),Enum.Material.DiamondPlate)end end
 if stage>=20 then part(f,"Crown",Vector3.new(100,4,5),pos+Vector3.new(0,36,-33),s.accent,Enum.Material.Neon)end
 for i=1,math.min(sound,8)do local side=i%2==0 and 1 or -1;local row=math.ceil(i/2);part(f,"Speaker",Vector3.new(6,10,5),pos+Vector3.new(side*(38+row*5),5,-18),Color3.fromRGB(12,13,16))end
 for i=1,math.min(lights,12)do local x=-44+(i-1)*(88/11);local l=part(f,"Fixture",Vector3.new(1.5,1.5,1.5),pos+Vector3.new(x,22+(i%2)*4,-25),s.secondary,Enum.Material.SmoothPlastic);local sp=Instance.new("SpotLight");sp.Range=35+lights;sp.Angle=30;sp.Brightness=math.min(1.8,0.45+lights*.04);sp.Color=s.secondary;sp.Face=Enum.NormalId.Front;sp.Parent=l end
 for i=1,math.min(fx,8)do local x=-35+(i-1)*10;local h=part(f,"Laser",Vector3.new(.8,.8,.8),pos+Vector3.new(x,24,-20),s.accent,Enum.Material.Neon);local a=Instance.new("Attachment");a.Parent=h;local t=part(f,"LaserTarget",Vector3.new(.1,.1,.1),pos+Vector3.new(x*1.4,2,25+(i%3)*8),s.accent);t.Transparency=1;t.CanCollide=false;local b=Instance.new("Attachment");b.Parent=t;local beam=Instance.new("Beam");beam.Attachment0=a;beam.Attachment1=b;beam.Width0=.15;beam.Width1=.03;beam.Color=ColorSequence.new(s.accent);beam.LightEmission=1;beam.FaceCamera=true;beam.Parent=h end
 if branchLevel(player,"Marketing")>=5 then part(f,"FestivalBanner",Vector3.new(50,8,1),pos+Vector3.new(0,8,47),s.secondary,Enum.Material.Neon) end
 if branchLevel(player,"Staff")>=5 then
  for _,x in ipairs({-72,72})do part(f,"StaffTent",Vector3.new(16,7,12),pos+Vector3.new(x,3.5,-3),Color3.fromRGB(35,38,45),Enum.Material.Fabric)end
 end
 for i=1,math.min(crowd,12)do local x=-48+((i-1)%6)*19;local z=8+math.floor((i-1)/6)*14;part(f,"Barrier",Vector3.new(14,2,.5),pos+Vector3.new(x,1,z),Color3.fromRGB(105,108,115),Enum.Material.Metal)end
 for i=1,math.min(stands,6)do local side=i%2==0 and 1 or -1;local row=math.ceil(i/2);local b=part(f,"Vendor",Vector3.new(14,7,10),pos+Vector3.new(side*68,3.5,30-row*16),i%2==0 and s.accent or s.secondary,Enum.Material.SmoothPlastic);local sg=Instance.new("SurfaceGui");sg.Face=Enum.NormalId.Front;sg.Parent=b;local tx=Instance.new("TextLabel");tx.Size=UDim2.fromScale(1,1);tx.BackgroundTransparency=1;tx.Text={"BAR","FOOD","MERCH","VIP","TOKENS","INFO"}[i];tx.TextScaled=true;tx.TextColor3=Color3.new(1,1,1);tx.Font=Enum.Font.GothamBold;tx.Parent=sg end
end
local function pad(plot,name,offset,color,callback)
 local p=part(plot,name,Vector3.new(11,.45,11),plot.Floor.Position+offset,color,Enum.Material.SmoothPlastic);local pr=Instance.new("ProximityPrompt");pr.RequiresLineOfSight=false;pr.MaxActivationDistance=10;pr.Parent=p;pr.Triggered:Connect(callback);return p,pr
end
local function refreshPrompt(pr,Config,key,player)
 local lv=branchLevel(player,key);local b=Config.Branches[key];pr.ActionText=lv>=b.max and "MAX" or ("AMELIORER • $"..cost(Config,key,lv));pr.ObjectText=b.label.." • NIV."..lv
end
function M.assign(player,world,Config)
 if player:GetAttribute("PlotIndex")then return end
 for i=1,Config.PlotCount do if not owners[i]then
  owners[i]=player;player:SetAttribute("PlotIndex",i);player:SetAttribute("Cash",Config.StartCash);player:SetAttribute("Fans",0);player:SetAttribute("StageStyle","Neon");player:SetAttribute("Prestige",0);player:SetAttribute("RebirthTokens",0);player:SetAttribute("DJCombo",0)
  for key in pairs(Config.Branches)do player:SetAttribute(key.."Level",0)end
  local plot=getPlot(world,i);plot.OwnerSign.OwnerGui.Text.Text=player.DisplayName.." • FESTIVAL";buildStage(plot,player)
  local order={"Stage","Sound","Lights","FX","Crowd","Stands","Marketing","Staff"}
  for n,key in ipairs(order)do
   local col=(n-1)%4;local row=math.floor((n-1)/4)
   local pd,pr=pad(plot,"Upgrade"..key,Vector3.new(-55+col*36,.55,40-row*15),styles.Neon.accent,function(pp)
    if pp~=player then return end;local lv=branchLevel(pp,key);local b=Config.Branches[key];if lv>=b.max then return end
    local price=cost(Config,key,lv);local cash=pp:GetAttribute("Cash")or 0;if cash<price then return end
    pp:SetAttribute("Cash",cash-price);pp:SetAttribute(key.."Level",lv+1);pp:SetAttribute("Fans",(pp:GetAttribute("Fans")or 0)+10+(lv+1)*5);refreshPrompt(pr,Config,key,pp);buildStage(plot,pp)
   end);refreshPrompt(pr,Config,key,player)
  end
  for n,style in ipairs({"Neon","Industrial","Nature"})do local _,pr=pad(plot,"Style"..style,Vector3.new(-35+(n-1)*18,.55,-2),styles[style].accent,function(pp)if pp~=player then return end;pp:SetAttribute("StageStyle",style);buildStage(plot,pp)end);pr.ActionText="CHOISIR";pr.ObjectText="STYLE • "..string.upper(style)end
  local mc=part(plot,"SlotMusicConsole",Vector3.new(10,4,5),plot.Floor.Position+Vector3.new(0,2,23),Color3.fromRGB(24,26,32),Enum.Material.Metal)
  local ss=Instance.new("Sound");ss.Name="SlotMusic";ss.Volume=.55;ss.RollOffMode=Enum.RollOffMode.InverseTapered;ss.RollOffMinDistance=12;ss.RollOffMaxDistance=95;ss.Looped=true;ss.Parent=mc
  local mp=Instance.new("ProximityPrompt");mp.ActionText="MUSIQUE SUIVANTE";mp.RequiresLineOfSight=false;mp.MaxActivationDistance=12;mp.Parent=mc;local mi=1
  local function playMusic()local e=Config.Music[mi];if e then ss:Stop();ss.SoundId=e.soundId;ss:Play();mp.ObjectText="DJ • "..e.genre.." • "..e.name end end
  mp.Triggered:Connect(function(pp)if pp==player then mi=mi%#Config.Music+1;playMusic()end end);playMusic()
  local prestigePad,prestigePrompt=pad(plot,"PrestigePad",Vector3.new(55,.55,-2),Color3.fromRGB(245,190,55),function(pp)
   if pp~=player then return end;local prestige=pp:GetAttribute("Prestige")or 0;local price=Config.PrestigeBaseCost*(prestige+1)^2;if (pp:GetAttribute("Cash")or 0)<price then return end
   pp:SetAttribute("Cash",Config.StartCash);pp:SetAttribute("Prestige",prestige+1);pp:SetAttribute("RebirthTokens",(pp:GetAttribute("RebirthTokens")or 0)+1+math.floor(prestige/3));for key in pairs(Config.Branches)do pp:SetAttribute(key.."Level",0)end;buildStage(plot,pp)
  end);prestigePrompt.ActionText="RENAISSANCE";prestigePrompt.ObjectText="NOUVELLE SAISON • BONUS PERMANENT"
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