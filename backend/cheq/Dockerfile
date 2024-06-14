FROM ubuntu AS base

RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Redis 설정 파일을 수정하여 백그라운드에서 실행되지 않도록 설정
RUN sed -i 's/daemonize yes/daemonize no/' /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]

FROM openjdk:17-jdk AS build

# Redis 바이너리와 설정 파일 복사
COPY --from=base /usr/bin/redis-server /usr/bin/redis-server
COPY --from=base /etc/redis/redis.conf /etc/redis/redis.conf

WORKDIR /app
COPY . /app
RUN chmod +x ./gradlew

RUN microdnf install -y findutils
RUN ./gradlew bootJar

# Redis를 백그라운드에서 실행하고 Java 애플리케이션을 실행
ENTRYPOINT ["sh", "-c", "redis-server /etc/redis/redis.conf & java ${JAVA_OPTS} -jar /app/build/libs/cheq-0.0.2-SNAPSHOT.jar"]

#FROM ubuntu AS base
#
#RUN apt-get update && apt-get install -y \
#    redis-server \
#    && rm -rf /var/lib/apt/lists/*
#
#CMD ["redis-server", "--daemonize", "yes"]
#
#FROM openjdk:17-jdk AS build
#
#COPY --from=base /usr/bin/redis-server /usr/bin/redis-server
#
#WORKDIR /app
#COPY . /app
#RUN chmod +x ./gradlew
#
#RUN microdnf install -y findutils
#RUN ./gradlew bootJar
#
#ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/build/libs/cheq-0.0.2-SNAPSHOT.jar"]