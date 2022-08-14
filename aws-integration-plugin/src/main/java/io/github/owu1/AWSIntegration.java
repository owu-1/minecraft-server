package io.github.owu1;

import com.google.inject.Inject;
import com.velocitypowered.api.plugin.Plugin;
import com.velocitypowered.api.proxy.ProxyServer;
import org.slf4j.Logger;
import software.amazon.awssdk.regions.Region;

@Plugin(id = "awsintegration", name = "AWS Integration", version = "0.1.0-SNAPSHOT",
        url = "https://github.com/owu-1/minecraft-image", description = "Use AWS resources", authors = {"owu"})
public class AWSIntegration {
    private final ProxyServer server;
    private final Logger logger;

    @Inject
    public AWSIntegration(ProxyServer server, Logger logger) {
        this.server = server;
        this.logger = logger;

        Region region = Region.AP_SOUTHEAST_2;
        String clusterName = "minecraft-cluster3";
        String serviceName = "minecraft-service";

        AWS aws = new AWS(region, clusterName, serviceName, logger);
        aws.startServer();
    }


}