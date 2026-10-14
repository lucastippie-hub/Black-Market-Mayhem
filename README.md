# Black Market Mayhem
A Roblox collecting, selling, stealing, and passive-income prototype with **26 original pets** across seven rarities.

## How to install in Roblox Studio
1. Create or open a Roblox Baseplate.
2. Open Explorer, right-click **ServerScriptService**, and insert a **Script**.
3. Rename it `BlackMarketServer` and paste the contents of [BlackMarketServer.server.lua](BlackMarketServer.server.lua).
4. Press **Play**. A temporary map will appear automatically.
5. Hold **E** on glowing pet spheres to pick them up; sell them at the green dealer or store them at the blue station in your assigned warehouse. Stored pets earn cash every second and other players can steal them.

## Current limits
This is a first prototype. Pets are colored placeholder spheres, not finished models. Money and pets are **not saved** between sessions. The interface, better warehouse signs, security, paid upgrades, and balancing are still to come. Test with multiple Studio players to check stealing.

Pet names, rarities, sale prices, passive-income values, and spawn weights are editable in the `definitions` table. This code runs on the server.
