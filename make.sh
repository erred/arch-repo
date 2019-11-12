#!/usr/bin/env bash

OUTFILE=cloudbuild.aur2.yaml

cat << EOF1 > $OUTFILE
tags:
  - \$COMMIT_SHA
  - \$SHORT_SHA
  - arch-repo
  - arch-repo-aur
substitutions:
  _IMG: arch-repo-builder
  _BKT: seankhliao-arch-repo
artifacts:
  objects:
    location: gs://\$_BKT
    paths:
      - \$_BKT/*

timeout: 1200s
steps:
  - id: precache
    name: gcr.io/cloud-builders/gsutil
    args:
      - -m
      - rsync
      - -r
      - gs://$_BKT
      - .

EOF1

while read pkg; do
    cat << EOF2 >> $OUTFILE
  - id: build $pkg
    waitFor: ["precache"]
    name: gcr.io/\$PROJECT_ID/\$_IMG:latest
    entrypoint: /usr/bin/bash
    env:
        - PKG=$pkg
        - OUTDIR=\$_BKT
    args:
        - ./archinstall.sh
EOF2

done < pkglist.txt

cat << EOF3 >> $OUTFILE

  - id: collect
    name: gcr.io/$PROJECT_ID/$_IMG:latest
    entrypoint: /usr/bin/bash
    args:
      - -c
      - sudo repo-add -R $_BKT/seankhliao.db.tar.zst $_BKT/*.pkg.tar.zst
EOF3
