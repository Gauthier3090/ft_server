docker stop test
docker rm test
#docker system prune -a
docker build -t gpladet .
docker run --name test -p 80:80 -p 443:443 -d gpladet:latest
docker ps -a
docker exec -ti test /bin/bash
