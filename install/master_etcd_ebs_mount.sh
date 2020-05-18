#!/bin/bash

INSTALLDIR=$1
mv $INSTALLDIR/temp/master.ign $INSTALLDIR/temp/master.ign.tmp

cat $INSTALLDIR/temp/master.ign.tmp | jq '.storage += {"disks":[{"device":"/dev/xvdf","partitions": [{"label":"etcd","number":1}]}]} |.storage += {"filesystems": [{"device":"/dev/xvdf1","format":"xfs","label":"etcd", "path": "/var/lib/etcd"}]} | .systemd += {"units":[{"name":"var-lib-etcd.mount", "enable": true, "contents":"[Unit]\nAfter=format-var-lib-etcd.service\nRequires=format-var-lib-etcd.service\n\n[Mount]\nWhat=/dev/xvdf1\nWhere=/var/lib/etcd\nType=xfs\n\n[Install]\nWantedBy=local-fs.target"},{"name":"format-var-lib-etcd.service", "enable":true, "contents":"[Unit]\nBefore=var-lib-etcd.mount\nConditionPathExists=!/var/lib/etcd\n\n[Service]\nType=oneshot\nExecStart=mkfs.xfs /dev/xvdf1\n"}]}' > $INSTALLDIR/temp/master.ign
