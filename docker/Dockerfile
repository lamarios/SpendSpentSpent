FROM openjdk:9-jre-slim

RUN mkdir /app && mkdir /config

ADD SpendSpentSpent.jar /app/SpendSpentSpent.jar

ADD run.sh /run.sh

EXPOSE 9001

VOLUME "/config"

RUN chmod +x /run.sh

CMD "./run.sh"