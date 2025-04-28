# Step 1: Use Maven to build the project
FROM maven:3.8.4-openjdk-17 AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy the Maven `pom.xml` and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Step 4: Copy the application source code
COPY src ./src

# Step 5: Build the application using Maven
RUN mvn clean package -DskipTests  # Adjust based on your Maven settings

# Step 6: Use OpenJDK to run the application
FROM openjdk:17-jdk-slim

# Step 7: Set the working directory for the app
WORKDIR /app

# Step 8: Copy the packaged JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Step 9: Expose the port your app will run on
EXPOSE 8080  # Adjust the port if your application uses a different port

# Step 10: Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
