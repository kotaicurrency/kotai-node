#!/bin/bash

set -x

DOCKER_REGISTRY="${DOCKER_REGISTRY:-kotaicurrency}"

echo "Script ci/actions/linux/install_deps.sh starting COMPILER=\"$COMPILER\""

# This enables IPv6 support in docker, needed to run node tests inside docker container
sudo mkdir -p /etc/docker && echo '{"ipv6":true,"fixed-cidr-v6":"2001:db8:1::/64"}' | sudo tee /etc/docker/daemon.json && sudo service docker restart

ci/build-docker-image.sh docker/ci/Dockerfile-base ${DOCKER_REGISTRY}/kotai-env:base
if [[ "${COMPILER:-}" != "" ]]; then
    ci/build-docker-image.sh docker/ci/Dockerfile-${COMPILER} ${DOCKER_REGISTRY}/kotai-env:${COMPILER}
else
    ci/build-docker-image.sh docker/ci/Dockerfile-gcc ${DOCKER_REGISTRY}/kotai-env:gcc
    ci/build-docker-image.sh docker/ci/Dockerfile-clang ${DOCKER_REGISTRY}/kotai-env:clang
    ci/build-docker-image.sh docker/ci/Dockerfile-rhel ${DOCKER_REGISTRY}/kotai-env:rhel
fi

echo "Script ci/actions/linux/install_deps.sh finished"
