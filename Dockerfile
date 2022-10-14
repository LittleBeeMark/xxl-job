# Docker image for multi stage build
# VERSION 0.0.1
# Author: bolingcavalry

### 第一阶段，用maven镜像进行编译
FROM maven:3.6.3 AS compile_stage

####################定义环境变量 start####################
#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME xxl-job
#定义工作目录
ENV WORK_PATH /usr/src/$PROJECT_NAME

####################定义环境变量 start####################
#将源码复制到当前目录
COPY . $WORK_PATH

#编译构建
RUN cd $WORK_PATH && mvn clean package -Dmaven.test.skip

### 第二阶段，用第一阶段的jar和jre镜像合成一个小体积的镜像
FROM openjdk:8-jre-slim

####################定义环境变量 start####################
#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME xxl-job/xxl-job-admin
#定义工作目录
ENV WORK_PATH /usr/src/$PROJECT_NAME

####################定义环境变量 start####################
MAINTAINER xuxueli
#工作目录是/opt
WORKDIR /opt

#从名为compile_stage的stage复制构建结果到工作目录
COPY --from=compile_stage $WORK_PATH/target/xxl-job-admin-*.jar  /opt/app.jar

ENV PARAMS=""

ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



#启动应用
ENTRYPOINT ["/usr/local/openjdk-8/bin/java","-jar","/opt/app.jar"]
