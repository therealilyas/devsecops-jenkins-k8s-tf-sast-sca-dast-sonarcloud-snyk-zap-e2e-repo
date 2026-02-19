FROM maven:3.8.8-eclipse-temurin-8 AS builder
WORKDIR /usr/src/easybuggy
COPY . .
RUN mvn -B -DskipTests package

# -------- Runtime stage --------
FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=builder /usr/src/easybuggy/target/easybuggy.jar app.jar

CMD ["java", "-Xmx256m", "-ea", "-jar", "app.jar"]
