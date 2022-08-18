package io.github.owu1;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.autoscaling.AutoScalingClient;
import software.amazon.awssdk.services.autoscaling.model.DescribeAutoScalingGroupsRequest;
import software.amazon.awssdk.services.autoscaling.model.DescribeAutoScalingGroupsResponse;
import software.amazon.awssdk.services.autoscaling.model.SetDesiredCapacityRequest;
import software.amazon.awssdk.services.ec2.Ec2Client;
import org.slf4j.Logger;
import software.amazon.awssdk.services.ec2.model.DescribeInstancesRequest;

public class AWS {
    private final Ec2Client ec2Client;
    private final AutoScalingClient autoScalingClient;
    private final Logger logger;
    private boolean serverStarted;
    private final String autoScalingGroupName;

    public AWS(Region region, String autoScalingGroupName, Logger logger) {
        this.ec2Client = Ec2Client.builder().region(region).build();
        this.autoScalingClient = AutoScalingClient.builder().region(region).build();
        this.autoScalingGroupName = autoScalingGroupName;
        this.logger = logger;
        this.serverStarted = false;
    }

    public String startServer() throws Exception {
        if (serverStarted) {
            throw new Exception("Server already started");
        }
        serverStarted = true;

        requestInstance();
        logger.info("Requested instance");
        waitForUp();
        String instanceId = getInstanceId();
        logger.info("Instance {} running", instanceId);
        return getIp(instanceId);
    }

    private void waitForUp() {
        DescribeAutoScalingGroupsRequest request = DescribeAutoScalingGroupsRequest.builder()
                .autoScalingGroupNames(autoScalingGroupName)
                .build();
        autoScalingClient.waiter().waitUntilGroupInService(request);
    }

    private void requestInstance() {
        SetDesiredCapacityRequest request = SetDesiredCapacityRequest.builder()
                .autoScalingGroupName(autoScalingGroupName)
                .desiredCapacity(1)
                .build();
        autoScalingClient.setDesiredCapacity(request);
    }

    private String getInstanceId() {
        DescribeAutoScalingGroupsRequest request = DescribeAutoScalingGroupsRequest.builder()
                .autoScalingGroupNames(autoScalingGroupName)
                .build();
        DescribeAutoScalingGroupsResponse response = autoScalingClient.describeAutoScalingGroups(request);
        return response.autoScalingGroups().get(0).instances().get(0).instanceId();
    }

    private String getIp(String instanceId) {
        DescribeInstancesRequest request = DescribeInstancesRequest.builder()
                .instanceIds(instanceId)
                .build();
        return ec2Client.describeInstances(request)
                .reservations().get(0)
                .instances().get(0)
                .publicIpAddress();
    }
}
