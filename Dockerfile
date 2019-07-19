FROM 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/node:1.0 as build-stage
WORKDIR /app
COPY . .
RUN \
    npm install --registry=https://registry.npm.taobao.org  && \
    npm run build
FROM nginx:1.14.2 as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]