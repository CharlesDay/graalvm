#FROM ghcr.io/graalvm/graalvm-ce:ol7-java17-22.3.3 AS build
#
#RUN yum update -y && \
#    yum install -y gcc glibc-devel zlib-devel wget unzip zip tar
#
## Maven
#RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz \
#    && tar -xzf apache-maven-3.8.6-bin.tar.gz -C /opt \
#    && ln -s /opt/apache-maven-3.8.6 /opt/maven \
#    && ln -s /opt/maven/bin/mvn /usr/bin/mvn
#
#WORKDIR /workspace
#COPY . .
#
#RUN mvn clean package -Pnative -DskipTests
#
## ---- Runtime Stage ----
#FROM gcr.io/distroless/static-debian11
#
#WORKDIR /app
#COPY --from=build /workspace/target/graalvm-native-app /app/app
#
#EXPOSE 8080
#ENTRYPOINT ["/app/app"]
# Stage 1: Build with Maven and GraalVM
FROM ghcr.io/graalvm/graalvm-ce:ol8-java17-22.3.3 AS build

WORKDIR /workspace

# Install wget and tar
RUN microdnf install -y wget tar gzip

# Install Maven manually
RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz \
 && tar xzf apache-maven-3.8.7-bin.tar.gz -C /opt \
 && ln -s /opt/apache-maven-3.8.7 /opt/maven \
 && ln -s /opt/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

COPY . .

# Disable test compilation and build native image
RUN mvn -Pnative native:compile -Dmaven.test.skip=true

# Stage 2: Distroless runtime with native binary
FROM busybox:glibc
WORKDIR /app
COPY --from=build /workspace/target/graalvm-example /app/graalvm-example
EXPOSE 8080
ENTRYPOINT ["./graalvm-example"]
