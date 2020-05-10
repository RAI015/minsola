FROM nginx:1.17.4-alpine

RUN rm -f /etc/nginx/conf.d/*

COPY ./nginx/nginx.conf /etc/nginx/conf.d/minsola.conf

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf