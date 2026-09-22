local Players=game:GetService("Players")
local MarketplaceService=game:GetService("MarketplaceService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local M={}
function M.start(world,Config)
 local remote=Instance.new("RemoteEvent");remote.Name="FestivalMusic";remote.Parent=ReplicatedStorage
 local queue={};local pending={};local default=1
 local function play(entry)
  world.sound:Stop();world.sound.SoundId=entry.soundId;world.sound:Play()
  remote:FireAllClients("NOW",entry.name,entry.by or "Festival",#queue)
 end
 local function nextTrack()
  if #queue>0 then play(table.remove(queue,1)) else local e=Config.Music[default];default=default%#Config.Music+1;play(e) end
 end
 world.sound.Ended:Connect(nextTrack);task.delay(2,nextTrack)
 world.console.ProximityPrompt.Triggered:Connect(function(p)remote:FireClient(p,"OPEN",Config.Music,Config.MainstageProductId)end)
 remote.OnServerEvent:Connect(function(p,action,index)
  if action~="SELECT" or not Config.Music[index] then return end
  pending[p.UserId]=index
  if Config.MainstageProductId==0 then local e=Config.Music[index];table.insert(queue,{name=e.name,soundId=e.soundId,by=p.DisplayName});remote:FireAllClients("QUEUED",e.name,p.DisplayName,#queue)
  else MarketplaceService:PromptProductPurchase(p,Config.MainstageProductId) end
 end)
 MarketplaceService.ProcessReceipt=function(receipt)
  if receipt.ProductId~=Config.MainstageProductId then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local p=Players:GetPlayerByUserId(receipt.PlayerId);local i=p and pending[p.UserId];if not p or not i then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local e=Config.Music[i];table.insert(queue,{name=e.name,soundId=e.soundId,by=p.DisplayName});pending[p.UserId]=nil
  return Enum.ProductPurchaseDecision.PurchaseGranted
 end
end
return M