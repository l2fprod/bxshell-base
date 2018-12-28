FROM ubuntu:18.04

COPY install.sh install.sh
RUN ./install.sh && rm install.sh
