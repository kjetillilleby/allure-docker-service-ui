######
FROM node:14-slim AS builder
ENV ROOT=/code
WORKDIR $ROOT
COPY ui $ROOT
RUN npm install && \
    npm run build

####    
FROM nginxinc/nginx-unprivileged:stable-alpine

ARG BUILD_DATE
ARG VERSION
ARG VCS_REF
LABEL org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.dockerfile="Dockerfile" \
    org.label-schema.license="MIT" \
    org.label-schema.name="Allure Docker Service UI" \
    org.label-schema.version=${VERSION} \
    org.label-schema.description="UI Layer for Allure Docker Service container" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/klilleby/allure-docker-service-ui" \
    authors="Frank Escobar <fescobar.systems@gmail.com>"

ENV ROOT=/app

USER root
COPY --from=builder /code/build $ROOT/ui
COPY nginx/ /etc/nginx/templates

RUN mv /etc/nginx/templates/*.sh /docker-entrypoint.d
RUN echo "${VERSION}" > $ROOT/ui/ui_version && \
    echo "ALLURE_DOCKER_SERVICE_UI_VERSION:" $(cat $ROOT/ui/ui_version)

RUN chmod -R 777 /usr/share/nginx/html /etc/nginx/conf.d
USER nginx
