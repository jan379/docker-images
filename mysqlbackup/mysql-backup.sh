#/usr/bin/env

# 2019 jan.peschke@innovo-cloud.de
# - take a simple db dump 
# - put that dump to a specified s3 bucket


if [ -z "${S3_BUCKET}"  ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
else echo "$0 will put a backup to ${S3_BUCKET}"
fi

if [ -z "${S3_SECRET}"  ]; then
  echo "You need to set the S3_SECRET environment variable."
  exit 1
else echo "$0 will put a backup to ${S3_SECRET}"
fi

if [ -z "${S3_KEY}"  ]; then
  echo "You need to set the S3_KEY environment variable."
  exit 1
else echo "$0 will put a backup to ${S3_KEY}"
fi


if [ -z "${MYSQL_HOST}"  ]; then
  echo "You need to set the MYSQL_HOST environment variable."
  exit 1
else echo "$0 database host is ${MYSQL_HOST}"
fi

if [ -z "${MYSQL_DB}"  ]; then
  echo "You need to set the MYSQL_DB environment variable."
  exit 1
else echo "$0 will snapshot a backup of ${MYSQL_DB}"
fi


if [ -z "${MYSQL_USER}"  ]; then
  echo "You need to set the MYSQL_USER environment variable."
  exit 1
else echo "$0 will use user ${MYSQL_USER}"
fi

if [ -z "${MYSQL_PASSWORD}"  ]; then
  echo "You need to set the MYSQL_PASSWORD environment variable."
  exit 1
else echo "$0 found mysql password variable..."
fi


if s3cmdpath="$(which s3cmd)"; then
  echo "Found s3cmd binary at ${s3cmdpath}"
else echo "Could not find s3cmd util"
  exit 1
fi

if s3cmd --access_key=${S3_KEY} --secret_key=${S3_SECRET} ls s3://${S3_BUCKET}; then 
  echo "got valid s3 credentials"
else echo "did not get valid s3 credentials..."
  exit 1
fi


if mysqldumppath="$(which mysqldump)"; then
  echo "Found mysqldump binary at ${mysqldumppath}"
else echo "Could not find mysqldump util"
  exit 1
fi

bacckup(){
mkdir /root/backup
if mysqldump -h"${MYSQL_HOST}" -p"${MYSQL_PASSWORD}" -u"${MYSQL_USER}" "${MYSQL_DB}" > /root/backup/bigdump.sql ; then
  echo "prepared a new dump, try to sync to s3://${S3_BUCKET}"
  s3cmd --access_key=${S3_KEY} --secret_key=${S3_SECRET} sync /root/backup/ s3://${S3_BUCKET}/database/
fi
}

restore(){
mkdir /root/backup
s3cmd --access_key=${S3_KEY} --secret_key=${S3_SECRET} sync s3://${S3_BUCKET}/database/ /root/backup/
if mysql -h"${MYSQL_HOST}" -p"${MYSQL_PASSWORD}" -u"${MYSQL_USER}" "${MYSQL_DB}" < /root/backup/bigdump.sql ; then
  echo "successfully restored mysql database from s3://${S3_BUCKET}"
fi
}

case "$1" in
  --restore)
  restore
  ;;
  --backup)
  backup
  ;;
  *)
  backup
  ;;
esac

