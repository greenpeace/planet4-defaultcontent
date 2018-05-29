# Planet4 Default Content

This repository describes the website running at [https://k8s.p4.greenpeace.org/defaultcontent/](https://k8s.p4.greenpeace.org/defaultcontent/), which provides the base install for Greenpeace Planet 4.

---

## Updating Saved Content

To update the stored content, create and populate the file `secrets/env` with values based on `secrets/env.example` and then run `make`, optionally setting the environment variable `SQL_TAG`. For example:

 ```SQL_TAG=0.1.1 make -j2```

 If SQL_TAG is not set, you will be prompted to enter a semantic version number.

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

-   [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials), select the appropriate project
-   Create Credentials > OAUTH client ID
-   Select Web Application
-   Name: `k8s.p4.greenpeace.org/<path>`
-   Authorized JavaScript origins: `https://k8s.p4.greenpeace.org`
-   Authorized redirect URIs: `https://k8s.p4.greenpeace.org/<path>/wp-login.php`
-   Create
-   Copy and paste the generated client ID to Settings > Google Apps Login > Client ID
-   Paste client secret to Settings > Google Apps Login > Client Secret
-   Save Changes

### WP Stateless

-   Media > Stateless Settings
-   Bulk Size: 10
-   Run (this may take a while)
