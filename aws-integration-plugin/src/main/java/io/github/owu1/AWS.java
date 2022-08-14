package io.github.owu1;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.ecs.EcsClient;
import software.amazon.awssdk.services.ecs.model.*;
import software.amazon.awssdk.services.ec2.Ec2ClientBuilder;
import software.amazon.awssdk.services.ec2.model.*;
import org.slf4j.Logger;
import java.util.List;

public class AWS {
    private final EcsClient ecsClient;
    private final String clusterName;
    private final String serviceName;
    private final Logger logger;

    public AWS(Region region, String clusterName, String serviceName, Logger logger) {
        this.ecsClient = EcsClient.builder().region(region).build();
        this.clusterName = clusterName;
        this.serviceName = serviceName;
        this.logger = logger;
    }

    public void startServer() {
        try {
            logger.info("Updating service");
            requestTask();
            logger.info("Waiting for task status running");
            waitForTaskRunning();
            logger.info("Task is now running");
            String taskArn = getTaskArn();
            logger.info("Task Arn: {}", taskArn);
            String networkInterfaceId = getNetworkInterfaceId(taskArn);
            logger.info("Network Interface ID: {}", networkInterfaceId);

        } catch (EcsException e) {
            logger.error(e.awsErrorDetails().errorMessage());
        }
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
        Ec2Client ec2Client = Ec2ClientBuilder.standard
        return "yes";
    }
}
