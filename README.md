# Planet4 Default Content

This repository describes the website running at [https://k8s.p4.greenpeace.org/defaultcontent/](https://k8s.p4.greenpeace.org/defaultcontent/)

## Updating stored content

To update the stored content, create and populate the file `secrets/env` with values based on `secrets/env.example` and then run `make`, optionally setting the new SQL_TAG with:

 `SQL_TAG=0.x.x make -j2`

 If SQL_TAG is not set, you will be prompted to enter a semantic version number.

 Note that `roles/cloudsql.viewer` [CloudSQL Client permissions](https://cloud.google.com/sql/docs/mysql/project-access-control) and `roles/storage.objectAdmin` [Cloud Storage permissions](https://cloud.google.com/storage/docs/access-control/iam-roles) are required.
