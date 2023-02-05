Docker Packer AWS
=================

This image should provide a base bash image with packer and aws-cli so it
can be used in any docker based pipeline to provision packer ami creation on AWS.

The base image comes from the official [Ubuntu docker image](https://hub.docker.com/_/ubuntu).

How to use
----------

There are 3 way to inject your credential so that you can create your AMI on aws:

1. Provide them in your packer file (not recommended)
2. Mount the `~/.aws/credentail` location to your docker image
3. Provide the two env variable `AWS_ACCESS_KEY` and `AWS_SECRET_ACCESS_KEY` to your docker container. `aws-cli` should be able to use them for login (this is the recommended approach).

Dev notes
---------

### Tagging

#### env target prefix
Based on the env we want to target (most common scenario is dev and prod), we generate a prefix or not for each of the tags
described in the following sections.

If the target is prod, we don't generate any prefix.

If the target is no prod (like dev), each tag will be prefixed with the name of the env target:
* dev-latest
* dev-0.1.0
* dev-*whatever*

This prefix is generated using the script [build-env-prefix.sh](./build-scripts/build-env-prefix.sh).

#### dependency based
Those tags are based on the main dependencies of the image:
* ubuntu (22.04)
* packer (1.8.5)
* aws-cli (2.9.21)

based on this, 3 set of tags will be generated:
* major: 22_1_2
* minor: 22.04_1.8_2.9
* debug: 22.04_1.8.5_2.9.21

Those tags are generated using the script [build-version.sh](./build-scripts/build-version.sh).

### Building the Dockerfile

There is no `Dockerfile` in this repo, only a template. To build the `Dockerfile` based on this template,
we have to inject the version of our main dependencies.

To do this injection, we are using the `envsubst` command in order to inject env variable in one file.
The  actual command that is doing this injection and file creation is:
```bash
envsubst "`printf '${%s} ' $(cat args | cut -d' ' -f2 | cut -d'=' -f1)`" < Dockerfile.template > Dockerfile
```

The first part of the command is a trick to list only the env variable we want to inject. Otherwise,
ARGS that are in the template file might be wrongly recognised as env variable (since the syntax is the same) and replaced by
either an empty string (if the env variable is not defined) or by the env variable content if one exist with the same name.

To avoid this uncertainty, we only tell `envsubst` to inject the variable listed in the `args` file.

