local RunService=game:GetService("RunService")
local M={}
function M.start(world)
 local fx=world.stage:FindFirstChild("FX");if not fx then return end
 local targets={}
 for _,v in fx:GetChildren()do if v.Name=="LaserTarget"then table.insert(targets,v)end end
 local t=0
 RunService.Heartbeat:Connect(function(dt)
  t+=dt
  local loud=world.sound.PlaybackLoudness or 0
  for i,target in ipairs(targets)do
   local a=t*.7+i*.41
   target.Position=Vector3.new(math.sin(a)*125,5+math.abs(math.sin(a*1.7))*18,-360-math.cos(a*.8)*55)
  end
  for _,v in fx:GetDescendants()do if v:IsA("Beam")then v.Brightness=1.2+math.clamp(loud/250,0,4);v.Width0=.25+math.clamp(loud/1200,0,.5)end end
 end)
end
return M