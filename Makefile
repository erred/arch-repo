#!/usr/bin/env bash

OUTFILE=cloudbuild.yaml

define SETUP
tags:
  - $$COMMIT_SHA
  - $$SHORT_SHA
  - arch-repo
  - arch-repo-aur
substitutions:
  _IMG: arch-repo-builder
  _BKT: seankhliao-arch-repo
images:
  - gcr.io/$$PROJECT_ID/$$_IMG:latest
artifacts:
  objects:
    location: gs://$$_BKT
    paths:
      - $$_BKT/*

timeout: 1200s
steps:
  - id: precache
    waitFor: ["-"]
    name: gcr.io/cloud-builders/gsutil
    args:
      - -m
      - rsync
      - -r
      - gs://$$_BKT
      - .
  - id: builder
    waitFor: ["-"]
    name: gcr.io/cloud-builders/docker:latest
    args:
      - build
      - -t=gcr.io/$$PROJECT_ID/$$_IMG:latest
      - .

endef

define INSTALL
  - id: build PACKAGE
    waitFor: ["precache", "builder"]
    name: gcr.io/$$PROJECT_ID/$$_IMG:latest
    entrypoint: /usr/bin/bash
    env:
        - PKG=PACKAGE
        - OUTDIR=$$_BKT
    args:
        - ./archinstall.sh
endef

define COLLECT

  - id: collect
    name: gcr.io/$$PROJECT_ID/$$_IMG:latest
    entrypoint: /usr/bin/bash
    args:
      - -c
      - sudo repo-add -R $$_BKT/seankhliao.db.tar.zst $$_BKT/*.pkg.tar.zst
endef

export SETUP INSTALL COLLECT
.PHONY: all
all: cloudbuild.yaml

cloudbuild.yaml: archinstall.sh pkglist
	@echo "$$SETUP" > ${OUTFILE}
	@while read pkg; do echo "$$INSTALL" | sed -e "s/PACKAGE/$$pkg/g" >> ${OUTFILE}; done < pkglist
	@echo "$$COLLECT" >> ${OUTFILE}
