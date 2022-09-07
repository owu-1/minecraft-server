# Config

## Minecraft

### [server.properties](https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3)

#### motd

`${CFG_MOTD}`

## [DiscordSRV](https://docs.discordsrv.com/)

### [config.yml](https://docs.discordsrv.com/config/#configyml)

#### [BotToken](https://docs.discordsrv.com/config/#BotToken)

`${CFG_DISCORDSRV_BOT_TOKEN}`

#### [Channels](https://docs.discordsrv.com/config/#Channels)

`{"global": "${CFG_DISCORDSRV_GLOBAL_CHANNEL_ID}"}`

#### [DiscordConsoleChannelId](https://docs.discordsrv.com/config/#DiscordConsoleChannelId)

`${CFG_DISCORDSRV_CONSOLE_CHANNEL_ID}`

#### [DiscordConsoleChannelFilters](https://docs.discordsrv.com/config/#DiscordConsoleChannelFilters)

`{"\\[\\/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+(?::[0-9]+)?\\]": ""}`

Hide ip addresses from the discord console

### [messages.yml](https://docs.discordsrv.com/messages/)

#### [DiscordChatChannelServerStartupMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerStartupMessage)

`""`

Disable server startup messages

#### [DiscordChatChannelServerShutdownMessage](https://docs.discordsrv.com/messages/#DiscordChatChannelServerShutdownMessage)

`""`

Disable server shutdown messages

#### [ServerWatchdogMessage](https://docs.discordsrv.com/messages/#ServerWatchdogMessage)

`<t:%timestamp%:R> <@${CFG_DISCORDSRV_USERID}>, the server hasn't ticked in %timeout% seconds :fire::bangbang:`

Send server watchdog message to a custom userid

## [MyWorlds](https://wiki.traincarts.net/index.php/MyWorlds)

### [config.yml](https://wiki.traincarts.net/p/MyWorlds/Configuration)

#### useWorldInventories

`true`

Make all worlds hold their own inventory state. This is done to later [merge world inventories](https://wiki.traincarts.net/p/MyWorlds/SeperateInventories#Configuration).

#### mainWorld

`lobby`
