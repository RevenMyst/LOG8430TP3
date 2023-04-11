# To intialize the cluster
docker-compose up -d

# To link the clusters
docker exec -it primary mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"primary\"},
   {_id: 1, host: \"secondary1\"},
   {_id: 2, host: \"secondary2\"},
   {_id: 3, host: \"secondary3\"}
 ]
})"

# To make sure that the cluster is well set
docker exec -it primary mongosh --eval "rs.status()"

# to shutdown instances
docker-compose down