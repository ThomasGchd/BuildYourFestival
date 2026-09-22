local Players=game:GetService("Players")
local M={};local owners={}
local styles={
 Neon={main=Color3.fromRGB(91,55,220),accent=Color3.fromRGB(40,225,255),secondary=Color3.fromRGB(255,55,190)},
 Industrial={main=Color3.fromRGB(37,40,46),accent=Color3.fromRGB(255,104,38),secondary=Color3.fromRGB(230,215,190)},
 Nature={main=Color3.fromRGB(48,102,58),accent=Color3.fromRGB(245,201,69),secondary=Color3.fromRGB(95,210,125)}
}
local function getPlot(world,i)return world.plots:FindFirstChild("Plot"..i)end
local function buildStage(plot,level,styleName)
 local old=plot:FindFirstChild("PlayerBuild");if old then old:Destroy()end
 local f=Instance.new("Folder");f.Name="PlayerBuild";f.Parent=plot;local s=styles[styleName] or styles.Neon;local pos=plot.Floor.Position
 local function p(n,size,o,c,m)local x=Instance.new("Part");x.Name=n;x.Size=size;x.Position=pos+o;x.Anchored=true;x.Color=c;x.Material=m or Enum.Material.Metal;x.Parent=f;return x end
 p("Stage",Vector3.new(48+level*8,2,28+level*2),Vector3.new(0,1,-30),s.main)
 p("LED",Vector3.new(34+level*5,10+level*1.7,1),Vector3.new(0,8+level*.8,-43),s.accent,Enum.Material.Neon)
 p("DJBooth",Vector3.new(12+level,4,4),Vector3.new(0,4,-21),Color3.fromRGB(20,21,26))
 if level>=2 then for _,x in ipairs({-22,22})do local l=p("Light",Vector3.new(2,2,2),Vector3.new(x,11,-24),s.secondary,Enum.Material.Neon);local sp=Instance.new("SpotLight");sp.Range=50;sp.Angle=45;sp.Brightness=3;sp.Color=s.secondary;sp.Face=Enum.NormalId.Front;sp.Parent=l end end
 if level>=3 then for _,x in ipairs({-28,28})do p("Tower",Vector3.new(3,20+level*2,3),Vector3.new(x,10+level,-25),Color3.fromRGB(28,30,35),Enum.Material.DiamondPlate)end end
 if level>=4 then for _,x in ipairs({-30,30})do p("Speaker",Vector3.new(7,12,5),Vector3.new(x,6,-19),Color3.fromRGB(14,15,18))end end
 if level>=5 then p("Roof",Vector3.new(68,3,29),Vector3.new(0,25,-25),Color3.fromRGB(23,24,29))end
 if level>=6 then for i=-2,2 do local h=p("Laser",Vector3.new(1,1,1),Vector3.new(i*10,22,-20),s.accent,Enum.Material.Neon);local at=Instance.new("Attachment");at.Parent=h;local target=p("Target",Vector3.new(.1,.1,.1),Vector3.new(i*15,2,28),s.accent);target.Transparency=1;target.CanCollide=false;local bt=Instance.new("Attachment");bt.Parent=target;local beam=Instance.new("Beam");beam.Attachment0=at;beam.Attachment1=bt;beam.Width0=.25;beam.Width1=.05;beam.Color=ColorSequence.new(s.accent);beam.LightEmission=1;beam.FaceCamera=true;beam.Parent=h end end
 if level>=7 then p("SideLEDL",Vector3.new(14,18,1),Vector3.new(-37,12,-34),s.secondary,Enum.Material.Neon);p("SideLEDR",Vector3.new(14,18,1),Vector3.new(37,12,-34),s.secondary,Enum.Material.Neon)end
 if level>=8 then p("Crown",Vector3.new(80,4,5),Vector3.new(0,31,-28),s.accent,Enum.Material.Neon)end
end
local function addPad(plot,name,offset,color,action,obj,callback)
 local pad=Instance.new("Part");pad.Name=name;pad.Size=Vector3.new(9,.6,9);pad.Position=plot.Floor.Position+offset;pad.Anchored=true;pad.Color=color;pad.Material=Enum.Material.SmoothPlastic;pad.Parent=plot;local glow=Instance.new("PointLight");glow.Brightness=.45;glow.Range=10;glow.Color=color;glow.Parent=pad
 local pr=Instance.new("ProximityPrompt");pr.ActionText=action;pr.ObjectText=obj;pr.RequiresLineOfSight=false;pr.MaxActivationDistance=10;pr.Parent=pad;pr.Triggered:Connect(callback);return pad
end
function M.assign(player,world,Config)
 if player:GetAttribute("PlotIndex")then return end
 for i=1,Config.PlotCount do if not owners[i]then
  owners[i]=player;player:SetAttribute("PlotIndex",i);player:SetAttribute("Cash",Config.StartCash);player:SetAttribute("Fans",0);player:SetAttribute("StageLevel",0);player:SetAttribute("StageStyle","Neon")
  local plot=getPlot(world,i);plot.OwnerSign.OwnerGui.Text.Text=player.DisplayName.." • FESTIVAL";buildStage(plot,0,"Neon")
  addPad(plot,"UpgradePad",Vector3.new(42,.5,20),Color3.fromRGB(55,220,110),"AMÉLIORER","SCÈNE",function(p)if p~=player then return end;local lv=p:GetAttribute("StageLevel")or 0;if lv>=Config.MaxStageLevel then return end;local cost=Config.StageUpgradeCosts[lv+1];local cash=p:GetAttribute("Cash")or 0;if cash<cost then return end;p:SetAttribute("Cash",cash-cost);lv+=1;p:SetAttribute("StageLevel",lv);p:SetAttribute("Fans",(p:GetAttribute("Fans")or 0)+lv*35);buildStage(plot,lv,p:GetAttribute("StageStyle"))end)
  local styleNames={"Neon","Industrial","Nature"}
  for n,style in ipairs(styleNames)do addPad(plot,"Style"..style,Vector3.new(-42+(n-1)*13,.5,27),styles[style].accent,"STYLE",string.upper(style),function(p)if p~=player then return end;p:SetAttribute("StageStyle",style);buildStage(plot,p:GetAttribute("StageLevel")or 0,style)end)end
  -- Personal DJ console: each owner can cycle the curated catalog inside their own slot.
  local musicConsole=Instance.new("Part");musicConsole.Name="SlotMusicConsole";musicConsole.Size=Vector3.new(10,4,5);musicConsole.Position=plot.Floor.Position+Vector3.new(0,2,24);musicConsole.Anchored=true;musicConsole.Color=Color3.fromRGB(24,26,32);musicConsole.Material=Enum.Material.Metal;musicConsole.Parent=plot
  local slotSound=Instance.new("Sound");slotSound.Name="SlotMusic";slotSound.Volume=.55;slotSound.RollOffMode=Enum.RollOffMode.InverseTapered;slotSound.RollOffMinDistance=12;slotSound.RollOffMaxDistance=105;slotSound.Looped=true;slotSound.Parent=musicConsole
  local mp=Instance.new("ProximityPrompt");mp.ActionText="MUSIQUE SUIVANTE";mp.ObjectText="DJ DE TON FESTIVAL";mp.RequiresLineOfSight=false;mp.MaxActivationDistance=12;mp.Parent=musicConsole
  local musicIndex=1
  local function playSlotTrack()
   local e=Config.Music[musicIndex];if not e then return end
   slotSound:Stop();slotSound.SoundId=e.soundId;slotSound:Play();mp.ObjectText="DJ • "..e.genre.." • "..e.name
  end
  mp.Triggered:Connect(function(pp)if pp~=player then return end;musicIndex=musicIndex%#Config.Music+1;playSlotTrack()end)
  playSlotTrack()
  break
 end end
end
function M.start(world,Config)
 Players.PlayerRemoving:Connect(function(p)local i=p:GetAttribute("PlotIndex");if i then owners[i]=nil;local plot=getPlot(world,i);if plot then plot.OwnerSign.OwnerGui.Text.Text="SLOT LIBRE";for _,n in ipairs({"PlayerBuild","UpgradePad","StyleNeon","StyleIndustrial","StyleNature","SlotMusicConsole"})do local x=plot:FindFirstChild(n);if x then x:Destroy()end end end end end)
 task.spawn(function()while task.wait(2)do for _,p in Players:GetPlayers()do local lv=p:GetAttribute("StageLevel")or 0;p:SetAttribute("Cash",(p:GetAttribute("Cash")or 0)+10+lv*12);p:SetAttribute("Fans",(p:GetAttribute("Fans")or 0)+math.max(1,lv*2))end end end)
end
return M