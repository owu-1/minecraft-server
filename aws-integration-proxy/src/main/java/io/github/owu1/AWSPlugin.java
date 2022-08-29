package io.github.owu1;

import com.google.inject.Inject;
import com.velocitypowered.api.event.Subscribe;
import com.velocitypowered.api.event.player.PlayerChooseInitialServerEvent;
import com.velocitypowered.api.plugin.Plugin;
import com.velocitypowered.api.proxy.ProxyServer;
import com.velocitypowered.api.proxy.server.RegisteredServer;
import com.velocitypowered.api.proxy.server.ServerInfo;
import org.slf4j.Logger;
import software.amazon.awssdk.services.autoscaling.model.AutoScalingException;
import software.amazon.awssdk.services.ec2.model.Ec2Exception;

import java.net.InetSocketAddress;

@Plugin(id = "awsintegration", name = "AWS Integration", version = "0.1.0-SNAPSHOT",
        url = "https://github.com/owu-1/minecraft-image", description = "Use AWS resources", authors = {"owu"})
public class AWSPlugin {
    private final ProxyServer server;
    private final Logger logger;
//    private final AWS aws;

    @Inject
    public AWSPlugin(ProxyServer server, Logger logger) {
        this.server = server;
        this.logger = logger;
//        aws = new AWS(server, logger, "minecraft");
    }

    @Subscribe
    public void onPlayerChooseInitialServer(PlayerChooseInitialServerEvent event) {
//        try {
//            event.setInitialServer(aws.getServer());
//        } catch (Ec2Exception | AutoScalingException e) {
//            logger.error(e.awsErrorDetails().errorMessage());
//        } catch (Exception e) {
//            logger.error(e.getMessage());
//        }
        server.unregisterServer(new ServerInfo("minecraft", new InetSocketAddress("127.0.0.1", 25565)));

        ServerInfo serverInfo = new ServerInfo("minecraft", new InetSocketAddress("127.0.0.1", 25564));
        server.registerServer(serverInfo);

    }
}