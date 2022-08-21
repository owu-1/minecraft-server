package io.github.owu1;

import com.velocitypowered.api.proxy.ProxyServer;
import com.velocitypowered.api.proxy.server.RegisteredServer;
import com.velocitypowered.api.proxy.server.ServerInfo;
import software.amazon.awssdk.services.autoscaling.AutoScalingClient;
import software.amazon.awssdk.services.autoscaling.model.*;
import software.amazon.awssdk.services.ec2.Ec2Client;
import org.slf4j.Logger;
import software.amazon.awssdk.services.ec2.model.Instance;

import java.net.InetSocketAddress;
import java.util.Optional;

public class AWS {
    private final ProxyServer proxyServer;
    private final Logger logger;
    private final Ec2Client ec2Client;
    private final AutoScalingClient autoScalingClient;
    private final String autoScalingGroupName;
    private boolean serverRequested;

    public AWS(ProxyServer proxyServer, Logger logger, String autoScalingGroupName) {
        this.proxyServer = proxyServer;
        this.logger = logger;
        this.ec2Client = Ec2Client.create();
        this.autoScalingClient = AutoScalingClient.create();
        this.autoScalingGroupName = autoScalingGroupName;
        this.serverRequested = false;
    }

    public RegisteredServer getServer() throws Exception {
        Optional<RegisteredServer> existingServer = proxyServer.getServer("minecraft");
        if (existingServer.isPresent()) {
            return existingServer.get();
        } else if (serverRequested) {
            throw new Exception("Server has already been requested. Hold on");
        } else {
            serverRequested = true;
            createServer();
            return proxyServer.getServer("minecraft").get();
        }
    }

    private void createServer() throws Exception {
        String ip = requestInstance();
        ServerInfo serverInfo = new ServerInfo("minecraft", new InetSocketAddress(ip, 25565));
        proxyServer.registerServer(serverInfo);
    }

    private String requestInstance() throws Exception {
        autoScalingClient.setDesiredCapacity(r -> r.autoScalingGroupName(autoScalingGroupName).desiredCapacity(1));
        String instanceId = waitUntilInstanceCreated();
        return getInstance(instanceId).publicIpAddress();
    }

    private String waitUntilInstanceCreated() throws Exception {
        for (int i = 0; i < 5; i++) {
            AutoScalingGroup asg = getAutoScalingGroup();

            if (!asg.instances().isEmpty())
                return asg.instances().get(0).instanceId();

            logger.info("No response, waiting 5 seconds");
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

        throw new Exception("Instance not ready in 5 retries");
    }

    private AutoScalingGroup getAutoScalingGroup() {
        return autoScalingClient.describeAutoScalingGroups(
                r -> r.autoScalingGroupNames(autoScalingGroupName)).autoScalingGroups().get(0);
    }

    private Instance getInstance(String instanceId) {
        return ec2Client.describeInstances(r -> r.instanceIds(instanceId))
                .reservations().get(0)
                .instances().get(0);
    }
}
