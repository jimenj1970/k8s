# Start the stack in the docker swarm with K8S enabled in Docker Engine

# https://hub.docker.com/_/zookeeper

docker stack --orchestrator swarm deploy --compose-file kafka.yml kafka

# Change kafka_default network the docker with K8S enabled in Docker Engine

# To update an already running docker service:

Create an attachable overlay network:

docker network create --driver overlay --attachable kafka_net

Remove the network stack with a disabled "attachable" overlay network (in this example called: my-non-attachable-overlay-network):

docker service update --network-rm kafka_default kafka_zoo1

Add the network stack with an enabled "attachable" overlay network:

docker service update --network-add kafka_net kafka_zoo1

# Connect to Zookeeper from the Zookeeper command line clientach

docker run -it --rm --link kafka_zoo1.1.ynrtwy4swd89m7jis4p9ufrqy --network kafka_net zookeeper zkCli.sh -server kafka_zoo1.1.xjx5cpm3wdi9efs79xcaqljrg

# Connect to Zookeeper admin server

# added hosts entry for zookeper

http://localhost:8080/commands/stats

docker container exec -it kafka_kafka.1.s6lw3a7sq8t539m072xnw6cdz bash

# single broker

kafka-topics.sh --create --topic Example1 --replication-factor 1 --partitions 1 --zookeeper zoo1
kafka-console-producer.sh --broker-list localhost:9092 --topic Example1
docker container exec -it kafka_kafka.1.s6lw3a7sq8t539m072xnw6cdz kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic Example1 --from-beginning

# multi broker

cp server.properties server1.properties // edit broker id, ports, logs lines
cp server.properties server2.properties // edit broker id, ports, logs lines
kafka-server-start.sh kafka/config/server1.properties
kafka-server-start.sh kafka/config/server2.properties

kafka-topics.sh --describe --zookeeper zoo1 --topic Example2
kafka-topics.sh --create --topic Example2 --replication-factor 2 --partitions 3 --zookeeper zoo1
kafka-console-producer.sh --broker-list localhost:9092 --topic Example2
docker container exec -it kafka_kafka.1.s6lw3a7sq8t539m072xnw6cdz kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic Example2 --from-beginning
