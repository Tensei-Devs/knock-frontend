# Landing de Knock (TT-WEB-01): nginx sin root en el puerto 8080.
FROM nginxinc/nginx-unprivileged:1.30.6-alpine@sha256:f5116ed4606f3eb015dd4a8e28cb9b351476dc0ad4bc6e9f93b19cec130cdf03

# Aplica los parches de Alpine que la imagen base aún no trae (Trivy, 2026-11-02:
# brotli-libs, curl, libcurl y libexpat con versión corregida) y quita las
# páginas de ejemplo de nginx (index.html y 50x.html).
USER root
RUN apk upgrade --no-cache brotli-libs curl libcurl libexpat \
    && rm -rf /usr/share/nginx/html/*

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html 404.html /usr/share/nginx/html/
COPY css /usr/share/nginx/html/css
COPY fonts /usr/share/nginx/html/fonts
COPY privacidad /usr/share/nginx/html/privacidad
COPY eliminar-cuenta /usr/share/nginx/html/eliminar-cuenta

USER 101
EXPOSE 8080
