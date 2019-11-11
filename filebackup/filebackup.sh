#/usr/bin/env

# 2019 jan.peschke@innovo-cloud.de
# - sync a given directory to a given s3 bucket


if [ -z "${S3_BUCKET}"  ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
else echo "$0 will put a backup to ${S3_BUCKET}"
fi

if [ -z "${FILESTORAGE}"  ]; then
  echo "You need to set the FILESTORAGE environment variable."
  exit 1
else echo "$0 will sync ${FILESTORAGE} to ${S3_BUCKET}"
fi

if [ -z "${S3_SECRET}"  ]; then
  echo "You need to set the S3_SECRET environment variable."
  exit 1
else echo "$0 got a secret..."
fi

if [ -z "${S3_KEY}"  ]; then
  echo "You need to set the S3_KEY environment variable."
  exit 1
else echo "$0 got a key..."
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

echo "preparing to sync ${FILESTORAGE} to s3://${S3_BUCKET}"
while true; do 
 s3cmd --access_key=${S3_KEY} --secret_key=${S3_SECRET} sync ${FILESTORAGE} s3://${S3_BUCKET}/filestorage/
 sleep 180
done

