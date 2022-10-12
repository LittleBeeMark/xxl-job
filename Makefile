SERVICE_NAME=ddcxxljobadmin
SERVICE_VERSION=v1.0.0

docker_build:
	docker build -f ./test.Dockerfile -t $(SERVICE_NAME):$(SERVICE_VERSION) ./