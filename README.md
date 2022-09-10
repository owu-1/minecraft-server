# Config

## Minecraft

### [server.properties](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)

#### motd

`${CFG_MOTD}`

#### spawn-protection

`0`

## DiscordSRV

### config.yml

#### [BotToken](https://docs.discordsrv.com/config/#BotToken)

`${CFG_DISCORDSRV_BOT_TOKEN}`

#### [Channels](https://docs.discordsrv.com/config/#Channels)

`{"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}`

#### [DiscordConsoleChannelId](https://docs.discordsrv.com/config/#DiscordConsoleChannelId)

`${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}`

#### [DiscordConsoleChannelFilters](https://docs.discordsrv.com/config/#DiscordConsoleChannelFilters)

`{"\\[\\/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+(?::[0-9]+)?\\]": ""}`

Hide ip addresses from the discord console

#### [Experiment_WebhookChatMessageDelivery](https://docs.discordsrv.com/config/#Experiment_WebhookChatMessageDelivery)

`true`

### messages.yml

#### [DiscordChatChannelServerStartupMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerStartupMessage)

`""`

Disable server startup messages

#### [DiscordChatChannelServerShutdownMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerShutdownMessage)

`""`

Disable server shutdown messages

#### [ServerWatchdogMessage](https://docs.discordsrv.com/messages/#ServerWatchdogMessage)

`<t:%timestamp%:R> <@${CFG_DISCORDSRV_USERID}>, the server hasn't ticked in %timeout% seconds :fire::bangbang:`

Send server watchdog message to a custom userid

## MyWorlds

### [config.yml](https://wiki.traincarts.net/p/MyWorlds/Configuration)

#### useWorldInventories

`true`

Make all worlds hold their own inventory state. This is done to later [merge world inventories](https://wiki.traincarts.net/p/MyWorlds/SeperateInventories#Configuration).

#### mainWorld

`lobby`

### defaultproperties.yml

#### keepSpawnLoaded

`false`

Don't waste memory keeping spawn areas loaded

#### rememberlastplayerpos

`true`

Most of the time we want to remember the player location

## PaperMC

### paper-global.yml

#### [timings.enabled](https://docs.papermc.io/paper/reference/global-configuration#timings)

`false`

Use spark instead of timings for performance profiling

### paper-world-defaults.yml

#### [anticheat.anti-xray.enabled](https://docs.papermc.io/paper/reference/world-configuration#enabled)

`true`
