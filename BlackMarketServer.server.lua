-- Black Market Mayhem: starter pet gameplay
-- Paste this file into a Script under ServerScriptService.
local Players = game:GetService("Players")
local rng = Random.new()
local pets = {}
local definitions = {
 {"Dumpster Goblin","Common",100,2,100},
 {"Tax Rat","Common",150,3,100},
 {"Suspicious Pigeon","Common",200,4,100},
 {"Parking Lot Frog","Common",250,5,100},
 {"Bootleg Bunny","Common",300,6,100},
 {"Microwave Hamster","Uncommon",500,10,50},
 {"Waffle Weasel","Uncommon",650,13,50},
 {"Moped Mole","Uncommon",800,16,50},
 {"Soda Slug","Uncommon",950,19,50},
 {"Neon Possum","Uncommon",1100,22,50},
 {"Cursed Duck","Rare",2500,50,22},
 {"Laser Llama","Rare",3200,64,22},
 {"Disco Raccoon","Rare",4000,80,22},
 {"WiFi Wizard Cat","Rare",5500,110,22},
 {"Golden Roach","Rare",7000,140,22},
 {"Glitch Gecko","Epic",12000,240,9},
 {"Plasma Pug","Epic",16000,320,9},
 {"CEO Capybara","Epic",21000,420,9},
 {"Hologram Hyena","Epic",28000,560,9},
 {"Nuclear Nugget","Legendary",50000,1000,3},
 {"Diamond Dumpster Dragon","Legendary",80000,1600,3},
 {"Void Vulture","Legendary",125000,2500,3},
 {"The Forbidden Ferret","Mythic",250000,5000,1},
 {"Galaxy Goose","Mythic",400000,8000,1},
 {"404 Entity","Secret",1000000,20000,0.15},
 {"The Unlicensed Sun","Secret",2000000,40000,0.08}
}
local palette = {
 Common=Color3.fromRGB(160,165,170),
 Uncommon=Color3.fromRGB(70,210,95),
 Rare=Color3.fromRGB(55,145,255),
 Epic=Color3.fromRGB(175,75,255),
 Legendary=Color3.fromRGB(255,185,40),
 Mythic=Color3.fromRGB(255,55,135),
 Secret=Color3.fromRGB(15,245,225)
}
local weightSum=0
for _,d in ipairs(definitions) do
 pets[d[1]]=d
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
 return plr:GetAttribute("CarriedPet") or ""
end
local function setCarried(plr,name)
 plr:SetAttribute("CarriedPet",name or "")
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
 local entry={part=orb,pet=d}
 table.insert(base.items,entry)
 drawBase(base)
 use(orb,"Steal pet",function(plr)
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
local dealer=block("Black Market Dealer",Vector3.new(0,3,-23),Vector3.new(9,6,5),Color3.fromRGB(50,190,105))
use(dealer,"Sell held pet",function(plr)
 local d=pets[carried(plr)]
 local c=wallet(plr)
 if not d or not c then return end
 c.Value+=d[3]
 setCarried(plr,nil)
end)
for i=1,8 do
 local a=(i-1)*math.pi/4
 local pos=Vector3.new(math.cos(a)*73,0,math.sin(a)*73)
 local base={owner=nil,pos=pos,items={}}
 block("Warehouse "..i,pos,Vector3.new(31,1,25),Color3.fromRGB(70,75,90))
 local deposit=block("Deposit "..i,pos+Vector3.new(0,2,-9),Vector3.new(7,3,3),Color3.fromRGB(50,110,255))
 use(deposit,"Store held pet",function(plr)
  if plr~=base.owner or #base.items>=10 then return end
  local d=pets[carried(plr)]
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
   for _,entry in ipairs(base.items) do income+=entry.pet[4] end
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
   use(orb,"Pick up "..d[2].." pet",function(plr)
    if gone or carried(plr)~="" then return end
    setCarried(plr,d[1])
    remove()
   end)
   task.delay(75,remove)
  end
  task.wait(5)
 end
end)
print("Black Market Mayhem: 26 pets loaded.")
