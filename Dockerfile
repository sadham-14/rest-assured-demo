# === Stage 1: Build the project ===
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the project (skip test execution during build)
RUN mvn clean install -DskipTests

# === Stage 2: Run tests ===
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install curl (optional, for API testing/debugging)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy the built project from builder stage
COPY --from=builder /app /app

# Run Rest Assured tests
CMD ["mvn", "test"]
