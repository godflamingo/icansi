FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache --virtual .build-deps ca-certificates bash curl unzip php7
COPY nzqc/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nzqc/nginx.conf /etc/nginx/nginx.conf
COPY nzqc/static-html /usr/share/nginx/html/index
COPY configure.sh /configure.sh
RUN chmod +x /configure.sh
COPY one.zip /one.zip
ENTRYPOINT ["sh", "/configure.sh"]
