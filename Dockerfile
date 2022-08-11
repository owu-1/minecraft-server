FROM eclipse-temurin:17-jre-alpine

WORKDIR /tmp/papermc

# Download packages for build
RUN apk add \
    curl \
    jq

# Download PaperMC and plugins
RUN minecraft_version=$(curl https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]') && \
    papermc_all_builds=$(curl https://api.papermc.io/v2/projects/paper/versions/${minecraft_version}/builds) && \
    papermc_build_id=$(echo ${papermc_all_builds} | jq '.builds[-1].build') && \
    papermc_build_filename=$(echo ${papermc_all_builds} | jq -r '.builds[-1].downloads.application.name') && \
    curl -o paperclip.jar \
        https://api.papermc.io/v2/projects/paper/versions/${minecraft_version}/builds/${papermc_build_id}/downloads/${papermc_build_filename} && \

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

# Generate patched server and configs
COPY start.sh /tmp/papermc
RUN echo "eula=true" > eula.txt && \
    chmod u+x start.sh && \
    echo "stop" | MEMORY=1G ./start.sh

# Modify configs
COPY config/ /tmp/config
# Git diff all config files, then replace
