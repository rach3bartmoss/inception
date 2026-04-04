FROM nginx:alpine3.22

RUN apk add --no-cache openssl

# RUN rm -rf /usr/share/nginx/html/*
# COPY html/ /usr/share/nginx/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/nginx.sh /tools/nginx.sh
RUN chmod +x /tools/nginx.sh && sh /tools/nginx.sh

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]