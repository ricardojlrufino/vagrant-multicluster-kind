FROM nginx:latest
COPY landing/dist /usr/share/nginx/html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
RUN echo $(hostname) >> /usr/share/nginx/html/index.html