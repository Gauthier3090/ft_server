sudo apt-get update && upgrade
sudo apt-get install -y docker docker.io virtualbox
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine
docker-machine create --driver virtualbox default
docker-machine start default
docker-machine env
eval $(docker-machine env default)
docker-machine ip