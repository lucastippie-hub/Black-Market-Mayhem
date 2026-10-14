# Black Market Mayhem — Dark Web Dragons

A Roblox prototype with **26 original collectible dragons** and seven tiers: Street, Hidden, Deep, Shadow, Phantom, Mythic, and Dark Web.

## Install in Roblox Studio
1. Open the place in Roblox Studio.
2. Open **Explorer → ServerScriptService**.
3. Insert a regular **Script** called `BlackMarketServer`.
4. Copy and paste all the code from [BlackMarketServer.server.lua](BlackMarketServer.server.lua) into that Script. **Replace the old script; don't keep both.**
5. Press **Play**.

## How to play
- Hold **E** near a glowing dragon to capture it (only one carried at a time).
- Sell it at the **Dark Web Broker** for instant cash.
- Store it at the blue **Deposit** station at your assigned warehouse for passive income each second.
- In multiplayer, steal dragons from someone else's warehouse and bring them home.
- Hatch new dragons at three underground egg terminals. Hatching uses *in-game Cash*, not Robux:
  - **Street Egg:** $500 (Street–Deep tiers)
  - **Shadow Egg:** $20,000 (Deep–Phantom tiers)
  - **Forbidden Egg:** $150,000 (Phantom–Dark Web tiers)
- A successful hatch sets your `CarriedDragon`, `LatestHatch`, and `LatestTier` player attributes.

## Prototype caveats
- Dragons are **placeholder neon spheres**, not finished 3D dragon models.
- The egg terminals are simple proximity prompts, not a complete website-style interface.
- Cash and dragons are **not saved** between sessions.
- No inventory UI, gamepass shop, raid protection, or polished city yet.
- Test in Roblox Studio with two players before publishing.
