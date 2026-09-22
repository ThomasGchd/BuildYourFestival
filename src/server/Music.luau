local Players=game:GetService("Players")
local MarketplaceService=game:GetService("MarketplaceService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local M={}
function M.start(world,Config)
 local previous=ReplicatedStorage:FindFirstChild("FestivalMusic");if previous then previous:Destroy() end
 local remote=Instance.new("RemoteEvent");remote.Name="FestivalMusic";remote.Parent=ReplicatedStorage
 local queue={};local pending={};local default=1;local playToken=0;local current=nil
 local function play(entry)
  if not entry then return end
  playToken+=1;local token=playToken;current=entry
  world.sound:Stop();world.sound.SoundId=entry.soundId;world.sound.TimePosition=0
  local loaded=false
  local connection=world.sound.Loaded:Connect(function()loaded=true end)
  world.sound:Play()
  task.delay(4,function()
   connection:Disconnect()
   if token~=playToken then return end
   if world.sound.IsLoaded or loaded then
    if not world.sound.IsPlaying then world.sound:Play() end
    remote:FireAllClients("NOW",entry.name,entry.by or "Festival",#queue)
   else
    warn("[BuildYourFestival] Audio failed to load: "..entry.soundId)
    remote:FireAllClients("NOW","Audio indisponible","Festival",#queue)
   end
  end)
 end
 local function nextTrack()
  if #queue>0 then play(table.remove(queue,1))
  elseif #Config.Music>0 then local e=Config.Music[default];default=default%#Config.Music+1;play(e) end
 end
 world.sound.Ended:Connect(function()task.delay(.5,nextTrack)end)
 task.delay(1,nextTrack)
 world.console.ProximityPrompt.Triggered:Connect(function(p)remote:FireClient(p,"OPEN",Config.Music,Config.MainstageProductId)end)
 remote.OnServerEvent:Connect(function(p,action,index)
  if action~="SELECT" or not Config.Music[index] then return end
  pending[p.UserId]=index
  if Config.MainstageProductId==0 then
   -- Studio/free-test mode: selection is immediate so the chooser actually hears the requested track.
   local e=Config.Music[index]
   queue={}
   play({name=e.name,soundId=e.soundId,by=p.DisplayName})
   remote:FireAllClients("QUEUED",e.name,p.DisplayName,0)
  else MarketplaceService:PromptProductPurchase(p,Config.MainstageProductId) end
 end)
 MarketplaceService.ProcessReceipt=function(receipt)
  if receipt.ProductId~=Config.MainstageProductId then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local p=Players:GetPlayerByUserId(receipt.PlayerId);local i=p and pending[p.UserId]
  if not p or not i then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local e=Config.Music[i];table.insert(queue,{name=e.name,soundId=e.soundId,by=p.DisplayName});pending[p.UserId]=nil
  remote:FireAllClients("QUEUED",e.name,p.DisplayName,#queue)
  if not world.sound.IsPlaying then nextTrack() end
  return Enum.ProductPurchaseDecision.PurchaseGranted
 end
end
return M