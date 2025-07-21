#   docker buildx build --no-cache -t john:$(date '+%Y-%m-%d') .

FROM 'docker.io/kalilinux/kali-rolling:latest'

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN --mount=type=bind,source=./install-and-configure.sh,target=/install-and-configure.sh \
     /bin/bash /install-and-configure.sh

CMD /usr/sbin/john
