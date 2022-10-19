docker login

docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
# docker buildx create --use

# v8p2r1
docker buildx build --platform linux/amd64,linux/arm64 --push -t jamal919/telemac:v8p2r1 .
docker buildx build --load -t jamal919/telemac:v8p2r1 .

# Latest build
docker buildx build --platform linux/amd64,linux/arm64 --push -t jamal919/telemac:latest .
docker buildx build --load -t jamal919/telemac:latest .

# docker buildx rm
