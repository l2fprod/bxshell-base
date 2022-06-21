FROM ubuntu:20.04 as builder

COPY install.sh install.sh

ARG GITHUB_TOKEN
RUN GITHUB_TOKEN=$GITHUB_TOKEN ./install.sh && rm install.sh

FROM scratch
COPY --from=builder / /
