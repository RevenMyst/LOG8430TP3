


##========================================================================##

## Run the container for Mongo DB and run the tests
printf "\nRunning Benchmarks on Mongo DB, results can be found in the Mongo folder \n\n"
docker-compose -f Mongo/docker-compose.yml up -d
docker exec -it primary mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"192.168.5.2:27017\"},
   {_id: 1, host: \"192.168.5.3:27017\"},
   {_id: 2, host: \"192.168.5.4:27017\"},
   {_id: 3, host: \"192.168.5.5:27017\"}
 ]
})"
sleep 120
cd YCSB
for i in {1..7}
do
for size in "100" "500" "1000"
do
for prop in "_1_0" "_50_50" "_10_90"
do
workload="workloads/workload_$size$prop"
printf "$workload"
printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workload $size $prop try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P $workload -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workload $size $prop try $i\n" >> ../Mongo/OutputIOLoad.csv
docker stats --no-stream >> ../Mongo/OutputIOLoad.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workload $size $prop try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P $workload -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workload $size $prop try $i\n" >> ../Mongo/OutputIORun.csv
docker stats --no-stream >> ../Mongo/OutputIORun.csv
done
done
done
cd ..
docker-compose -f Mongo/docker-compose.yml down -v
printf "\nFinished benchmarking Mongo DB \n\n"



