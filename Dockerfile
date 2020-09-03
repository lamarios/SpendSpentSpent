FROM node:10 as frontend
ADD ./ /app
WORKDIR /app/src/main/web

RUN npm install && npm run build


FROM maven:3.6-jdk-14 as maven
ADD ./ /app
COPY --from=frontend /app/src/main/resources/web/ /app/src/main/resources/web/
RUN ls /app/src/main/resources
WORKDIR  /app
RUN mvn clean install



FROM openjdk:14

RUN mkdir /app && mkdir /config


COPY --from=maven /app/target/SpendSpentSpent-*.jar  /app/SpendSpentSpent.jar

ADD docker/run.sh /run.sh

EXPOSE 9001

VOLUME "/config"

RUN chmod +x /run.sh

CMD "./run.sh"
