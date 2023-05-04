# issue-nginx-epoll_wait-fail-interrupted-system-call

```sh
docker run --rm -it -v ${PWD}:/mnt -w /mnt openresty/openresty:1.21.4.1-0-jammy /bin/sh
# or use 
docker run --rm -it -v ${PWD}:/mnt -w /mnt openresty/openresty:1.21.4.1-6-alpine-apk /bin/sh

# then run nginx in docker
./run.sh
```
