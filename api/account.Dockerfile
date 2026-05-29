FROM maven:3-eclipse-temurin-25 AS builder
WORKDIR /workspace
COPY account-lib/pom.xml account-lib/pom.xml
COPY account-lib/src account-lib/src
COPY account/pom.xml account/pom.xml
COPY account/src account/src
RUN mvn -f account-lib/pom.xml clean install -DskipTests && \
    mvn -f account/pom.xml clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=builder /workspace/account/target/account-service-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
