FROM mvpjava/ubuntu-x11

MAINTAINER Andy Luis "MVP Java - mvpjava.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils &&\
    apt-get install -y libcanberra-gtk3-module && \
    apt-get install -y curl wget git vim && \
    apt-get clean all && \
    sudo rm -rf /tmp/* && \
    sudo rm -rf /var/cache/apk/*


###################################
#### Install Java 8
###################################
#### ---------------------------------------------------------------
#### ---- Change below when upgrading version ----
#### ---------------------------------------------------------------
## https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-linux-x64.tar.gz
ARG JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION:-8}
ARG JAVA_UPDATE_VERSION=${JAVA_UPDATE_VERSION:-202}
ARG JAVA_BUILD_NUMBER=${JAVA_BUILD_NUMBER:-08}
ARG JAVA_DOWNLOAD_TOKEN=${JAVA_DOWNLOAD_TOKEN:-1961070e4c9b4e26a04e7f5a083f551e}

#### ---------------------------------------------------------------
#### ---- Don't change below unless you know what you are doing ----
#### ---------------------------------------------------------------
ARG UPDATE_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}
ARG BUILD_VERSION=b${JAVA_BUILD_NUMBER}
ENV INSTALL_DIR=${INSTALL_DIR:-/usr}
ENV JAVA_HOME_ACTUAL=${INSTALL_DIR}/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV JAVA_HOME=${INSTALL_DIR}/java

ENV PATH=$PATH:${JAVA_HOME}/bin

WORKDIR ${INSTALL_DIR}

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD_VERSION}/${JAVA_DOWNLOAD_TOKEN}/jdk-${UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C ${INSTALL_DIR}
RUN ls -al ${INSTALL_DIR} && \
  ln -s ${JAVA_HOME_ACTUAL} ${JAVA_HOME} && \
  rm -rf ${JAVA_HOME}/man

############################
#### --- JAVA_HOME --- #####
############################
ENV JAVA_HOME=$INSTALL_DIR/java

WORKDIR /opt
RUN wget -c download.springsource.com/release/STS4/4.1.2.RELEASE/dist/e4.10/spring-tool-suite-4-4.1.2.RELEASE-e4.10.0-linux.gtk.x86_64.tar.gz && \
     sudo tar xfz /opt/spring-tool-suite-4-4.1.2.RELEASE-e4.10.0-linux.gtk.x86_64.tar.gz  && \
     sudo rm spring-tool-suite-4-4.1.2.RELEASE-e4.10.0-linux.gtk.x86_64.tar.gz

#### Install Maven 3
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.6.0}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH $PATH:${MAVEN_HOME}/bin
RUN sudo curl -sL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
&& ln -s ${MAVEN_HOME} /usr/maven


ENV USER=mvpjava
ENV HOME=/home/mvpjava
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace
ENV USER_ID=1000
ENV GROUP_ID=1000

RUN useradd ${USER} && \
    export uid=${USER_ID} gid=${GROUP_ID} && \
    mkdir -m 700  -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} &&\
    #chown ${USER}:${USER} ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} &&\
    chown -R ${USER}:${USER} ${HOME} &&\
    ls -al ${HOME} &&\
    mkdir -p /etc/sudoers.d && \
    echo "${USER}:x:${USER_ID}:${GROUP_ID}:${USER},,,:${HOME}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${USER_ID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} 

ENV DEBIAN_FRONTEND teletype

USER ${USER}
WORKDIR ${ECLIPSE_WORKSPACE}
CMD ["/opt/sts-4.1.2.RELEASE/SpringToolSuite4"]
