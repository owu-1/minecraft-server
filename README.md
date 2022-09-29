# Config
### Minecraft - [server.properties](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)
```
motd=${CFG_MOTD}
spawn-protection=0
difficulty=hard
```

## DiscordSRV
### [config.yml](https://docs.discordsrv.com/config)
```
BotToken: ${CFG_DISCORDSRV_BOT_TOKEN}
Channels: {"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}
DiscordConsoleChannelId: ${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}
DiscordGameStatus: ["on awooo.tk"]
DiscordConsoleChannelFilters: {"\\[\\/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+(?::[0-9]+)?\\]": "", ".*ERROR DiscordSRV.*": ""}             # Hide IP addresses from Discord console
Experiment_WebhookChatMessageDelivery: true
```

### [messages.yml](https://docs.discordsrv.com/messages)
```
DiscordChatChannelServerStartupMessage: ""            # Disable server startup messages
DiscordChatChannelServerShutdownMessage: ""            # Disable server shutdown messages
ServerWatchdogMessage: "<t:%timestamp%:R> <@${CFG_DISCORDSRV_USERID}>, the server hasn't ticked in %timeout% seconds :fire::bangbang:"            # Send server watchdog message to a custom userID
```

## MyWorlds

### [config.yml](https://wiki.traincarts.net/p/MyWorlds/Configuration)
```
useWorldInventories: true            # Make all worlds hold their own inventory state. This is done to later merge world inventories. See 'https://wiki.traincarts.net/p/MyWorlds/SeperateInventories#Configuration' for more info.
mainWorld: "lobby"
```

### defaultproperties.yml
```
keepSpawnLoaded: false            # Don't waste memory keeping spawn areas loaded
```

## PaperMC

### [paper-global.yml](https://docs.papermc.io/paper/reference/global-configuration)
```
timings.enabled: false            # Use spark instead of timings for performance profiling
console.has-all-permissions: true
logging.log-player-ip-addresses: false            # For privacy and security :)
scoreboards.track-plugin-scoreboards: true
unsupported-settings.allow-headless-pistons: true
unsupported-settings.allow-permanent-block-break-exploits: true
```

### [paper-world-defaults.yml](https://docs.papermc.io/paper/reference/world-configuration)
```
anticheat.anti-xray.enabled: true
entities.behavior.ender-dragons-death-always-places-dragon-egg: true
entities.behavior.parrots-are-unaffected-by-player-movement: true
fixes.fix-curing-zombie-villager-discount-exploit: false
scoreboards.allow-non-player-entities-on-scoreboards: true
spawn.allow-using-signs-inside-spawn-protection: true
```
