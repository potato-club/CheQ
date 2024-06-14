FROM ubuntu AS base

#RUN apt-get update && apt-get install -y \
#    redis-server \
#    && rm -rf /var/lib/apt/lists/*

FROM redis:7.2.4-alpine3.19
EXPOSE 6379
CMD ["redis-server"]

#CMD ["redis-server", "--daemonize", "yes"]

FROM openjdk:17-jdk AS build

COPY --from=base /usr/bin/redis-server /usr/bin/redis-server

WORKDIR /app
COPY . /app
RUN chmod +x ./gradlew

RUN microdnf install -y findutils
RUN ./gradlew bootJar

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/build/libs/cheq-0.0.2-SNAPSHOT.jar"]