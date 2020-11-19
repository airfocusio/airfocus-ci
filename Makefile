IMAGE=docker.pkg.airfocus.dev/airfocus/airfocus-ci
TAG=latest

build:
	docker build -t $(IMAGE):$(TAG) -f Dockerfile .

versions: build
	docker run --rm -it --entrypoint git $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint docker $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint java $(IMAGE):$(TAG) -version
	docker run --rm -it --entrypoint scala $(IMAGE):$(TAG) -version
	docker run --rm -it --entrypoint sbt $(IMAGE):$(TAG) sbtVersion
	docker run --rm -it --entrypoint node $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint npm $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint yarn $(IMAGE):$(TAG) --version

publish: build
	docker push $(IMAGE):$(TAG)
