IMAGE=docker.pkg.airfocus.dev/airfocus/airfocus-ci
TAG=latest

build: build-base build-node build-scala build-pulumi

build-base:
	docker build -t $(IMAGE)-base:$(TAG) -f base/Dockerfile .

build-node: build-base
	docker build -t $(IMAGE)-node:$(TAG) -f node/Dockerfile .

build-scala: build-base
	docker build -t $(IMAGE)-scala:$(TAG) -f scala/Dockerfile .

build-pulumi: build-base
	docker build -t $(IMAGE)-pulumi:$(TAG) -f pulumi/Dockerfile .

test: test-node test-scala

test-base: build-base
	docker run --rm -it -v $(PWD):/workspace -e CI_WORKSPACE=/workspace -e CI_COMMIT_REF=refs/heads/master $(IMAGE)-base:$(TAG) version
	docker run --rm -it -v $(PWD):/workspace -e CI_WORKSPACE=/workspace -e CI_COMMIT_REF=refs/tags/v1.0.0 $(IMAGE)-base:$(TAG) version

test-node: build-node
	rm -rf test/node/.git
	git clean -xfd test/node
	git reset -- test/node
	cd test/node && git init
	cd test/node && git commit -m 'TEST' --allow-empty
	docker run --rm -it -v $(PWD)/test/node:/workspace -e PLUGIN_ACTION=install -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/heads/master $(IMAGE)-node:$(TAG)
	docker run --rm -it -v $(PWD)/test/node:/workspace -e PLUGIN_ACTION=install -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/heads/staging $(IMAGE)-node:$(TAG)
	docker run --rm -it -v $(PWD)/test/node:/workspace -e PLUGIN_ACTION=install -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/tags/v1.2.3 $(IMAGE)-node:$(TAG)

test-scala: build-scala
	rm -rf test/scala/.git
	git clean -xfd test/scala
	git reset -- test/scala
	cd test/scala && git init
	cd test/scala && git commit -m 'TEST' --allow-empty
	docker run --rm -it -v $(PWD)/test/scala:/workspace -e PLUGIN_ACTION=compile -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/heads/master $(IMAGE)-scala:$(TAG)
	docker run --rm -it -v $(PWD)/test/scala:/workspace -e PLUGIN_ACTION=compile -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/heads/staging $(IMAGE)-scala:$(TAG)
	docker run --rm -it -v $(PWD)/test/scala:/workspace -e PLUGIN_ACTION=compile -e PLUGIN_REGISTRY_TOKEN=secret -e CI_COMMIT_REF=refs/tags/v1.2.3 $(IMAGE)-scala:$(TAG)

versions-node: build-node
	docker run --rm -it --entrypoint git $(IMAGE)-node:$(TAG) --version
	docker run --rm -it --entrypoint docker $(IMAGE)-node:$(TAG) --version
	docker run --rm -it --entrypoint node $(IMAGE)-node:$(TAG) --version
	docker run --rm -it --entrypoint npm $(IMAGE)-node:$(TAG) --version
	docker run --rm -it --entrypoint yarn $(IMAGE)-node:$(TAG) --version

versions-scala: build-scala
	docker run --rm -it --entrypoint git $(IMAGE)-scala:$(TAG) --version
	docker run --rm -it --entrypoint docker $(IMAGE)-scala:$(TAG) --version
	docker run --rm -it --entrypoint java $(IMAGE)-scala:$(TAG) -version
	docker run --rm -it --entrypoint scala $(IMAGE)-scala:$(TAG) -version
	docker run --rm -it --entrypoint sbt $(IMAGE)-scala:$(TAG) sbtVersion

versions-pulumi: build-pulumi
	docker run --rm -it --entrypoint git $(IMAGE)-pulumi:$(TAG) --version
	docker run --rm -it --entrypoint node $(IMAGE)-pulumi:$(TAG) --version
	docker run --rm -it --entrypoint pulumi $(IMAGE)-pulumi:$(TAG) version

publish: build
	docker push $(IMAGE)-base:$(TAG)
	docker push $(IMAGE)-node:$(TAG)
	docker push $(IMAGE)-scala:$(TAG)
	docker push $(IMAGE)-pulumi:$(TAG)
