FROM eclipse-temurin:17-jre-alpine

ARG AIKAR_FLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
WORKDIR /tmp/papermc

# Download jars
RUN apk add jq curl && \
    # PaperMC
    minecraft_version=$(curl https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]') && \
    papermc_all_builds=$(curl https://api.papermc.io/v2/projects/paper/versions/${minecraft_version}/builds) && \
    papermc_build_id=$(echo ${papermc_all_builds} | jq '.builds[-1].build') && \
    papermc_build_filename=$(echo ${papermc_all_builds} | jq -r '.builds[-1].downloads.application.name') && \
    curl -o ${papermc_build_filename} \
        https://api.papermc.io/v2/projects/paper/versions/${minecraft_version}/builds/${papermc_build_id}/downloads/${papermc_build_filename} && \
    ln ${papermc_build_filename} paperclip.jar && \

    # Plugins
    mkdir plugins && \
    cd plugins && \
    # CoreProtect
    curl -OL $(curl https://api.github.com/repos/PlayPro/CoreProtect/releases/latest | jq -r '.assets[0].browser_download_url') && \
    # squaremap
    curl -O https://jenkins.jpenilla.xyz/job/squaremap/lastSuccessfulBuild/artifact/$(curl https://jenkins.jpenilla.xyz/job/squaremap/lastSuccessfulBuild/api/json | jq -r '.artifacts | .[] | select(.fileName|test("paper")).relativePath') && \
    # DiscordSRV
    curl -OJ https://download.discordsrv.com/snapshot && \
    # spark
    curl -O https://ci.lucko.me/job/spark/lastSuccessfulBuild/artifact/$(curl https://ci.lucko.me/job/spark/lastSuccessfulBuild/api/json | jq -r '.artifacts | .[] | select(.fileName|test("bukkit")).relativePath')

# Run PaperMC
RUN echo "eula=true" > eula.txt && \
    echo "stop" | java -Xms1G -Xmx1G ${AIKAR_FLAGS} -jar paperclip.jar
