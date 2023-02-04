set -e

#===============================
# This scripts is use to generate the image tag prefix
# based on the environment we are targeting.
#
# Only the prod environment should not contains any prefix
#

if [ -z ${CIRCLECI+x} ]; then
  # We are not in the CircleCI CI/CD Workflow
  # So we are most certainly in a local environment
  if [[ -z "${ENV_TARGET}" ]]; then
    echo "local-"
  else
    case "$ENV_TARGET" in
      dev | DEV | Dev | prod | PROD | Prod)
        # checking if the target is not a CI/CD managed target
        exit 1
        ;;
      *[[:space:]]*)
        # checking that the target does not contain spaces since
        # it might mess up the tags for the docker image
        exit 2
        ;;
      *)
        echo "$ENV_TARGET-"
        ;;
    esac
  fi

else
  # We are inside CircleCI, so we assume the ENV_TARGET
  # variable environment is set. Otherwise it will break
  case "$ENV_TARGET" in
      dev | DEV | Dev)
          echo "dev-"
          ;;
      prod | PROD | Prod)
          echo ""
          ;;
      *)
          exit 3;
  esac
fi