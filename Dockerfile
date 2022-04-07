#Based on https://github.com/SuperSandro2000/docker-images/blob/master/musicbot/Dockerfile
FROM debian:stable-slim as git

RUN apt update -q
RUN apt install wget -y
RUN rm -rf /var/lib/apt/lists/*

ARG VERSION=0.3.8
RUN wget -q -O JMusicBot.jar -- https://github.com/jagrosh/MusicBot/releases/download/$VERSION/JMusicBot-$VERSION.jar

FROM openjdk:11-jre-slim

ARG VERSION

RUN export user=MusicBot \
  && groupadd -r $user && useradd -r -g $user $user

COPY --from=git [ "/JMusicBot.jar", "/JMusicBot.jar" ]

RUN ln -rs /data/config.txt /config.txt

WORKDIR /data
CMD [ "java", "-Dnogui=true", "-jar", "/JMusicBot.jar" ]
