NAME="$(basename $PWD)"

if [ "$(podman ps -qa -f name=$NAME)" ]; then
    echo "Found container - $NAME"
else
  echo "Creating container - $NAME"
  podman create -ti \
      -v "$(pwd)":/work \
      -v "$(pwd)"/.config:/root/.config \
      -v "$(pwd)"/.ssh:/root/.ssh \
      -w /work \
      --name $NAME \
      gcp-devops
fi

echo "Starting container - $NAME"
podman start -ai $NAME
