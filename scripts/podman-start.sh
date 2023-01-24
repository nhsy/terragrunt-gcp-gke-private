NAME="$(basename $PWD)"-$RANDOM

# Create mount dirs if missing
test -d .config || mkdir .config
test -d .ssh || mkdir .ssh

echo "Starting container - $NAME"
podman run -ti --rm \
    -v "$(pwd)"/.config:/root/.config \
    -v "$(pwd)"/.ssh:/root/.ssh \
    -v "$(pwd)":/work \
    -w /work \
    --name $NAME \
    dizzyplan/gcp-devops-image
