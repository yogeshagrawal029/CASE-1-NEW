# Use Java 17 runtime base image
FROM eclipse-temurin:17-jre-alpine

# Define the path to the built JAR file (change if needed)
ARG artifact=target/springboot-demo-1.0.0.jar

# Set the working directory inside the container
WORKDIR /opt/app

# Copy the JAR file into the image
COPY ${artifact} app.jar

# Set the default command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
