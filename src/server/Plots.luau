local Players=game:GetService("Players")
local M={}
local owners={}
local styles={
 Neon={main=Color3.fromRGB(90,55,210),accent=Color3.fromRGB(45,225,255)},
 Industrial={main=Color3.fromRGB(38,42,48),accent=Color3.fromRGB(255,110,45)},
 Nature={main=Color3.fromRGB(52,105,60),accent=Color3.fromRGB(245,205,75)}
}
local function getPlot(world,index)return world.plots:FindFirstChild("Plot"..index)end
local function buildStage(plot,level,styleName)
 local old=plot:FindFirstChild("PlayerBuild");if old then old:Destroy() end
 local f=Instance.new("Folder");f.Name="PlayerBuild";f.Parent=plot
 local style=styles[styleName] or styles.Neon;local pos=plot.Floor.Position
 local function p(n,s,o,c,m)local x=Instance.new("Part");x.Name=n;x.Size=s;x.Position=pos+o;x.Anchored=true;x.Color=c;x.Material=m or Enum.Material.Metal;x.Parent=f;return x end
 p("Stage",Vector3.new(26+level*6,2,18+level*2),Vector3.new(0,1,-22),style.main)
 p("LED",Vector3.new(18+level*5,7+level*1.5,1),Vector3.new(0,6+level*.7,-31),style.accent,Enum.Material.Neon)
 if level>=3 then for _,x in ipairs({-22,22}) do p("Tower",Vector3.new(3,16+level*2,3),Vector3.new(x,8+level,-23),Color3.fromRGB(28,30,35)) end end
 if level>=5 then p("Roof",Vector3.new(55,3,25),Vector3.new(0,22,-23),Color3.fromRGB(24,25,30)) end
end
function M.assign(player,world,Config)
 if player:GetAttribute("PlotIndex") then return end
 for i=1,Config.PlotCount do if not owners[i] then
  owners[i]=player;player:SetAttribute("PlotIndex",i);player:SetAttribute("Cash",Config.StartCash);player:SetAttribute("Fans",0);player:SetAttribute("StageLevel",0);player:SetAttribute("StageStyle","Neon")
  local plot=getPlot(world,i);plot.OwnerSign.OwnerGui.Text.Text=player.DisplayName.."'S STAGE";buildStage(plot,0,"Neon")
  local pad=Instance.new("Part");pad.Name="UpgradePad";pad.Size=Vector3.new(9,.6,9);pad.Position=plot.Floor.Position+Vector3.new(35,.5,12);pad.Anchored=true;pad.Color=Color3.fromRGB(55,220,110);pad.Material=Enum.Material.Neon;pad.Parent=plot
  local pr=Instance.new("ProximityPrompt");pr.ActionText="AMÉLIORER";pr.ObjectText="TA SCÈNE";pr.RequiresLineOfSight=false;pr.MaxActivationDistance=10;pr.Parent=pad
  pr.Triggered:Connect(function(p)
   if p~=player then return end;local lv=p:GetAttribute("StageLevel") or 0;if lv>=Config.MaxStageLevel then return end
   local cost=Config.StageUpgradeCosts[lv+1];local cash=p:GetAttribute("Cash") or 0;if cash<cost then return end
   p:SetAttribute("Cash",cash-cost);lv+=1;p:SetAttribute("StageLevel",lv);p:SetAttribute("Fans",(p:GetAttribute("Fans") or 0)+lv*25);buildStage(plot,lv,p:GetAttribute("StageStyle"))
  end)
  break
 end end
end
function M.start(world,Config)
 Players.PlayerRemoving:Connect(function(p)local i=p:GetAttribute("PlotIndex");if i then owners[i]=nil;local plot=getPlot(world,i);if plot then plot.OwnerSign.OwnerGui.Text.Text="SLOT LIBRE";local b=plot:FindFirstChild("PlayerBuild");if b then b:Destroy() end;local pad=plot:FindFirstChild("UpgradePad");if pad then pad:Destroy() end end end end)
 task.spawn(function()while task.wait(2) do for _,p in Players:GetPlayers() do local lv=p:GetAttribute("StageLevel") or 0;p:SetAttribute("Cash",(p:GetAttribute("Cash") or 0)+8+lv*10);p:SetAttribute("Fans",(p:GetAttribute("Fans") or 0)+math.max(1,lv))end end end)
end
return M