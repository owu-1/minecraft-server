package io.github.owu1;

import com.google.inject.Inject;
import com.velocitypowered.api.event.Subscribe;
import com.velocitypowered.api.event.player.PlayerChooseInitialServerEvent;
import com.velocitypowered.api.plugin.Plugin;
import com.velocitypowered.api.proxy.ProxyServer;
import com.velocitypowered.api.proxy.server.ServerInfo;
import org.slf4j.Logger;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.ec2.model.Ec2Exception;
import software.amazon.awssdk.services.ecs.model.EcsException;
import java.net.InetSocketAddress;

@Plugin(id = "awsintegration", name = "AWS Integration", version = "0.1.0-SNAPSHOT",
        url = "https://github.com/owu-1/minecraft-image", description = "Use AWS resources", authors = {"owu"})
public class AWSIntegrationPlugin {
    private final ProxyServer server;
    private final Logger logger;
    private final AWS aws;

    @Inject
    public AWSIntegrationPlugin(ProxyServer server, Logger logger) {
        this.server = server;
        this.logger = logger;

        Region region = Region.AP_SOUTHEAST_2;
        String clusterName = "minecraft-cluster3";
        String serviceName = "minecraft-service";

        aws = new AWS(region, clusterName, serviceName, logger);
    }

    @Subscribe
    public void onPlayerChooseInitialServer(PlayerChooseInitialServerEvent event) {
        try {
            logger.info("Starting AWS");
            String serverIp = aws.startServer();
            logger.info("AWS IP: {}", serverIp);
            ServerInfo serverInfo = new ServerInfo("AWS", new InetSocketAddress(serverIp, 25565));
            event.setInitialServer(server.createRawRegisteredServer(serverInfo));
        } catch (EcsException | Ec2Exception e) {
            logger.error(e.awsErrorDetails().errorMessage());
        }
    }
}