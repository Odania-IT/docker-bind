FROM odaniait/docker-base:latest
MAINTAINER Mike Petersen <mike@odania-it.de>

RUN apt-get update && apt-get install -y bind9 dnsutils

# Setup haproxy with supervisord
RUN mkdir -p /etc/service/bind
COPY runit/bind.sh /etc/service/bind/run

COPY . /srv/bind
WORKDIR /srv/bind
RUN bundle install

RUN mkdir -p /srv/data && chown -R bind:bind /srv/data

ENV COPY_REFERENCE_FILE_LOG /srv/data/copy_reference_file.log
VOLUME '/srv/data' '/srv/bind'
EXPOSE 53

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
