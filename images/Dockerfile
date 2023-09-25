FROM mkdocs-material.extended as build
WORKDIR /app
COPY . ./
RUN mkdocs build

FROM nginxinc/nginx-unprivileged:1.25
COPY --from=build /app/site /usr/share/nginx/html