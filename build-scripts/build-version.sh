set -e

[ -z "$INJECT_AWS_CLI_VERSION" ] && exit 1
[ -z "$INJECT_PACKER_VERSION" ] && exit 2
[ -z "$INJECT_UBUNTU_VERSION" ] && exit 3

case "$1" in
  major)
    UBUNTU_VERSION=$(echo "$INJECT_UBUNTU_VERSION" | cut -d. -f1)
    PACKER_VERSION=$(echo "$INJECT_PACKER_VERSION" | cut -d. -f1)
    AWS_CLI_VERSION=$(echo "$INJECT_AWS_CLI_VERSION" | cut -d. -f1)
    ;;
  minor)
    UBUNTU_VERSION=$(echo "$INJECT_UBUNTU_VERSION" | cut -d. -f1-2)
    PACKER_VERSION=$(echo "$INJECT_PACKER_VERSION" | cut -d. -f1-2)
    AWS_CLI_VERSION=$(echo "$INJECT_AWS_CLI_VERSION" | cut -d. -f1-2)
    ;;
  debug)
    UBUNTU_VERSION="$INJECT_UBUNTU_VERSION"
    PACKER_VERSION="$INJECT_PACKER_VERSION"
    AWS_CLI_VERSION="$INJECT_AWS_CLI_VERSION"
esac

echo  "${UBUNTU_VERSION}_${PACKER_VERSION}_${AWS_CLI_VERSION}"