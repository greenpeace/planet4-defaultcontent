SHELL := /bin/bash

include secrets/env
export $(shell sed 's/=.*//' secrets/env)

CLOUDSQL_INSTANCE	  ?= planet-4-151612:us-central1:p4-develop-k8s

CLOUDSQL_USER 			?= root
CLOUDSQL_PASSWORD 	?=

ifeq ($(strip $(CLOUDSQL_PASSWORD)),)
$(error Error: CLOUDSQL_PASSWORD not set, please set in environment)
endif

SQL_TAG ?= $(shell bash -c 'read -p "Please enter SQL version tag: " tag; echo $$tag')

BUCKET_SOURCE 			?= gs://planet4-defaultcontent-stateless-develop
BUCKET_DESTINATION 	?= gs://planet4-default-content

.PHONY: all
all: sql stateless

###############################################################################

.PHONY: sql
sql:
	@BUCKET_DESTINATION="$(BUCKET_DESTINATION)" \
	CLOUDSQL_INSTANCE="$(CLOUDSQL_INSTANCE)" \
	CLOUDSQL_USER="$(CLOUDSQL_USER)" \
	CLOUDSQL_PASSWORD="$(CLOUDSQL_PASSWORD)" \
	SQL_TAG="$(SQL_TAG)" \
	./sql_sync.sh

###############################################################################

.PHONY: stateless
stateless:
	gsutil -m rsync -r -d $(BUCKET_SOURCE) $(BUCKET_DESTINATION)/uploads/
	@echo ""
	@echo "Synchronising $(BUCKET_SOURCE) > $(BUCKET_DESTINATION)/uploads/ complete."
	@echo ""
	gsutil du -sh "${BUCKET_DESTINATION}/"
	@echo ""
