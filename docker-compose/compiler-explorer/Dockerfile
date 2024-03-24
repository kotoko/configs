FROM ubuntu:22.04

EXPOSE 10240
USER root

COPY install-stuff.sh /root/install-stuff.sh
RUN bash /root/install-stuff.sh
COPY compiler-explorer-etc-config/ /compiler-explorer/etc/config/

WORKDIR /compiler-explorer
ENTRYPOINT [ "make" ]
CMD ["run-only"]
