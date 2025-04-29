# Step 1: Use Maven with Java 21 to build the project
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy the Maven `pom.xml` and download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# Step 4: Copy the application source code
COPY src ./src

# Step 5: Build the application using Maven
RUN mvn clean package -DskipTests

# Step 6: Use OpenJDK 21 to run the application
FROM eclipse-temurin:21-jdk-jammy

# Step 7: Set the working directory
WORKDIR /app

# Step 8: Copy the packaged JAR file
COPY --from=build /app/target/*.jar app.jar

# Step 9: Expose the port
EXPOSE 8080

# Step 10: Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
