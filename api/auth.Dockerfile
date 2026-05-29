FROM maven:3-eclipse-temurin-25 AS builder
WORKDIR /workspace
COPY account-lib/pom.xml account-lib/pom.xml
COPY account-lib/src account-lib/src
COPY auth/pom.xml auth/pom.xml
COPY auth/src auth/src
COPY auth-service/pom.xml auth-service/pom.xml
COPY auth-service/src auth-service/src
RUN mvn -f account-lib/pom.xml clean install -DskipTests && \
    mvn -f auth/pom.xml clean install -DskipTests && \
    mvn -f auth-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=builder /workspace/auth-service/target/auth-service-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
