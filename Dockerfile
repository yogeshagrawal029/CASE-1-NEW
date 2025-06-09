FROM adoptopenjdk/openjdk11:alpine-jre
 

# Simply the artifact path
ARG artifact=target/springboot-demo-1.0.0.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]
