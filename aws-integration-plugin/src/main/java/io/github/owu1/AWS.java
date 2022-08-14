package io.github.owu1;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.ec2.model.NetworkInterface;
import software.amazon.awssdk.services.ecs.EcsClient;
import software.amazon.awssdk.services.ecs.model.*;
import software.amazon.awssdk.services.ec2.Ec2ClientBuilder;
import software.amazon.awssdk.services.ec2.model.*;
import org.slf4j.Logger;
import java.util.List;

public class AWS {
    private final EcsClient ecsClient;
    private final Ec2Client ec2Client;
    private final String clusterName;
    private final String serviceName;
    private final Logger logger;

    public AWS(Region region, String clusterName, String serviceName, Logger logger) {
        this.ecsClient = EcsClient.builder().region(region).build();
        this.ec2Client = Ec2Client.builder().region(region).build();
        this.clusterName = clusterName;
        this.serviceName = serviceName;
        this.logger = logger;
    }

    public String startServer() {
        requestTask();
        waitForTaskRunning();
        String taskArn = getTaskArn();
        String networkInterfaceId = getNetworkInterfaceId(taskArn);

        return getIp(networkInterfaceId);
    }

    private void requestTask() {
        UpdateServiceRequest request = UpdateServiceRequest.builder()
                .cluster(clusterName)
                .service(serviceName)
                .desiredCount(1)
                .build();
        ecsClient.updateService(request);
    }

    private void waitForTaskRunning() {
        DescribeServicesRequest request = DescribeServicesRequest.builder()
                .cluster(clusterName)
                .services(serviceName)
                .build();
        ecsClient.waiter().waitUntilServicesStable(request);
    }

    private String getTaskArn() {
        ListTasksRequest request = ListTasksRequest.builder()
                .cluster(clusterName)
                .serviceName(serviceName)
                .build();
        ListTasksResponse response = ecsClient.listTasks(request);
        return response.taskArns().get(0);
    }

    private String getNetworkInterfaceId(String taskArn) {
        DescribeTasksRequest request = DescribeTasksRequest.builder()
                .cluster(clusterName)
                .tasks(taskArn)
                .build();
        DescribeTasksResponse response = ecsClient.describeTasks(request);

        Task task = response.tasks().get(0);
        Attachment elasticNetworkInterface = task.attachments().stream()
                .filter(attachment -> attachment.type().equals("ElasticNetworkInterface"))
                .findFirst()
                .get();
        return elasticNetworkInterface.details().stream()
                .filter(detail -> detail.name().equals("networkInterfaceId"))
                .findFirst()
                .get()
                .value();
    }

    private String getIp(String networkInterfaceId) {
        DescribeNetworkInterfacesRequest request = DescribeNetworkInterfacesRequest.builder()
                .networkInterfaceIds(networkInterfaceId)
                .build();
        DescribeNetworkInterfacesResponse response = ec2Client.describeNetworkInterfaces(request);
        return response.networkInterfaces().get(0).association().publicIp();
    }
}
