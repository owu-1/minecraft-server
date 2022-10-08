# Config

## Minecraft

### [server.properties](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)

```properties
motd=${CFG_HOST}
spawn-protection=0
difficulty=hard
```

## DiscordSRV

### [config.yml](https://docs.discordsrv.com/config)

```yaml
BotToken: ${CFG_DISCORDSRV_BOT_TOKEN}
Channels: {"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}
DiscordConsoleChannelId: ${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}
DiscordGameStatus: ["on ${CFG_HOST}"]
DiscordConsoleChannelFilters: {"^\\[DiscordSRV\\]  at .+$": "","^\\[... ..:..:.. ERROR DiscordSRV\\].*$":""}
Experiment_WebhookChatMessageDelivery: true
```

#### [DiscordConsoleChannelFilters](https://docs.discordsrv.com/config/#DiscordConsoleChannelFilters)

Hide DiscordSRV stacktraces when the internet drops out

### [messages.yml](https://docs.discordsrv.com/messages)

```yaml
DiscordChatChannelServerStartupMessage: ""
DiscordChatChannelServerShutdownMessage: ""
ServerWatchdogMessage: "<t:%timestamp%:R> <@${CFG_DISCORDSRV_USERID}>, the server hasn't ticked in %timeout% seconds :fire::bangbang:"
```

#### [DiscordChatChannelServerStartupMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerStartupMessage)

Disable server startup messages

#### [DiscordChatChannelServerShutdownMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerShutdownMessage)

Disable server shutdown messages

#### [ServerWatchdogMessage](https://docs.discordsrv.com/messages/#ServerWatchdogMessage)

Send server watchdog message to a custom userID

## MyWorlds

### [config.yml](https://wiki.traincarts.net/p/MyWorlds/Configuration)

```yaml
useWorldInventories: true
mainWorld: "lobby"
```

#### useWorldInventories

Make all worlds hold their own inventory state. This is done to later merge world inventories

### [defaultproperties.yml](https://wiki.traincarts.net/p/MyWorlds/WorldConfiguration)

```yaml
keepSpawnLoaded: false
```

#### keepSpawnLoaded

Don't waste memory keeping spawn areas loaded

## PaperMC

### [paper-global.yml](https://docs.papermc.io/paper/reference/global-configuration)

```yaml
timings:
    enabled: false
scoreboards:
    track-plugin-scoreboards: true
unsupported-settings:
    allow-headless-pistons: true
    allow-permanent-block-break-exploits: true
```

#### [timings.enabled](https://docs.papermc.io/paper/reference/global-configuration#enabled-1)

Use spark instead of timings for performance profiling

### [paper-world-defaults.yml](https://docs.papermc.io/paper/reference/world-configuration)

```yaml
anticheat:
    anti-xray.enabled: true
entities:
    behavior:
        ender-dragons-death-always-places-dragon-egg: true
        parrots-are-unaffected-by-player-movement: true
fixes:
    fix-curing-zombie-villager-discount-exploit: false
scoreboards:
    allow-non-player-entities-on-scoreboards: true
```
