# Build environment
FROM node:12-alpine as build
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
COPY . ./
RUN npm run build

# Production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf.template
RUN envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
