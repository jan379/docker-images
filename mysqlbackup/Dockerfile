FROM debian:stretch-slim

ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6.46-1debian9

RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates mysql-client s3cmd  

COPY mysql-backup.sh /usr/local/bin/
COPY s3config /root/.s3cfg

RUN chmod 500 /usr/local/bin/mysql-backup.sh
