#!/bin/bash

#License Agreement
#By using this image, you agree the Oracle Java JDK License. 
#This image contains Oracle JDK 8. You must accept the Oracle Binary Code License Agreement for Java SE to use this image.

#Create directories used as bind mounts volumes on host if they don't exist as current $USER on host in order to have write
#permissions in Docker container.
ECLIPSE_DIR=${PWD}/.eclipse     # on host machine
ECLIPSE_WORKSPACE_DIR=${PWD}/eclipse-workspace  #on host machine
MAVEN_DIR=${HOME}/.m2 #on host machine
DOCKER_ECLIPSE_WORKSPACE_DIR=/home/mvpjava/Documents/workspace-spring-tool-suite-4-4.1.2.RELEASE

[ ! -d $ECLIPSE_DIR ] && mkdir -p $ECLIPSE_DIR
[ ! -d $ECLIPSE_WORKSPACE_DIR ] && mkdir -p $ECLIPSE_WORKSPACE_DIR
[ ! -d $MAVEN_DIR ] && mkdir -p $MAVEN_DIR

docker container run -d --rm \
-e DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/.Xauthority:/home/$USER/.Xauthority \
-v $ECLIPSE_WORKSPACE_DIR:$DOCKER_ECLIPSE_WORKSPACE_DIR \
-v $MAVEN_DIR:$MAVEN_DIR \
-w $DOCKER_ECLIPSE_WORKSPACE_DIR \
-h sts4-jdk8 \
--name spring-sts4-ide-jdk8 \
mvpjava/spring-sts4-ide:jdk8
