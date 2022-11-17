#!/bin/bash

PUBLIC_TAG=0.1.0
docker build --tag allure-ui-release --build-arg VERSION=$PUBLIC_TAG --build-arg VCS_REF=$(git rev-parse HEAD) --build-arg BUILD_DATE="$(date +"%Y-%m-%d")" .

docker login
docker tag allure-ui-release klilleby/allure-docker-service-ui:${PUBLIC_TAG}
docker push klilleby/allure-docker-service-ui:${PUBLIC_TAG}