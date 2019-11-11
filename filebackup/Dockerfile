FROM debian:stretch-slim

RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates s3cmd  

COPY filebackup.sh /usr/local/bin/
COPY s3config /root/.s3cfg

RUN chmod 500 /usr/local/bin/filebackup.sh

