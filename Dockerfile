# Dockerfile for native GraalVM Spring Boot app
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the native binary
COPY target/graalvm-example .

# Expose the port your app uses (change if needed)
EXPOSE 8080

# Run the binary
CMD ["./graalvm-example"]
