# ---------- Stage 1: Build Angular App ----------
FROM node:22-alpine AS builder

# Install Angular CLI globally
RUN npm install -g @angular/cli @ionic/cli

# Set working directory
WORKDIR /app

# Copy package.json files first (for caching)
COPY package*.json ./

# Install project dependencies
RUN npm install --legacy-peer-deps

# Copy all source code
COPY . .

# Build the Angular app
RUN npm run build:development


# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:stable-alpine AS runtime

# Clean up default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY dev.nginx.conf /etc/nginx/conf.d/default.conf

# Replace 'your-app-name' with actual Angular project name
COPY --from=builder /app/www/ /usr/share/nginx/html/www

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
