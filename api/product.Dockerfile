FROM maven:3-eclipse-temurin-25 AS builder
WORKDIR /workspace
COPY product-service/pom.xml pom.xml
COPY product-service/src src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=builder /workspace/target/product-service-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
