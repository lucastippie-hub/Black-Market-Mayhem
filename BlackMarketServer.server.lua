-- Black Market Mayhem: dragon collecting prototype
-- Paste this file into a Script under ServerScriptService.
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
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
 Street=Color3.fromRGB(80,85,95),
 Hidden=Color3.fromRGB(24,110,80),
 Deep=Color3.fromRGB(30,75,155),
 Shadow=Color3.fromRGB(95,35,150),
 Phantom=Color3.fromRGB(170,65,25),
 Mythic=Color3.fromRGB(165,25,85),
 ["Dark Web"]=Color3.fromRGB(10,190,165)
}

-- Deep midnight lighting; no external dark-web websites involved.
Lighting.ClockTime=19.5
Lighting.Brightness=2.5
Lighting.Ambient=Color3.fromRGB(65,70,92)
Lighting.OutdoorAmbient=Color3.fromRGB(55,62,85)
Lighting.FogColor=Color3.fromRGB(12,14,25)
Lighting.FogEnd=310
local atmosphere=Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
atmosphere.Density=0.24
atmosphere.Color=Color3.fromRGB(36,41,59)
atmosphere.Decay=Color3.fromRGB(12,14,24)
atmosphere.Haze=0.8
atmosphere.Parent=Lighting
local grading=Lighting:FindFirstChild("UnderworldGrading") or Instance.new("ColorCorrectionEffect")
grading.Name="UnderworldGrading"
grading.TintColor=Color3.fromRGB(195,215,255)
grading.Contrast=0.1
grading.Saturation=-0.12
grading.Brightness=0.06
grading.Parent=Lighting
local bloom=Lighting:FindFirstChild("UnderworldBloom") or Instance.new("BloomEffect")
bloom.Name="UnderworldBloom"
bloom.Intensity=0.3
bloom.Size=18
bloom.Threshold=1.3
bloom.Parent=Lighting

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

-- Each dragon is built from simple Roblox parts, so no external assets are required.
-- The central sphere is the hitbox; wings, head, horns, eyes and tail are welded to it.
local function createDragon(name,pos,tier)
 local tint=palette[tier]
 local root=block(name,pos,Vector3.new(3,2.5,4),Color3.fromRGB(23,24,32),Enum.PartType.Ball)
 root.Material=Enum.Material.Slate
 root.CanCollide=false
 local function limb(className,label,offset,size,color,material,shape,rotation)
  local p=Instance.new(className)
  p.Name=label
  p.Size=size
  p.Color=color
  p.Material=material or Enum.Material.SmoothPlastic
  if className=="Part" then p.Shape=shape or Enum.PartType.Block end
  p.CanCollide=false
  p.Massless=true
  p.CFrame=root.CFrame * CFrame.new(offset) * (rotation or CFrame.new())
  p.Parent=root
  local weld=Instance.new("WeldConstraint")
  weld.Part0=root
  weld.Part1=p
  weld.Parent=p
  return p
 end
 limb("Part","Dragon Head",Vector3.new(0,1,-2.1),Vector3.new(2,1.65,2),Color3.fromRGB(19,20,28),Enum.Material.Slate,Enum.PartType.Ball)
 limb("Part","Snout",Vector3.new(0,0.8,-3),Vector3.new(1.3,0.75,1.5),Color3.fromRGB(27,28,37),Enum.Material.Slate,Enum.PartType.Ball)
 for _,side in ipairs({-1,1}) do
  limb("WedgePart","Ragged Wing",Vector3.new(side*2.5,0.65,0.4),Vector3.new(3.8,0.35,4.6),tint,Enum.Material.SmoothPlastic,nil,CFrame.Angles(0,side*0.25,side*0.28))
  limb("WedgePart","Horn",Vector3.new(side*0.65,2,-2.1),Vector3.new(0.5,1.2,0.75),Color3.fromRGB(8,8,13),Enum.Material.Slate,nil,CFrame.Angles(-0.25,0,0))
  limb("Part","Glowing Eye",Vector3.new(side*0.75,1.35,-2.92),Vector3.new(0.22,0.26,0.23),tint,Enum.Material.Neon,Enum.PartType.Ball)
  limb("Part","Claw",Vector3.new(side*1.05,-0.9,-1.05),Vector3.new(0.55,1.1,0.65),Color3.fromRGB(11,11,16),Enum.Material.Slate)
 end
 limb("WedgePart","Spiked Tail",Vector3.new(0,0.1,3.3),Vector3.new(1.15,1.1,3.4),Color3.fromRGB(16,16,24),Enum.Material.Slate,nil,CFrame.Angles(-0.15,math.pi,0))
 limb("WedgePart","Back Spike",Vector3.new(0,1.45,0.6),Vector3.new(0.8,1.4,1.1),tint,Enum.Material.SmoothPlastic)
 local glow=Instance.new("PointLight")
 glow.Color=tint
 glow.Brightness=1.1
 glow.Range=12
 glow.Parent=root
 local smoke=Instance.new("Smoke")
 smoke.Color=Color3.fromRGB(6,7,12)
 smoke.Opacity=0.38
 smoke.RiseVelocity=0.5
 smoke.Size=2
 smoke.Parent=root
 local title=Instance.new("BillboardGui")
 title.Size=UDim2.fromOffset(220,48)
 title.StudsOffset=Vector3.new(0,4.3,0)
 title.AlwaysOnTop=true
 title.MaxDistance=65
 title.Parent=root
 local text=Instance.new("TextLabel")
 text.Size=UDim2.fromScale(1,1)
 text.BackgroundTransparency=1
 text.Text=name.."\\n["..tier.."]"
 text.TextColor3=tint
 text.TextStrokeTransparency=0
 text.TextScaled=true
 text.Font=Enum.Font.GothamBold
 text.Parent=title
 return root
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
 local orb=createDragon(d[1],base.pos+Vector3.new(0,3,0),d[2])
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
block("Asphalt",Vector3.new(0,-1,0),Vector3.new(220,2,220),Color3.fromRGB(40,44,57))

-- Neon downtown silhouettes, lamps, roads and a central underground yard.
for i=1,20 do
 local angle=i*math.pi/10
 local radius=96
 local x=math.cos(angle)*radius
 local z=math.sin(angle)*radius
 local height=rng:NextInteger(16,38)
 block("Abandoned Tower "..i,Vector3.new(x,height/2,z),Vector3.new(13,height,13),Color3.fromRGB(14,17,25))
 local beacon=block("Rooftop Neon "..i,Vector3.new(x,height+1,z),Vector3.new(9,0.5,9),i%2==0 and Color3.fromRGB(90,20,125) or Color3.fromRGB(12,100,110))
 beacon.Material=Enum.Material.Neon
end
for i=1,12 do
 local theta=i*math.pi/6
 local x=math.cos(theta)*42
 local z=math.sin(theta)*42
 block("Lamp Post "..i,Vector3.new(x,4,z),Vector3.new(0.7,8,0.7),Color3.fromRGB(28,30,37))
 local bulb=block("Neon Lantern "..i,Vector3.new(x,8.3,z),Vector3.new(2,0.7,2),Color3.fromRGB(22,160,165))
 bulb.Material=Enum.Material.Neon
 local light=Instance.new("PointLight")
 light.Color=bulb.Color
 light.Range=34
 light.Brightness=2.2
 light.Parent=bulb
end

local spawn=Instance.new("SpawnLocation")
spawn.Name="Market Spawn"
spawn.Position=Vector3.new(0,0.5,0)
spawn.Size=Vector3.new(12,1,12)
spawn.Anchored=true
spawn.Neutral=true
spawn.Color=Color3.fromRGB(28,30,38)
spawn.Parent=world
local dealer=block("Dark Web Broker",Vector3.new(0,3,-23),Vector3.new(9,6,5),Color3.fromRGB(17,78,67))
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

-- Hatching reveal: local visual on the terminal, no paid randomness.
local function hatchFlash(station,tier)
 local fx=Instance.new("PointLight")
 fx.Color=palette[tier]
 fx.Brightness=7
 fx.Range=24
 fx.Parent=station
 task.delay(0.8,function()
  if fx.Parent then fx:Destroy() end
 end)
end

for _,egg in ipairs(eggs) do
 local station=block("Underground Terminal - "..egg[1],egg[5],Vector3.new(10,6,5),Color3.fromRGB(17,30,49))
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
    hatchFlash(station,dragon[2])
    break
   end
  end
 end)
end

for i=1,8 do
 local a=(i-1)*math.pi/4
 local pos=Vector3.new(math.cos(a)*73,0,math.sin(a)*73)
 local base={owner=nil,pos=pos,items={}}
 block("Warehouse "..i,pos,Vector3.new(31,1,25),Color3.fromRGB(49,54,70))
 local deposit=block("Deposit "..i,pos+Vector3.new(0,2,-9),Vector3.new(7,3,3),Color3.fromRGB(26,48,90))
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
   local orb=createDragon(d[1],Vector3.new(rng:NextInteger(-25,25),2,rng:NextInteger(-12,12)),d[2])
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
