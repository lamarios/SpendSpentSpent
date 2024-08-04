FROM cirrusci/flutter:stable as frontend
ADD ./ /app
WORKDIR /app/src/main/app

RUN cd /app/src/main/app \
    && flutter pub get \
    &&  flutter build web --release \
    &&  cp -Rf build/web ../resources/public


FROM maven:3.8-openjdk-17 as maven
ADD ./ /app
COPY --from=frontend /app/src/main/resources/public/ /app/src/main/resources/public/
RUN ls /app/src/main/resources
WORKDIR  /app
#salt and db path is only for the unit tests
RUN mvn clean install -Dmaven.repo.local=./m2 -Dspring.main.allow-circular-references=true



FROM amazoncorretto:21

RUN mkdir /app && mkdir /config


COPY --from=maven /app/target/SpendSpentSpent-*.jar  /app/SpendSpentSpent.jar

ADD docker/run.sh /run.sh

EXPOSE 9001

VOLUME "/config"

RUN chmod +x /run.sh

CMD "./run.sh"
