# Use OpenJDK 17 as base image
FROM openjdk:17

# Expose port 8080
EXPOSE 8080

# Create a directory for the application
RUN mkdir /app

# Copy the packaged jar file into the container
COPY target/*.jar /app/spring-petclinic.jar

# Set the working directory
WORKDIR /app

# Command to run the application
CMD ["java", "-jar", "spring-petclinic.jar"]