FROM openjdk:17-jdk AS build

RUN apt-get update && apt-get install -y redis-server

WORKDIR /app
COPY . /app
RUN chmod +x ./gradlew

RUN microdnf install -y findutils
RUN ./gradlew bootJar

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/build/libs/cheq-0.0.2-SNAPSHOT.jar"]

