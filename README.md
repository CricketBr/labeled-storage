Adds labels to logistics chests, so you don't need to use colours to identify the chests.

Adds tiny provider and storage chests, 1, 2 and 3 stacks large, so you can downgrade chests instead of setting limits. They upgrade to regular provider and storage chests.

Adds new entities with labels, so their purpose is clear when using Factory Search and similar mods. Use keypad * to change mode (colour and corner highlight) and +- to change number. All containers and storage tanks are included.

Compatible with Warehousing, Nullius, SeaBlock, Angel's Addons - Storage, Bob's Plates, Bob's Logistics, and Angel's Petrochem.

It should be fairly easy to add compatibility with other mods. To do this, either contact me to add directly to this mod, or add code to your mod that calls this mod's functions.

## Compatability

Currently only Seablock, Angel/Bob's and Nullius are supported, and only some of the containers within those mods. Please let me know if you want more added. I need to know which mods are active and which tech makes the container.
	
## Suggested Use for Labeled Storage for Train Stations

You do NOT need a base-wide inventory with this system.

Each station has a mode and a priority. The modes are Provide / Request, (from) Manufacturing / (to) Consumption. Priorities are 0-9.

Each train only travels between Provider and Requester stations of the same material, priority, and M/C. Eg PM1 and RM1, PE4 and RE3.

Use Train Stop Limits for stations to call a train if they have enough material to export, or room for another delivery. Trains will normally rest, full, at provider stations.

Provider priorities:
9 Void. Use this first, or just give up and void it.
7 Byproduct 1. Use this fast so the line doesn't jam.
5 Byproduct 2. Not quite as urgent as Byproduct 1
3 Storage. Use this before intentional production.
1 Intentional production. Use this last.
0 Automatic.

Requester Priorities:
9 Power. Feed power first!
7 Mall. Very useful.
5 Normal.
1 Void. Very little goes here.
0 Automatic.

If there are 2 priorities of copper ore production (intentional and byproduct), but only 1 priority of use, there there are a few ways to do it.

Option 1: Copper made intentionally is exported as PM1. Copper made as byproduct is exported as PM7. The copper ingot block has two requester stations: RM1 and RM7.

Option 2: Copper made as byproduct is exported as PM7. The intentional copper block brings that in, as RM7. A priority splitter combines the imported copper with the fresh copper, and exports it as PM0.

Something similar can be done if there is one provider priority and multiple requester priorities.

If a material is made at multiple priorities and consumed at multiple priorities, you will need a transfer station that imports at RM stations and exports at PC stations.
