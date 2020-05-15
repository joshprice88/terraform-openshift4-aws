#!/bin/bash

INSTALLDIR=$1
mv $INSTALLDIR/temp/master.ign $INSTALLDIR/temp/master.ign.tmp

cat $INSTALLDIR/temp/master.ign.tmp | jq '.storage += {"disks":[{"device":"/dev/xvdf","partitions": [{"label":"etcd","number":1}]}]} |.storage += {"filesystems": [{"device":"/dev/xvdf1","format":"xfs","label":"etcd", "path": "/var/lib/etcd"}]} | .system += {"units":[{"name":"var-lib-etcd.mount", "enable": true, "contents":"[Mount]\nWhat=/dev/xvdf1\nWhere=/var/lib/etcd\nType=xfs\n\n[Install]\nWantedBy=local-fs.target"}]}' > $INSTALLDIR/temp/master.ign
