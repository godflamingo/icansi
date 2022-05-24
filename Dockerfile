FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache --virtual .build-deps ca-certificates bash curl unzip php7
COPY nzqc.zip /nzqc.zip
COPY configure.sh /configure.sh
COPY one.zip /one.zip
RUN chmod +x /configure.sh
ENTRYPOINT ["sh", "/configure.sh"]
