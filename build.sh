mkdir -p $PWD/src/output

echo "Spinning staging build container" 
# The --rm option will remove the container but in case something stuck and you close terminal window it will not
# so naming the container please_delete_me
docker run -v $PWD/src/output:/output -u 0 -i --rm --name please_delete_me ubuntu:20.04 /bin/sh < src/build-lightwalletd.sh

LWD_TAG=`cat $PWD/src/output/lwd-version.txt 2>/dev/null`
echo $LWD_TAG
if [ -z "$LWD_TAG" ]
then
   echo "It appears staging container didn't output needed information. Build interrupted, sorry."
   exit
fi
echo Sucessfully built lightwalletd version: $LWD_TAG

container_image_name=lightwalletd:$LWD_TAG 

echo "Building minimal container with lightwalletd"
docker build -t $container_image_name $PWD/src

echo "Build complete, please run 'docker image ls' to see the container it should show: lightwalletd with TAG: $LWD_TAG" 

#cleanup
rm -rf src/output
