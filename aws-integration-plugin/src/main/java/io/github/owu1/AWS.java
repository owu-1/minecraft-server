package io.github.owu1;

import com.velocitypowered.api.proxy.ProxyServer;
import com.velocitypowered.api.proxy.server.RegisteredServer;
import com.velocitypowered.api.proxy.server.ServerInfo;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.autoscaling.AutoScalingClient;
import software.amazon.awssdk.services.autoscaling.model.*;
import software.amazon.awssdk.services.ec2.Ec2Client;
import org.slf4j.Logger;
import software.amazon.awssdk.services.ec2.model.DescribeInstancesRequest;

import java.net.InetSocketAddress;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class AWS {
    private final ProxyServer proxyServer;
    private final Logger logger;
    private final Ec2Client ec2Client;
    private final AutoScalingClient autoScalingClient;
    private final String autoScalingGroupName;

    public AWS(ProxyServer proxyServer, Logger logger, String autoScalingGroupName) {
        this.proxyServer = proxyServer;
        this.logger = logger;
        this.ec2Client = Ec2Client.create();
        this.autoScalingClient = AutoScalingClient.create();
        this.autoScalingGroupName = autoScalingGroupName;
    }

    public RegisteredServer getServer() throws Exception {
        if (getServerState() == ServerState.DOWN) {
            requestInstance();
            waitUntilInstanceReady();
        }

        String ip = getIp();

    }

    private void waitForPing(String ip) {
        ServerInfo serverInfo = new ServerInfo("AWS", new InetSocketAddress(ip, 25565));
        for (int i = 0; i < 15; i++) {
            try {
                proxyServer.createRawRegisteredServer(serverInfo).ping().get(2, TimeUnit.SECONDS);
                return;
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            } catch (ExecutionException e) {
                logger.info("Execution Exception, retrying");
            } catch (TimeoutException e) {
                logger.info("Timed out after 2 seconds, retrying");
            }
        }
    }

    private ServerState getServerState() throws Exception {
        AutoScalingGroup autoScalingGroup = autoScalingClient.describeAutoScalingGroups(
                r -> r.autoScalingGroupNames(autoScalingGroupName)).autoScalingGroups().get(0);
        if (autoScalingGroup.instances().isEmpty())
            return ServerState.DOWN;

        LifecycleState lifecycleState = autoScalingGroup.instances().get(0).lifecycleState();
        switch (lifecycleState) {
            case PENDING -> {
                return ServerState.STARTING;
            }
            case IN_SERVICE -> {
                return ServerState.UP;
            }
            case TERMINATING -> {
                return ServerState.TERMINATING;
            }
            default -> {
                throw new Exception("Unknown state " + lifecycleState.toString());
            }
        }
    }

    private void requestInstance() {
        SetDesiredCapacityRequest request = SetDesiredCapacityRequest.builder()
                .autoScalingGroupName(autoScalingGroupName)
                .desiredCapacity(1)
                .build();
        autoScalingClient.setDesiredCapacity(request);
    }

    private String getIp() {
        String instanceId = autoScalingClient.describeAutoScalingGroups(r -> r.autoScalingGroupNames(autoScalingGroupName))
                .autoScalingGroups().get(0)
                .instances().get(0)
                .instanceId();
        return ec2Client.describeInstances(r -> r.instanceIds(instanceId))
                .reservations().get(0)
                .instances().get(0)
                .publicIpAddress();
    }

    private void waitUntilInstanceReady() throws Exception {
        for (int i = 0; i < 5; i++) {
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

            AutoScalingGroup autoScalingGroup = autoScalingClient.describeAutoScalingGroups(
                    r -> r.autoScalingGroupNames(autoScalingGroupName)).autoScalingGroups().get(0);

            if (!autoScalingGroup.instances().isEmpty() && autoScalingGroup.instances().get(0).lifecycleState().equals(LifecycleState.IN_SERVICE))
                return;
            logger.info("{}", autoScalingGroup.instances());

            logger.info("No response, waiting 10 seconds");
        }

        throw new Exception("Instance not ready in 5 retries");
    }
}
