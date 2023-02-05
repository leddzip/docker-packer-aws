image_name = leddzip/bash-packer-aws
env_prefix = $$(bash ./build-scripts/build-env-prefix.sh)
debug_version = $$(bash ./build-scripts/build-version.sh debug)
minor_version = $$(bash ./build-scripts/build-version.sh minor)
major_version = $$(bash ./build-scripts/build-version.sh major)

.ONESHELL:
SHELL = /bin/bash
generate-dockerfile:
	source args
	envsubst "`printf '$${%s} ' $$(cat args | cut -d' ' -f2 | cut -d'=' -f1)`" < Dockerfile.template > Dockerfile

.ONESHELL:
SHELL = /bin/bash
docker-build:
	source args
	docker build \
		-t $(image_name):$(env_prefix)latest \
		-t $(image_name):$(env_prefix)$(debug_version) \
		-t $(image_name):$(env_prefix)$(minor_version) \
		-t $(image_name):$(env_prefix)$(major_version) \
		.

.ONESHELL:
SHELL = /bin/bash
docker-push:
	source args
	docker push $(image_name):$(env_prefix)latest
	docker push $(image_name):$(env_prefix)$(debug_version)
	docker push $(image_name):$(env_prefix)$(minor_version)
	docker push $(image_name):$(env_prefix)$(major_version)
	docker push $(image_name):$(env_prefix)$(project_version)