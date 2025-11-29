#   docker buildx build --no-cache -t ldap-check-passwords:$(date '+%Y-%m-%d') .

FROM 'docker.io/kalilinux/kali-rolling:latest'

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN --mount=type=bind,source=./install-and-configure.sh,target=/host/install-and-configure.sh \
    --mount=type=bind,source=./sources.list.txt,target=/host/sources.list.txt \
    --mount=type=bind,source=./dump-ldap-hashes.sh.template,target=/host/dump-ldap-hashes.sh.template \
    --mount=type=bind,source=./crack-passwords.py.template,target=/host/crack-passwords.py.template \
    --mount=type=bind,source=./send-notifications.py.template,target=/host/send-notifications.py.template \
    --mount=type=bind,source=./kurwayou.txt,target=/host/kurwayou.txt \
    --mount=type=bind,source=./run-app.sh,target=/host/run-app.sh \
    --mount=type=bind,source=./run-one_1.17-0ubuntu2_all.deb,target=/host/run-one_1.17-0ubuntu2_all.deb \
    /bin/bash /host/install-and-configure.sh

CMD /bin/bash /root/run-app.sh
