# frontend/Dockerfile

# Stage 1 – Build
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .


RUN npm run build

# Stage 2 – Serve with nginx
FROM nginx:alpine

# Copying built app
COPY --from=builder /app/dist /usr/share/nginx/html

#  nginx config (mivel SPA-ról van szó)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
