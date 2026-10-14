-- Black Market Mayhem: dragon collecting prototype
-- Paste this file into a Script under ServerScriptService.
local Players = game:GetService("Players")
local rng = Random.new()
local dragons = {}
local definitions = {
 {"Street Scales Wyrm","Street",100,2,100},
 {"Alley Byte Drake","Street",150,3,100},
 {"Smuggler Drake","Street",200,4,100},
 {"Backdoor Basilisk","Street",250,5,100},
 {"Dumpster Flame Dragon","Street",300,6,100},
 {"Proxy Fang Dragon","Hidden",500,10,50},
 {"Cipher Claw Drake","Hidden",650,13,50},
 {"Firewall Dragon","Hidden",800,16,50},
 {"Packet Prowler","Hidden",950,19,50},
 {"Ghost Cache Dragon","Hidden",1100,22,50},
 {"Deep Vault Dragon","Deep",2500,50,22},
 {"Onion Wing Serpent","Deep",3200,64,22},
 {"Hex Market Hydra","Deep",4000,80,22},
 {"Torrent Talon Drake","Deep",5500,110,22},
 {"Black Ice Dragon","Deep",7000,140,22},
 {"Zero-Day Wyvern","Shadow",12000,240,9},
 {"Night Protocol Dragon","Shadow",16000,320,9},
 {"Phantom Listing Dragon","Shadow",21000,420,9},
 {"Neon Hydra","Shadow",28000,560,9},
 {"Ransomfire Dragon","Phantom",50000,1000,3},
 {"Diamond Vault Dragon","Phantom",80000,1600,3},
 {"Void Auction Dragon","Phantom",125000,2500,3},
 {"Obsidian King Wyrm","Mythic",250000,5000,1},
 {"Galaxy Dragon","Mythic",400000,8000,1},
 {"404 Shadow Dragon","Dark Web",1000000,20000,0.15},
 {"Forbidden Root Dragon","Dark Web",2000000,40000,0.08}
}
local palette = {
 Street=Color3.fromRGB(160,165,170),
 Hidden=Color3.fromRGB(70,210,95),
 Deep=Color3.fromRGB(55,145,255),
 Shadow=Color3.fromRGB(175,75,255),
 Phantom=Color3.fromRGB(255,185,40),
 Mythic=Color3.fromRGB(255,55,135),
 ["Dark Web"]=Color3.fromRGB(15,245,225)
}
local weightSum=0
for _,d in ipairs(definitions) do
 dragons[d[1]]=d
 weightSum+=d[5]
end
local function roll()
 local r=rng:NextNumber(0,weightSum)
 for _,d in ipairs(definitions) do
  r-=d[5]
  if r<=0 then return d end
 end
 return definitions[1]
end
local world=Instance.new("Folder")
world.Name="BlackMarketPrototype"
world.Parent=workspace
local function block(name,pos,size,color,shape)
 local p=Instance.new("Part")
 p.Name=name
 p.Position=pos
 p.Size=size
 p.Color=color
 p.Anchored=true
 p.Shape=shape or Enum.PartType.Block
 p.Parent=world
 return p
end
local function use(part,action,fn)
 local p=Instance.new("ProximityPrompt")
 p.ActionText=action
 p.ObjectText=part.Name
 p.MaxActivationDistance=10
 p.HoldDuration=0.5
 p.RequiresLineOfSight=false
 p.Parent=part
 p.Triggered:Connect(fn)
end
local bases={}
local assigned={}
local function carried(plr)
 return plr:GetAttribute("CarriedDragon") or ""
end
local function setCarried(plr,name)
 plr:SetAttribute("CarriedDragon",name or "")
end
local function wallet(plr)
 local s=plr:FindFirstChild("leaderstats")
 return s and s:FindFirstChild("Cash")
end
local function drawBase(base)
 for i,entry in ipairs(base.items) do
  entry.part.Position=base.pos+Vector3.new(-9+((i-1)%5)*4.5,3,-2+math.floor((i-1)/5)*5)
 end
end
local function store(base,d)
 local orb=block(d[1],base.pos+Vector3.new(0,3,0),Vector3.new(3,3,3),palette[d[2]],Enum.PartType.Ball)
 orb.Material=Enum.Material.Neon
 local entry={part=orb,dragon=d}
 table.insert(base.items,entry)
 drawBase(base)
 use(orb,"Steal dragon",function(plr)
  if not base.owner or plr==base.owner or carried(plr)~="" then return end
  local index=table.find(base.items,entry)
  if not index then return end
  table.remove(base.items,index)
  orb:Destroy()
  setCarried(plr,d[1])
  drawBase(base)
 end)
end
block("Asphalt",Vector3.new(0,-1,0),Vector3.new(220,2,220),Color3.fromRGB(38,40,50))
local spawn=Instance.new("SpawnLocation")
spawn.Name="Market Spawn"
spawn.Position=Vector3.new(0,0.5,0)
spawn.Size=Vector3.new(12,1,12)
spawn.Anchored=true
spawn.Neutral=true
spawn.Parent=world
local dealer=block("Dark Web Broker",Vector3.new(0,3,-23),Vector3.new(9,6,5),Color3.fromRGB(50,190,105))
use(dealer,"Sell held dragon",function(plr)
 local d=dragons[carried(plr)]
 local c=wallet(plr)
 if not d or not c then return end
 c.Value+=d[3]
 setCarried(plr,nil)
end)

-- Fictional underground egg terminals; purchased with earned game cash.
local eggTiers = {Street=1,Hidden=2,Deep=3,Shadow=4,Phantom=5,Mythic=6,["Dark Web"]=7}
local eggs = {
 {"Street Egg",500,1,3,Vector3.new(-18,3,23)},
 {"Shadow Egg",20000,3,5,Vector3.new(0,3,23)},
 {"Forbidden Egg",150000,5,7,Vector3.new(18,3,23)}
}
for _,egg in ipairs(eggs) do
 local station=block("Underground Terminal - "..egg[1],egg[5],Vector3.new(10,6,5),Color3.fromRGB(28,65,85))
 use(station,"Hatch $"..egg[2],function(plr)
  local c=wallet(plr)
  if not c or c.Value<egg[2] or carried(plr)~="" then return end
  local candidates={}
  local total=0
  for _,dragon in ipairs(definitions) do
   local tier=eggTiers[dragon[2]]
   if tier>=egg[3] and tier<=egg[4] then
    table.insert(candidates,dragon)
    total+=dragon[5]
   end
  end
  if total<=0 then return end
  c.Value-=egg[2]
  local roll=rng:NextNumber(0,total)
  for _,dragon in ipairs(candidates) do
   roll-=dragon[5]
   if roll<=0 then
    setCarried(plr,dragon[1])
    plr:SetAttribute("LatestHatch",dragon[1])
    plr:SetAttribute("LatestTier",dragon[2])
    break
   end
  end
 end)
end

for i=1,8 do
 local a=(i-1)*math.pi/4
 local pos=Vector3.new(math.cos(a)*73,0,math.sin(a)*73)
 local base={owner=nil,pos=pos,items={}}
 block("Warehouse "..i,pos,Vector3.new(31,1,25),Color3.fromRGB(70,75,90))
 local deposit=block("Deposit "..i,pos+Vector3.new(0,2,-9),Vector3.new(7,3,3),Color3.fromRGB(50,110,255))
 use(deposit,"Store held dragon",function(plr)
  if plr~=base.owner or #base.items>=10 then return end
  local d=dragons[carried(plr)]
  if not d then return end
  setCarried(plr,nil)
  store(base,d)
 end)
 table.insert(bases,base)
end
Players.PlayerAdded:Connect(function(plr)
 local stats=Instance.new("Folder")
 stats.Name="leaderstats"
 stats.Parent=plr
 local cash=Instance.new("IntValue")
 cash.Name="Cash"
 cash.Parent=stats
 setCarried(plr,nil)
 plr:SetAttribute("IncomePerSecond",0)
 for i,base in ipairs(bases) do
  if not base.owner then
   base.owner=plr
   assigned[plr]=base
   plr:SetAttribute("Warehouse",i)
   break
  end
 end
end)
Players.PlayerRemoving:Connect(function(plr)
 local base=assigned[plr]
 if not base then return end
 for _,entry in ipairs(base.items) do entry.part:Destroy() end
 base.items={}
 base.owner=nil
 assigned[plr]=nil
end)
task.spawn(function()
 while true do
  task.wait(1)
  for plr,base in pairs(assigned) do
   local income=0
   for _,entry in ipairs(base.items) do income+=entry.dragon[4] end
   plr:SetAttribute("IncomePerSecond",income)
   local c=wallet(plr)
   if c then c.Value+=income end
  end
 end
end)
local active=0
task.spawn(function()
 while true do
  if active<16 then
   local d=roll()
   local orb=block(d[1],Vector3.new(rng:NextInteger(-25,25),2,rng:NextInteger(-12,12)),Vector3.new(3,3,3),palette[d[2]],Enum.PartType.Ball)
   orb.Material=Enum.Material.Neon
   active+=1
   local gone=false
   local function remove()
    if gone then return end
    gone=true
    active-=1
    orb:Destroy()
   end
   use(orb,"Pick up "..d[2].." dragon",function(plr)
    if gone or carried(plr)~="" then return end
    setCarried(plr,d[1])
    remove()
   end)
   task.delay(75,remove)
  end
  task.wait(5)
 end
end)
print("Black Market Mayhem: 26 dragons loaded.")
