docker login

docker build -t telemac:v8p2r1 .
docker tag telemac:v8p2r1 jamal919/telemac:v8p2r1
docker push jamal919/telemac:v8p2r1

docker build -t telemac:latest .
docker tag telemac:latest jamal919/telemac:latest
docker push jamal919/telemac:latest
