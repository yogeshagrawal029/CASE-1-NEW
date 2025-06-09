FROM adoptopenjdk/openjdk11:alpine-jre
 

# Simply the artifact path
ARG artifact=target/case1.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]
