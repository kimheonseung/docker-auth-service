FROM alpine:3.15.4
RUN apk update && apk add git && apk add openjdk15 && apk add gradle && mkdir -p /app/tmp
WORKDIR /app
COPY ./package.sh ./tmp
COPY ./git-repo.txt ./tmp
ENV DB_NETWORK mariadb-auth-service
RUN chmod +x ./tmp/package.sh && ./tmp/package.sh
CMD ["java", "-jar", "auth-service-v1.jar", "&"]