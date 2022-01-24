# Planet4 Default Content

This repository describes the website running at [https://www-dev.greenpeace.org/defaultcontent/](https://www-dev.greenpeace.org/defaultcontent/), which provides the base install for Greenpeace Planet 4 of the Wordpress database and corresponding images in gs://planet4-default-content.

This repo only has a deployment in the P4 development environment, there is no requirement for a release or master deployment.

---

## Updating Saved Content
Procedure:
1. Make the necessary changes to the WP database, for more notes on
executing these tasks you can refer to this:  https://www.notion.so/p4infra/Wordpress-Database-Admin-Tasks-799fa20dda67460f8a5b93becad0ffae
2. In this repository, create and push a new tagged release vX.Y.Z
3. In circleCI, a job will be run named `create-default-sql`
