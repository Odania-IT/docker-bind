#!/usr/bin/env bash

# Prepare data directory
DATA_DIR=/srv/data/etc
LIB_DIR=/srv/data/lib

# Copy files from /opt/openhab2/conf-default into /opt/openhab2/conf
# So the initial OPENHAB-HOME is set with expected content.
# Don't override, as this is just a reference setup. You can modify the contents afterwords.
copy_reference_file() {
	f=${1%/}
	echo "$f" >> $COPY_REFERENCE_FILE_LOG
	rel=${f:${#3}}
	dir=$(dirname ${f})

	if [[ ! -e $2/${rel} ]]
	then
		echo "copy $rel to $2" >> $COPY_REFERENCE_FILE_LOG
		mkdir -p $2/${dir:${#3}}
		cp -r $3/${rel} $2/${rel};
	fi;
}
export -f copy_reference_file
echo "--- Copying files at $(date)" >> $COPY_REFERENCE_FILE_LOG
find /etc/bind -type f -exec bash -c "copy_reference_file '{}' ${DATA_DIR} '/etc/bind'" \;
find /var/lib/bind -type f -exec bash -c "copy_reference_file '{}' ${LIB_DIR} '/var/lib/bind'" \;

rm -rf /etc/bind
ln -sf ${DATA_DIR} /etc/bind
rm -rf /var/lib/bind
ln -sf ${LIB_DIR} /var/lib/bind

cd /srv/bind && rake config:generate
chown -R bind:bind ${DATA_DIR}
chown -R bind:bind ${LIB_DIR}

exec chpst -ubind /usr/sbin/named -g
