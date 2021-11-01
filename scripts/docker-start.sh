NAME="$(basename $PWD)"

if [ "$(docker ps -qa -f name=$NAME)" ]; then
    echo "Found container - $NAME"
else
  echo "Creating container - $NAME"
  docker create -ti \
      -v "$(pwd)":/work \
      -v "$(pwd)"/.config:/root/.config \
      -v "$(pwd)"/.ssh:/root/.ssh \
      -w /work \
      --name $NAME \
      gcp-devops
fi

echo "Starting container - $NAME"
docker start -ai $NAME
