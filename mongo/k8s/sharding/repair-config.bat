kubectl exec -it mongo-cfgsvr-0 -- mongo --eval "rs.initiate({_id: 'cfgrs', configsvr: true, members: [{ _id : 0, host : 'mongo-cfgsvr-0.mongo-cfgsvr:27017' }, { _id : 1, host : 'mongo-cfgsvr-1.mongo-cfgsvr:27017' },{ _id : 2, host : 'mongo-cfgsvr-2.mongo-cfgsvr:27017' }]})"
sleep 20
call mongo mongodb://localhost --eval "sh.addShard('shard1rs/mongo-shard1svr-0.mongo-shard1,mongo-shard1svr-1.mongo-shard1,mongo-shard1svr-2.mongo-shard1')"
sleep 20
call mongo mongodb://localhost --eval "sh.addShard('shard2rs/mongo-shard2svr-0.mongo-shard2,mongo-shard2svr-1.mongo-shard2,mongo-shard2svr-2.mongo-shard2')"
sleep 20
call mongo mongodb://localhost --eval "sh.status()"

