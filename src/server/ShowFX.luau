local RunService=game:GetService("RunService")
local M={}
local profiles={
 TECHNO={speed=1.0,pulse=1.0},INDUS={speed=.72,pulse=.75},HARDSTYLE={speed=1.35,pulse=1.35},
 JUMPSTYLE={speed=1.25,pulse=1.2},HARD={speed=1.4,pulse=1.4},ELECTRO={speed=1.05,pulse=1.0},["DRUM & BASS"]={speed=1.3,pulse=1.25}
}
function M.start(world)
 local fx=world.stage:FindFirstChild("FX");if not fx then return end
 local targets={};for _,v in fx:GetChildren()do if v.Name=="LaserTarget"then table.insert(targets,v)end end
 local t=0;local acc=0
 RunService.Heartbeat:Connect(function(dt)
  acc+=dt;if acc<1/30 then return end;dt=acc;acc=0
  local style=world.sound:GetAttribute("MusicStyle")or"TECHNO";local p=profiles[style]or profiles.TECHNO;t+=dt*p.speed
  local loud=world.sound.PlaybackLoudness or 0;local energy=math.clamp(loud/420,0,1)
  for i,target in ipairs(targets)do local a=t*.7+i*.41;target.Position=Vector3.new(math.sin(a)*125,5+math.abs(math.sin(a*1.7))*18,-360-math.cos(a*.8)*55)end
  for _,v in fx:GetDescendants()do if v:IsA("Beam")then v.Brightness=.8+energy*2.2*p.pulse;v.Width0=.2+energy*.35 end end
 end)
end
return M