
1. Create a ECR Private Repository.




2. Pull the docker image of node exporter in ec2 instance with awscli or in cloushell

  docker pull prom/node-exporter

====================================
You will get something like this,

docker pull prom/node-exporter
Using default tag: latest
latest: Pulling from prom/node-exporter
9fa9226be034: Pull complete 
1617e25568b2: Pull complete 
2427db72832c: Pull complete 
Digest: sha256:3ac34ce007accad95afed72149e0d2b927b7e42fd1c866149b945b84737c62c3
Status: Downloaded newer image for prom/node-exporter:latest
docker.io/prom/node-exporter:latest




3. Go to awscli and run 

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin xxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com

docker tag prom/node-exporter:latest xxxxxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/node-exporter-1:latest

docker push xxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/node-exporter-1:latest

( You can get these push commands in ecr repo aws console)


Once the image is pushed to the private repo of ECR, Copy the Image URI from the console and replate it in the terraform.tfvars file.

container_image = xxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/node-exporter-1:latest

