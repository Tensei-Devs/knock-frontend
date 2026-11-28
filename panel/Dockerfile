FROM node:24-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts --no-audit --no-fund
COPY . .
RUN npm run build

FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/dist/panel/browser /srv
# Caddy sirve sin root: escucha en $PORT (8080 por omisión) y solo escribe en /config y /data.
RUN chown -R 1000:1000 /config /data
USER 1000:1000
