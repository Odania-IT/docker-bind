FROM alpine:3.5
MAINTAINER Mike Petersen <mike@odania-it.de>

RUN apk update && apk upgrade && \
	apk add bash vim bind bind-tools ruby ruby-io-console ruby-bundler ruby-dev libffi-dev gcc make musl-dev && \
	rm -rf /var/cache/apk/*

# Generate rndc key
#RUN rndc-confgen -a
RUN rndc-confgen > /etc/bind/rndc.conf


COPY run.sh /run.sh
COPY . /srv/bind
WORKDIR /srv/bind
RUN bundle install

RUN mkdir -p /var/cache/bind && chown -R named:named /var/cache/bind
RUN mkdir -p /srv/data && chown -R named:named /srv/data
COPY templates/named.conf /etc/bind/named.conf
COPY templates/named.conf.options /etc/bind/named.conf.options
RUN chown -R named:named /etc/bind
RUN chown -R root:named /etc && chmod g+rwx /etc

RUN chown -R named:named /etc/bind
ENV COPY_REFERENCE_FILE_LOG /srv/data/copy_reference_file.log
VOLUME '/srv/data' '/srv/bind'
EXPOSE 5353/udp 5353/tcp
CMD '/run.sh'
USER named

