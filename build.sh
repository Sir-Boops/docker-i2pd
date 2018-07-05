TAGS="2.19.0 latest"
DOCKER_REPO="sirboops/i2pd"

# Build the image
for t in $TAGS;
do
    docker build -t `echo $DOCKER_REPO:$t` .
done

# Upload the images
for t in $TAGS;
do
    docker push `echo $DOCKER_REPO:$t`
done
