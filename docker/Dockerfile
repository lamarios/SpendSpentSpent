FROM openjdk:10-jre-slim

RUN mkdir /app && mkdir /config

ARG SSS_VERSION

ADD SpendSpentSpent-$SSS_VERSION.jar /app/SpendSpentSpent.jar

ADD run.sh /run.sh

EXPOSE 9001

VOLUME "/config"

RUN chmod +x /run.sh

CMD "./run.sh"