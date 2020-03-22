  
FROM nginx:1.14.2-alpine
LABEL maintainer="Mamat Nurahmat <noerahmat08@gmail.com>"
ARG SVC_PORT

#COPY --from=builder /app/webapp/build /usr/share/nginx/html
#COPY ci/default.conf /etc/nginx/conf.d/default.conf
#EXPOSE ${SVC_PORT}
COPY /src/index.html /usr/share/nginx/html
EXPOSE ${SVC_PORT}
CMD ["nginx", "-g", "daemon off;"]
