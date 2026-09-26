# Stage 1: Build the Java application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build the WAR file, skipping tests to speed up deployment
RUN mvn clean package -DskipTests

# Stage 2: Deploy the WAR file to Apache Tomcat 10.1
FROM tomcat:10.1-jdk17
# Remove Tomcat's default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy our compiled WAR file and name it ROOT.war so it serves directly at the domain root (/)
COPY --from=build /app/target/placement-manager.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
