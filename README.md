# Planet4 Default Content

This repository describes the website running at [https://k8s.p4.greenpeace.org/defaultcontent/](https://k8s.p4.greenpeace.org/defaultcontent/), which provides the base install for Greenpeace Planet 4.

---

## Updating Saved Content
Prerequisites:
1. You have access to the google cloud project where the database of the defaultcontent site lives
1. You have Google Cloud SDK installed on your computer
1. You have authorised Google Cloud SDK (with the command `gcloud auth login` and following the instructions)
1. You have switched to the correct GCP project (with the command `gcloud config set project PROJECT_ID`)
1. You have installed and configured [Cloud SQL proxy](https://cloud.google.com/sql/docs/mysql/quickstart-proxy-test)
   1. Download the proxy, and make it executable
   1. Add the downloaded file to your path, so that it can be run directly from the script (confirm it by trying to run `cloud_sql_proxy` from your shell)

To update the stored content,
1. Make sure you have a CloudSQL user account. If you dont then: in the GCP project where the database for this site lives,
   1. Go to SQL (from the right side)
   1. Click on the instance where the database lives (default: planet-4-151612:us-central1:p4-develop-k8s)
   1. Go to "Users"
   1. Create user account
1. Create and populate the file `secrets/env` with values based on `secrets/env.example`. More specifically copy username and password in the fields CLOUDSQL_USER and CLOUDSQL_PASSWORD in the `secrets/env` file.

1.  Run `make`, optionally setting the environment variable `SQL_TAG`. For example:
 ```SQL_TAG=0.1.1 make -j2```. If `SQL_TAG` is not set, you will be prompted to enter a semantic version number. You can see the latest tag used at the `SOURCE_CONTENT_SQLDUMP` parameter of https://github.com/greenpeace/planet4-nro-generator/blob/develop/Dockerfile

 Note that `roles/cloudsql.viewer` [CloudSQL Client permissions](https://cloud.google.com/sql/docs/mysql/project-access-control) and `roles/storage.objectAdmin` [Cloud Storage permissions](https://cloud.google.com/storage/docs/access-control/iam-roles) are required.

---

## Post-install Procedures

As yet, the following items need to be configured manually, __for each deployment environment__:

### Nginx Helper

-   Settings > Nginx Helper
-   Redis Settings > Hostname: Enter the Helm release name suffixed by `-redis`.
-   Save All Changes

For example, if the Helm release is called `planet4-international`, enter `planet4-international-redis`. The exception to this is on the `release` environment the field would be `planet4-international-redis-release`.

### Google Apps Login

-   [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials), select the appropriate project: if this is only for testing, create these credentials in `planet-4-151612`, if this site will be used in production, use `planet4-production`.
-   Create Credentials > OAUTH client ID
-   Select Web Application
-   Name: `greenpeace.org/<path>`
-   Authorized JavaScript origins: `https://k8s.p4.greenpeace.org`, `https://release.k8s.p4.greenpeace.org`, `https://master.k8s.p4.greenpeace.org`, `https://www.greenpeace.org`
-   Authorized redirect URIs: `https://k8s.p4.greenpeace.org/<path>/wp-login.php`, `https://release.k8s.p4.greenpeace.org/<path>/wp-login.php`, `https://master.k8s.p4.greenpeace.org/<path>/wp-login.php`, `https://www.greenpeace.org/<path>/wp-login.php`
-   Create
-   Copy and paste the generated client ID to Settings > Google Apps Login > Client ID
-   Paste client secret to Settings > Google Apps Login > Client Secret
-   Save Changes

### WP Stateless

-   Media > Stateless Settings
-   Bulk Size: 10
-   Run (this may take a while)
