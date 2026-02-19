# -------- Builder --------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests


# -------- Runtime (Distroless) --------
FROM gcr.io/distroless/java17-debian11
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
USER nonroot
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
