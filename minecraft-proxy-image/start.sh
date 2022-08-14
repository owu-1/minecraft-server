#!/bin/sh
RECOMMENDED_STARTUP_FLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15"
java -Xms$MEMORY -Xmx$MEMORY $RECOMMENDED_STARTUP_FLAGS -jar /data/velocity.jar
