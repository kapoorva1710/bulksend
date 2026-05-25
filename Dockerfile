FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
# Copy pom.xml first for dependency caching
COPY bulksender/pom.xml ./pom.xml
RUN mvn dependency:go-offline -B
# Copy source and build
COPY bulksender/src ./src
RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Railway injects PORT env var automatically
EXPOSE 8080

ENTRYPOINT ["java", \
  "-Dserver.port=${PORT:8080}", \
  "-jar", "app.jar"]
