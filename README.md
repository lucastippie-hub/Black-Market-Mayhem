# Black Market Mayhem — Dark Web Dragons

A dark-themed Roblox prototype with **26 original dragons** across seven tiers: Street, Hidden, Deep, Shadow, Phantom, Mythic, and Dark Web.

## New visual features
- Midnight fog, desaturated lighting, abandoned buildings, neon rooftops, and teal streetlamps.
- Procedural dragon figures assembled from Roblox parts: dark bodies, wings, horns, eyes, claws, and spiked tails.
- Tier-colored glowing eyes, smoky aura, and overhead name labels.
- Egg hatch flashes on the terminals.
- No external models or websites needed.

## How to test in Roblox Studio
1. Open your Roblox place.
2. In Explorer, go to **ServerScriptService** and insert a regular **Script** named `BlackMarketServer`.
3. Copy the complete code from [BlackMarketServer.server.lua](BlackMarketServer.server.lua) and paste it into that Script. If you already had the older version, **replace it** rather than adding a second script.
4. Press **Play**. The map is generated when the server runs.
5. Hold **E** at a dragon to carry it; hold **E** at the **Dark Web Broker** to sell it, or at your blue warehouse deposit station to store it for passive income.
6. Test multiplayer with two Studio players to steal dragons from another vault.

## Egg prices (in-game Cash only)
- Street Egg: $500, Street through Deep
- Shadow Egg: $20,000, Deep through Phantom
- Forbidden Egg: $150,000, Phantom through Dark Web

## Known prototype limitations
- Dragon models are low-poly parts, not detailed animated meshes.
- Hatching effect is a light flash, not yet a full cinematic.
- No DataStore saves, gamepasses, inventory UI, vault locks, or release balancing yet.
- Scripts committed to GitHub **do not automatically sync** with Roblox Studio.
- Prototype code has not been play-tested in a live Roblox Studio session.
