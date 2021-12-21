# create the mongo replica set

kubectl apply -f .

# login to one mongo server to configure the replica-set

kubectl exec -it mongo-0 -- mongo
-- rs.initiate()
-- var cfg = rs.conf()
-- cfg.members[0].host="mongo-0.mongo:27017"
-- rs.reconfig(cfg)
-- rs.status()
-- rs.add("mongo-1.mongo:27017")
-- rs.add("mongo-2.mongo:27017")
-- exit

# replica set can only be access within the cluster. no load balancer service enabled

# create a shell to access mongo servers in private service

kubectl run mongo --rm -it --image mongo -- sh
-- mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo
-- mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo --eval 'rs.status()' | grep name

# add a new member to replica-set

# scale the k8s stateful-set

kubectl scale sts mongo --replicas 4
kubectl run mongo --rm -it --image mongo -- sh
-- mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo
-- -- rs.add("mongo-3.mongo:27017")
-- -- exit

kubectl run mongo --rm -it --image mongo -- sh
mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo,mongo-3.mongo --eval 'rs.status()' | grep name

# To expose replica set to external access

# since I am running all pods locally; expose different port numbers

kubectl expose pod mongo-0 --port 27017 --target-port 27017 --type LoadBalancer
kubectl expose pod mongo-1 --port 27018 --target-port 27017 --type LoadBalancer
kubectl expose pod mongo-2 --port 27019 --target-port 27017 --type LoadBalancer
kubectl expose pod mongo-3 --port 27020 --target-port 27017 --type LoadBalancer

# access using the local mongo client install with the correct port number per the service request

mongo mongodb://localhost:27017,localhost:27018,localhost:27019,localhost:27020

# scale back the replica set

mongo mongodb://localhost:27017,localhost:27018,localhost:27019,localhost:27020
-- rs.remove("mongo-3.mongo")
-- exit
kubectl scale sts mongo --replicas 3
kubectl delete service/mongo-3

# connect to config server deployment

kubectl exec -it mongo-cfgsvr-0 -- mongo

rs.initiate(
{
\_id: "cfgrs",
configsvr: true,
members: [
{ _id : 0, host : "mongo-cfgsvr-0.mongo-cfgsvr:27017" },
{ _id : 1, host : "mongo-cfgsvr-1.mongo-cfgsvr:27017" },
{ _id : 2, host : "mongo-cfgsvr-2.mongo-cfgsvr:27017" }
]
}
)

# connect to shard1 deployment

kubectl exec -it mongo-shard1svr-0 -- mongo

rs.initiate(
{
\_id: "shard1rs",
members: [
{ _id : 0, host : "mongo-shard1svr-0.mongo-shard1:27017" },
{ _id : 1, host : "mongo-shard1svr-1.mongo-shard1:27017" },
{ _id : 2, host : "mongo-shard1svr-2.mongo-shard1:27017" }
]
}
)

# connect to shard2 deployment

kubectl exec -it mongo-shard2svr-0 -- mongo

rs.initiate(
{
\_id: "shard2rs",
members: [
{ _id : 0, host : "mongo-shard2svr-0.mongo-shard2:27017" },
{ _id : 1, host : "mongo-shard2svr-1.mongo-shard2:27017" },
{ _id : 2, host : "mongo-shard2svr-2.mongo-shard2:27017" }
]
}
)

# connect to mongos deployment

mongo mongodb://localhost

sh.addShard("shard1rs/mongo-shard1svr-0.mongo-shard1,mongo-shard1svr-1.mongo-shard1,mongo-shard1svr-2.mongo-shard1")
sh.status()
sh.addShard("shard2rs/mongo-shard2svr-0.mongo-shard2,mongo-shard2svr-1.mongo-shard2,mongo-shard2svr-2.mongo-shard2")

sh.enableSharding("zipcodes")
sh.shardCollection("zipcodes.zipcodes", {\_id: "hashed"})
db.zipcodes.getShardDistribution()

var students = [
{name : "Dale Cooper", class: "Calculus", tests: [30, 28, 45]},
{name : "Harry Truman", class: "Geometry", tests: [28, 26, 44]},
{name : "Shelly Johnson", class: "Calculus", tests: [27, 26, 43]},
{name : "Bobby Briggs", class: "College Algebra", tests: [20, 18, 35]},
{name : "Donna Heyward", class: "Geometry", tests: [28, 28, 44]},
{name : "Audrey Horne", class: "College Algebra", tests: [22, 26, 44]},
{name : "James Hurley", class: "Calculus", tests: [20, 20, 38]},
{name : "Lucy Moran", class: "College Algebra", tests: [26, 24, 40]},
{name : "Tommy Hill", class: "College Algebra", tests: [30, 29, 46]},
{name : "Andy Brennan", class: "Geometry", tests: [20, 21, 38]}
];

# books price greater than $130

db.classes.aggregate(
[
{ $match: { 'book.price': { $gt: 130 }}},
{ $project: { 'book.title': "$book.title", 'book.price': "$book.price" } } ]
)

# Total cost for books for all students

db.classes.aggregate(
[
{ $project: { _id: "$book.title", price: "$book.price", total: { $multiply : [{ $size: "$students"}, "$book.price"]}}},
{ $sort: { \_id: 1 }}
]
)

# Reduce to a list of students and how many classes they are enrolled in

db.classes.aggregate(
[
{ $unwind: "$students"},
{ $project: { _id: { $concat: ["$students.fName", " ", "$students.lName"]}}},
{ $group: { _id: "$\_id", value: { $sum: 1}}},
{ $sort: { \_id: 1 }}
]
)

db.ledger.aggregate(
[
{ $unwind: "$details"},
{ $match: { "details.project": "Ricardo Matinata" }},
{ $group: { _id: "$details.project", income: { $eq: { is_debit: falsetotal: { $sum: "$value" }}},
{ $sort: { \_id: 1 }}
]
)

db.orders.aggregate( [
{ $project: { emit: { key: "$cust_id", value: "$price" } } },  // equivalent to the map function
   { $group: {                                                    // equivalent to the reduce function
        _id: "$emit.key",
valuesPrices: { $accumulator: {
                    init: function() { return 0; },
                    initArgs: [],
                    accumulate: function(state, value) { return state + value; },
                    accumulateArgs: [ "$emit.value" ],
merge: function(state1, state2) { return state1 + state2; },
lang: "js"
} }
} } ] )

db.orders.aggregate( [
{ $project: { emit: { key: "$cust_id", value: "$price" } } },  // equivalent to the map function
   { $group: {                                                    // equivalent to the reduce function
        _id: "$emit.key",
valuesPrices: { $accumulator: {
                    init: function() { return 0; },
                    initArgs: [],
                    accumulate: function(state, value) { return state + value; },
                    accumulateArgs: [ "$emit.value" ],
merge: function(state1, state2) { return state1 + state2; },
lang: "js"
} }
} },
{ $sort: { \_id: -1 } },
{ $merge: {
into: "agg_alternative_2",
on: "\_id",
whenMatched: "replace",
whenNotMatched: "insert"
} }
] )

db.zipcodes.aggregate( [
{ $group: { _id: "$city", cityZipCodes: { $addToSet: "$_id" }, cityCount: {$sum: 1}, combinedPopulation: { $sum: "$pop" } } },
{ $sort: {_id: 1 } },
{ $merge: {
into: "city_name_pop",
on: "_id",
whenMatched: "replace",
whenNotMatched: "insert"
} }
] )

# Recover mongo cluster

kubectl exec -it mongo-cfgsvr-0 -- bash
-- mongo
rs.initiate(
{
\_id: "cfgrs",
configsvr: true,
members: [
{ _id : 0, host : "mongo-cfgsvr-0.mongo-cfgsvr:27017" },
{ _id : 1, host : "mongo-cfgsvr-1.mongo-cfgsvr:27017" },
{ _id : 2, host : "mongo-cfgsvr-2.mongo-cfgsvr:27017" }
]
}
)
-- exit
-- exit
kubectl exec -it mongo-cfgsvr-0 -- mongo
rs.initiate({\_id: "cfgrs", configsvr: true, members: [{ _id : 0, host : "mongo-cfgsvr-0.mongo-cfgsvr:27017" }, { _id : 1, host : "mongo-cfgsvr-1.mongo-cfgsvr:27017" },{ _id : 2, host : "mongo-cfgsvr-2.mongo-cfgsvr:27017" }]})
rs.status()
mongo mongodb://localhost
sh.addShard("shard1rs/mongo-shard1svr-0.mongo-shard1,mongo-shard1svr-1.mongo-shard1,mongo-shard1svr-2.mongo-shard1")
sh.status()
sh.addShard("shard2rs/mongo-shard2svr-0.mongo-shard2,mongo-shard2svr-1.mongo-shard2,mongo-shard2svr-2.mongo-shard2")

###### OR

kubectl exec -it mongo-cfgsvr-0 -- mongo --eval "rs.initiate({_id: 'cfgrs', configsvr: true, members: [{ _id : 0, host : 'mongo-cfgsvr-0.mongo-cfgsvr:27017' }, { _id : 1, host : 'mongo-cfgsvr-1.mongo-cfgsvr:27017' },{ _id : 2, host : 'mongo-cfgsvr-2.mongo-cfgsvr:27017' }]})"
sleep 10
mongo mongodb://localhost --eval "sh.addShard('shard1rs/mongo-shard1svr-0.mongo-shard1,mongo-shard1svr-1.mongo-shard1,mongo-shard1svr-2.mongo-shard1')"
mongo mongodb://localhost --eval "sh.addShard('shard2rs/mongo-shard2svr-0.mongo-shard2,mongo-shard2svr-1.mongo-shard2,mongo-shard2svr-2.mongo-shard2')"

# Project Totals

db.ledger.aggregate([
{
$unwind: "$details"
},
{
$group :
                {
                _id : "$details.project",
income:
{
$accumulator:
                                {
                                        init: function() { // Set the initial state
                                                return { debit: 0, credit: 0 }
                                        },
                                        accumulate: function(state, is_debit, value) {
                                                if (is_debit) {
                                                        return {
                                                                debit: state.debit + value,
                                                                credit: state.credit
                                                        }
                                                } else {
                                                        return {
                                                                debit: state.debit,
                                                                credit: state.credit + value
                                                        }
                                                }
                                        },
                                        accumulateArgs: ["$is_debit", "$details.value"],
merge: function(state1, state2) {
return {
debit: state1.debit + state2.debit,
credit: state1.credit + state2.credit
}
},
finalize: function(state) {
return {
total: state.credit + state.debit,
credit: state.credit,
debit: state.debit,
margin: (state.credit + state.debit) / state.debit
}
},
lang: "js"
}
}
}
},
{ $merge: {
into: "project_results",
on: "\_id",
whenMatched: "replace",
whenNotMatched: "insert"
} }
])

db.createView(
"project_results",
"ledger",
[ {
$unwind: "$details"
},
{
$group :
                {
                _id : "$details.project",
income:
{
$accumulator:
                                {
                                        init: function() { // Set the initial state
                                                return { debit: 0, credit: 0 }
                                        },
                                        accumulate: function(state, is_debit, value) {
                                                if (is_debit) {
                                                        return {
                                                                debit: state.debit + value,
                                                                credit: state.credit
                                                        }
                                                } else {
                                                        return {
                                                                debit: state.debit,
                                                                credit: state.credit + value
                                                        }
                                                }
                                        },
                                        accumulateArgs: ["$is_debit", "$details.value"],
merge: function(state1, state2) {
return {
debit: state1.debit + state2.debit,
credit: state1.credit + state2.credit
}
},
finalize: function(state) {
return {
total: state.credit + state.debit,
credit: state.credit,
debit: state.debit,
margin: (state.credit + state.debit) / state.debit
}
},
lang: "js"
}
}
}
} ]
)

db.ledger.aggregate([
{ $unwind: "$details"},
{ $match: {"details.project":"Ricardo Matinata", is_debit: true}},
{$group:{_id: "$details.project", credit: { $sum: "$value"}}}
])

db.ledger.aggregate([
{ $unwind: "$details"},
{ $match: {"details.project":"Ricardo Matinata", is_debit: false}},
{ $project: {_id: "$details.project", payment_type: "$payment_type", value: "$details.value}},
{ $group: { _id: "$payment_type", count: { $sum: 1 }}}
])

# List of projects
db.runCommand({"distinct" : "ledger", "key" : "details.project"}) 

# 
db.runCommand(
   {
     aggregate:
       {
       	 // The collection
         ns: 'ledger',
         // Keys to retrieve
         key: { 'details.project': 1, 'details.project_id': 1, 'details.category': 'Framing' },
         // Condition that must be metu
         cond: { 'value': { $gt: 1000 } },
         // Not reducing the results
         $reduce: function ( curr, result ) { },
         // Stores the initial value the first time reduce is called
         initial: { }
       }
   }
)