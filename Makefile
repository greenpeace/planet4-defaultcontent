SHELL := /bin/bash

CLOUDSQL_INSTANCE	  ?= planet-4-151612:us-central1:p4-develop-k8s

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
	./bin/sql_sync.sh

###############################################################################

.PHONY: stateless
stateless:
	gcloud storage rsync $(BUCKET_SOURCE) $(BUCKET_DESTINATION)/uploads/ --recursive --delete-unmatched-destination-objects
	@echo ""
	@echo "Synchronising $(BUCKET_SOURCE) > $(BUCKET_DESTINATION)/uploads/ complete."
	@echo ""
	gcloud storage ls -L "${BUCKET_DESTINATION}/ | grep bytes"
	@echo ""
