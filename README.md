# Config

## Minecraft

### [server.properties](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)

```properties
motd=${CFG_MOTD}
spawn-protection=0
difficulty=hard
```

## DiscordSRV

### [config.yml](https://docs.discordsrv.com/config)

```yaml
BotToken: ${CFG_DISCORDSRV_BOT_TOKEN}
Channels: {"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}
DiscordConsoleChannelId: ${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}
DiscordGameStatus: ["on awooo.tk"]
DiscordConsoleChannelFilters: {"\\[\\/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+(?::[0-9]+)?\\]": "", ".*ERROR DiscordSRV.*": ""}
Experiment_WebhookChatMessageDelivery: true
```

#### [DiscordConsoleChannelFilters](https://docs.discordsrv.com/config/#DiscordConsoleChannelFilters)

Hide IP addresses from Discord console

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
console:
    has-all-permissions: true
logging:
    log-player-ip-addresses: false
scoreboards:
    track-plugin-scoreboards: true
unsupported-settings:
    allow-headless-pistons: true
    allow-permanent-block-break-exploits: true
```

#### [timings.enabled](https://docs.papermc.io/paper/reference/global-configuration#enabled-1)

Use spark instead of timings for performance profiling

#### [logging.log-player-ip-addresses](https://docs.papermc.io/paper/reference/global-configuration#log-player-ip-addresses)

For privacy and security

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
spawn:
    allow-using-signs-inside-spawn-protection: true
```
