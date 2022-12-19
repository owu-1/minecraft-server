## Configuration
<details>
    <summary>Minecraft</summary>

---
<details>
    <summary>server.properties</summary>

*[Documentation](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)*
```properties
motd=${CFG_HOST}
spawn-protection=0
difficulty=hard
allow-flight=true
white-list=true
```
</details>

---
</details>
<details>
    <summary>DiscordSRV</summary>

---
<details>
    <summary>config.yml</summary>

*[Documentation](https://docs.discordsrv.com/config)*
```yaml
BotToken: ${CFG_DISCORDSRV_BOT_TOKEN}
Channels: {"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}
DiscordConsoleChannelId: ${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}
DiscordGameStatus: ["on ${CFG_HOST}"]
Experiment_WebhookChatMessageDelivery: true
```
</details>
<details>
    <summary>messages.yml</summary>

*[Documentation](https://docs.discordsrv.com/messages)*
```yaml
DiscordChatChannelServerStartupMessage: ""
DiscordChatChannelServerShutdownMessage: ""
ServerWatchdogMessage: "<t:%timestamp%:R> <@${CFG_DISCORDSRV_USERID}>, the server hasn't ticked in %timeout% seconds :fire::bangbang:"
```
<details>
    <summary>Glossary</summary>

- *[DiscordChatChannelServerStartupMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerStartupMessage)*
	* Disable server startup messages
- *[DiscordChatChannelServerShutdownMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerShutdownMessage)*
	* Disable server shutdown messages
- *[ServerWatchdogMessage](https://docs.discordsrv.com/messages/#ServerWatchdogMessage)*
	* Send server watchdog message to a custom userID
</details>
</details>

---
</details>
<details>
    <summary>MyWorlds</summary>

---
<details>
    <summary>config.yml</summary>

*[Documentation](https://wiki.traincarts.net/p/MyWorlds/Configuration)*
```yaml
useWorldInventories: true
mainWorld: "lobby"
```
<details>
    <summary>Glossary</summary>

- *useWorldInventories*
	* Make all worlds hold their own inventory state. This is done to later merge world inventories.
</details>
</details>
<details>
    <summary>defaultproperties.yml</summary>

*[Documentation](https://wiki.traincarts.net/p/MyWorlds/WorldConfiguration)*
```yaml
keepSpawnLoaded: false
```
<details>
    <summary>Glossary</summary>

- *keepSpawnLoaded*
	* Don't waste memory keeping spawn areas loaded!
</details>
</details>

---
</details>
<details>
    <summary>PaperMC</summary>

---
<details>
    <summary>paper-global.yml</summary>

*[Documentation](https://docs.papermc.io/paper/reference/global-configuration)*
```yaml
timings:
    enabled: false
scoreboards:
    track-plugin-scoreboards: true
unsupported-settings:
    allow-headless-pistons: true
    allow-permanent-block-break-exploits: true
    allow-piston-duplication: true
```
<details>
    <summary>Glossary</summary>

- *[timings.enabled](https://docs.papermc.io/paper/reference/global-configuration#enabled-1)*
	* Use spark instead of timings for performance profiling
</details>
</details>
<details>
	<summary>paper-world-defaults.yml</summary>

*[Documentation](https://docs.papermc.io/paper/reference/world-configuration)*
```yaml
anticheat:
    anti-xray.enabled: true
entities:
    behavior:
        ender-dragons-death-always-places-dragon-egg: true
        parrots-are-unaffected-by-player-movement: true
fixes:
    disable-unloaded-chunk-enderpearl-exploit: false
    fix-curing-zombie-villager-discount-exploit: false
scoreboards:
    allow-non-player-entities-on-scoreboards: true
spawn:
    allow-using-signs-inside-spawn-protection: true
```
</details>
</details>
---
<details>
	<summary>Data Packs</summary>

- *Classic Fishing Loot*
	* Reverts the fishing loot back to its pre-1.16 loot table.
- *Coordinates HUD*
	* Adds information to your action bar (XYZ coords and a 24 hour clock).
		* `/trigger ch_toggle`
- *Name Colours*
	* Allows the player to change the colour of their username in chat and in-game.
		* `/trigger color`
- *Nether Portal Coords*
	* Adds a trigger that calculates where a nether portal must be placed in the **other** dimension. Useful for syncing up nether portals.
		* `/trigger nc_overworld/nc_nether`
- *Transfer Enchantments 2 (Books Edition)*
	* Allows the player to transfer enchantments from their items onto books.
		* Throw the item and a book on top of an anvil (not inside it) and the item enchantments will be transferred to the book.
</details>
