FROM maven:3-eclipse-temurin-25 AS builder
WORKDIR /workspace
COPY gateway-service/pom.xml pom.xml
COPY gateway-service/src src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=builder /workspace/target/gateway-service-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
