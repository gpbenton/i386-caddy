
#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="0.10.12"
ARG plugins="git"
ARG arch=386

RUN VERSION=${version} PLUGINS=${plugins} GOARCH=${arch} /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM i386/alpine
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

LABEL caddy_version=${version}

RUN apk add --no-cache openssh-client git

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/Caddyfile", "--log", "stdout"]

