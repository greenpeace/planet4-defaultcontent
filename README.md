# Planet4 Default Content

This repository describes the website running at [https://k8s.p4.greenpeace.org/defaultcontent/](https://k8s.p4.greenpeace.org/defaultcontent/), which provides the base install for Greenpeace Planet 4.

---

## Updating Saved Content
Procedure:
1. In this repository, create and push a new tagged release vX.Y.Z
1. In circleCI, a job will be run named `create-default-sql`
