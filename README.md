# docker-alpine-r

> This is a Base and Clean Docker Image for R Programming Language.

## build

```Bash
docker build \
--build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
-t lonly/docker-alpine-r .
```