# mongo commands

# checklist is the db

use checklist

# ledger is the collection

db.ledger.aggregate([
{
$match: { IsDebit: false }
},
{
$group: {
_id: null,
total:
{
$sum: "$Value"
}
}
}
] )

db.ledger.count()

db.orders.insertMany([
{ cust_id: "abc1", ord_date: ISODate("2012-11-02T17:04:11.102Z"), status: "A", amount: 50 },
{ cust_id: "xyz1", ord_date: ISODate("2013-10-01T17:04:11.102Z"), status: "A", amount: 100 },
{ cust_id: "xyz1", ord_date: ISODate("2013-10-12T17:04:11.102Z"), status: "D", amount: 25 },
{ cust_id: "xyz1", ord_date: ISODate("2013-10-11T17:04:11.102Z"), status: "D", amount: 125 },
{ cust_id: "abc1", ord_date: ISODate("2013-11-12T17:04:11.102Z"), status: "A", amount: 25 }
])

db.orders.aggregate([
{ $match: { status: "A" } },
{ $group: { _id: "$cust_id", total: { $sum: "$amount" } } },
{ $sort: { total: -1 } }
])

db.myCollation.insertMany([{ _id: 1, category: "café", status: "A" },
{ _id: 2, category: "cafe", status: "a" },
{ _id: 3, category: "cafE", status: "a" }
])
db.myCollation.aggregate(
[ { $match: { status: "A" } }, { $group: { _id: "$category", count: { $sum: 1 } } } ],
{ collation: { locale: "fr", strength: 1 } }
);

db.foodColl.insert([
{ _id: 1, category: "cake", type: "chocolate", qty: 10 },
{ _id: 2, category: "cake", type: "ice cream", qty: 25 },
{ _id: 3, category: "pie", type: "boston cream", qty: 20 },
{ _id: 4, category: "pie", type: "blueberry", qty: 15 }
])
db.foodColl.createIndex( { qty: 1, type: 1 } );
db.foodColl.createIndex( { qty: 1, category: 1 } );

> db.movies.insert({ title : "Jaws", year : 1975, imdb : "tt0073195" }
> ... )
> WriteResult({ "nInserted" : 1 })
> db.movies.aggregate( [ { $match: { year : 1975 } } ], { comment : "match_all_movies_from_1975" } ).pretty()
> {

        "_id" : ObjectId("601c6e171a3dbbc48e61f7a8"),
        "title" : "Jaws",
        "year" : 1975,
        "imdb" : "tt0073195"

}

> db.movies.aggregate( [ { $match: { year : 1975 } } ], { comment : "match_all_movies_from_1975" } ).pretty()

mongoimport --host localhost --db reference --collection zipcodes --file ./zips.json
db.zipcodes.aggregate( [
{ $group: { _id: "$state", totalPop: { $sum: "$pop" } } },
{ $match: { totalPop: { $gte: 10*1000*1000 } } }
] )

db.zipcodes.aggregate( [
{ $group:
{
_id: { state: "$state", city: "$city" },
pop: { $sum: "$pop" }
}
},
{ $sort: { pop: 1 } },
{ $group:
{
_id : "$_id.state",
biggestCity: { $last: "$_id.city" },
biggestPop: { $last: "$pop" },
smallestCity: { $first: "$_id.city" },
smallestPop: { $first: "$pop" }
}
},
{ $sort: { smallestCity: 1 } }
] )

db.zipcodes.aggregate( [
{ $group:
{
_id: { state: "$state", city: "$city" },
pop: { $sum: "$pop" }
}
},
{ $sort: { pop: 1 } },
{ $group:
{
_id : "$_id.state",
biggestCity: { $last: "$_id.city" },
biggestPop: { $last: "$pop" },
smallestCity: { $first: "$_id.city" },
smallestPop: { $first: "$pop" }
}
},
{ $sort: { smallestCity: 1 } }
] )

db.ledger.aggregate( [
{
$match:
{
Name: "Javier Jimenez", IsDebit: false,
},
},
{
$group:
{
_id: null,
total:
{
$sum: "$Value"
}
}
}
] )

db.ledger.aggregate([
{
$match:
{
Name: "Javier Jimenez", IsDebit: false
}
},
{
$group:
{
_id: $Name,
total:
{
$sum: "$Value"
}
}
}
] )

db.ledger.aggregate([
{
$match:
{
Project: "Ricardo Matinata", IsDebit: true, Source: "Javier"
}
},
{
$group:
{
_id: $Name,
total:
{
$sum: "$Value"
}
}
}
] )

# Replica set configuration

## hosts config file

# Config for replica set example. this machine has 3 containers running

# one on default port (27017) the others on port 2018 and 27019

192.168.1.189 mongodb0
192.168.1.189 mongodb1
192.168.1.189 mongodb2

mkdir mongodb0-repl-data-directory
mkdir mongodb1-repl-data-directory
mkdir mongodb2-repl-data-directory
docker run -d --name mongodb0 -p 27017:27017 -v mongodb0-repl-data-directory:/data/db mongo --replSet "rs0"
docker run -d --name mongodb1 -p 27018:27017 -v mongodb1-repl-data-directory:/data/db mongo --replSet "rs0"
docker run -d --name mongodb2 -p 27019:27017 -v mongodb2-repl-data-directory:/data/db mongo --replSet "rs0"

rs.initiate( {
\_id: "rs0",
members: [
{ _id: 0, host: "mongodb0:27017" },
{ _id: 1, host: "mongodb1:27018" },
{ _id: 2, host: "mongodb2:27019" }
]
} )
