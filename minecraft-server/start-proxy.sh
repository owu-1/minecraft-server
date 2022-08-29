#!/bin/bash
VELOCITY_FLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15"
java -Xms$MEMORY -Xmx$MEMORY $VELOCITY_FLAGS -jar velocity.jar
