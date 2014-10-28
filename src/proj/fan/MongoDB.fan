// FantomCMS - MongoDB Class
// Author:     Cole Grim
// Desc:       Provides a Database Connection to a MongoDB for the FantomCMS
//             server to interface with.
// Version:    0.1
// Notes:      Uses afMongo and afBson by FantomFactory, under the MIT License

using afMongo
using afBson
using concurrent
using inet

class MongoDB
{
  // Fields
  /// Store the full URI we use to connect to the MongoDB
  Uri address
  
  /// The ConnectionManagerPooled that will manage our connections to the MongoDB
  private ConnectionManagerPooled cm
  
  /// The MongoClient that this Database Connector will use to communicate with
  /// the server.
  private MongoClient mc
  
  /// The Database object that we will primarily be working with.
  private afMongo::Database db
  
  // Constructor
  /// Can be provided with a username, password, and database to be used to connect
  /// to the MongoDB. The first databaseName is the name of the database that the
  /// server will primarily work with. If the username and password are null, it 
  /// will simply connect with no authentication (which is the default for MongoDB). 
  /// If username and password are provided but authdatabase is null, it will use 
  /// the admin database to check authentication.
  new make(Str host, Int port, Str databaseName := "fantomcms", Str? username := null, 
    Str? password := null, Str authDatabase := "admin")
  {
    if(username != null && password != null)
    {
      this.address = Uri.fromStr("mongodb://${username}:${password}@${host}:${port.toStr}/${authDatabase}")
    } else {
      this.address = Uri.fromStr("mongodb://${host}:${port.toStr}")
    }
    this.cm = ConnectionManagerPooled(ActorPool(), this.address)
    mc = MongoClient(this.cm)
    db = mc.get(databaseName)
  }
  
  // Public
  override Str toStr()
  {
    return this.address.toStr
  }
  
  // Startup will take in a list of strings containing the
  // names of the collections we will be using. It will ensure
  // that all the collections we need for the app have been
  // created on the Mongo server.
  Void startup(Str[] collections)
  {
    echo("\nChecking that all required collections exist on server... ")
    collections.each |Str name|
    {
      try{
        getCollection(name)
        echo("${name}...exists.")
      }catch{
        this.makeCollection(name)
        echo("${name}...doesn't exist. Created.")
      }
    }
    echo("Database setup completed.")
  }

  /// put will entry a DBEntry into the database in the appropriate
  /// collection (depending on its "app" field). It will throw an
  /// error if you don't fill out the detail or if the collection
  /// doesn't exist.
  Void put(DBEntry o)
  {
    collection := getCollection(o.app)
    collection.insert(o.getMap)
  }
  
  /// get will find entries in the provided collection matching the
  /// query that you provide. It will by
  DBEntry[] get(Str name, Str:Str? query, Int limit := -1)
  {
    collection := getCollection(name)
    [Str:Obj?][]? result 
    if(limit == -1)
    {
      result = collection.findAll(query)
    }else if (limit > 0){
      result = collection.findAll(query, null, 0, limit)
    }else{
      throw DBErr("limit", "Bad limit provided to get")
    }
    DBEntry[] toReturn := [,]
    if(result != null && !result.isEmpty)
    {
      result.each |a|
      {   
        toReturn.add(DBEntry.getFromMap(a))
      }
    }
    return toReturn
  }
  
  /// delete will remove an object from the database. You should get
  /// the object first before removing it so you have the _id.
  Void delete(DBEntry o)
  {
    if(o._id == null){
      throw DBErr("delete", "Cannot delete an object with no _id. (Are you sure it was added to the database?)")
    }
    collection := getCollection(o.app)
    collection.delete(["_id":o._id])
  }
  

  // Private
  
  // Returns a Collection. Throws an error if the collection
  // doens't exist.
  private Collection getCollection(Str name)
  {
    if(!collectionExists(name))
    {
      throw DBErr ("exists", "Collection ${name} doesn't exist.")
    }
    return db.get(name)
  }

  /// Checks if a collection exists in the database. Returns
  /// true if so, otherwise returns false.
  private Bool collectionExists(Str name)
  {
    names := db.collectionNames
    for(Int i := 0; i < names.size; i++)
    {
      if(names[i] == name) { return true }
    }
    return false
  }
  
  /// Creates a new collection in the database.
  /// Throws DBErr if the collection exists.
  private Void makeCollection(Str name)
  {
    if(collectionExists(name))
    {
      throw DBErr ("exists", "makeCollection called "
        + "when the collection (${name}) already exists.")
    }
    c := db.collection(name)
    c.create
    if(!collectionExists(name))
    {
      throw DBErr ("failed", "Failed to create collection.")
    }
  }

  /// Delete a collection in the database.
  /// Throws DBErr if the collection doesn't exist.
  Void deleteCollection(Str name)
  {
    if(!collectionExists(name))
    {
      throw DBErr ("exists", "deleteCollection called "
        + "when the collection (${name}) doesn't exist.")
    }
    c := db.collection(name)
    c.drop
    if(collectionExists(name))
    {
      throw DBErr ("failed", "Failed to delete collection.")
    }
  }

}

// Classes


/// DBEntry represents an entry in the database. It can be created
/// directly, or created using the Factory method.
@Serializable
class DBEntry
{
  Str app
  Str:Str? entryData
  Str? bsonData
  ObjectId? _id

  new make(Str app)
  {
    this.app = app
    this.entryData = [:]
  }
  
  Void addTag(Str key, Str val)
  {
    this.entryData[key] = val
  }
  
  Void addTagMap(Str:Str? vals)
  {
    vals.each |val, key| 
    {   
      this.entryData[key] = val
    }
  }
  
  Void addBsonData(Obj o)
  {
    this.bsonData = writeBson(o)
  }

  Str getTag(Str key)
  {
    if(!this.entryData.containsKey(key))
    {
      throw DBErr("notfound", "Key ${key} was not found.")
    }
    return this.entryData[key]
  }
  
  Str:Str? getTagMap(Str[] toGet)
  {
    toReturn := [:]
    toGet.each |Str key|
    {   
      toReturn.add(key, this.entryData.get(key))
    }
    return toReturn
  }
  
  [Str:Obj?] getBsonData()
  {
    return readBson(this.bsonData)
  }
  
  // Private
  /// getFromMap is a static method getting an entry from
  /// a map.

  static DBEntry getFromMap([Str:Obj?] map)
  {
    toReturn := DBEntry (map["app"])
    map.each |V, K| 
    {   
      if(K == "app" || K == "bsonData" || K == "_id") return
      else toReturn.addTag(K, V)
    }
    if(map.containsKey("bsonData"))
    {
      toReturn.bsonData = map.get("bsonData")
    }
    if(map.containsKey("_id"))
    {
      toReturn._id = map["_id"]
    }
    return toReturn
  }

  /// getMap returns the map representing this object.
  Map getMap()
  {
    toReturn := [
      "app"       : this.app,
      ]
    this.entryData.each |V, K| 
    {   
      toReturn[K] = V
    }
    if(this.bsonData != null) toReturn["bsonData"] = this.bsonData
    return toReturn
  }

  static private [Str:Obj?] readBson(Str string){
    Str toProcess := string
    return BsonReader(toProcess.toBuf.in).readDocument
  }

  static private Str writeBson([Obj:Obj?] o)
  {
    Buf b := Buf()
    BsonWriter(b.out).writeDocument(o)
    return b.flip.in.readAllStr
  }
}

/// DCErr : DatabaseConnector Err that also has a tag where we can put
/// a reason.
const class DBErr : Err
{
  const Str tag

  new make (Str tag, Str s, Err? e := null) : super(s, e) 
  {
    this.tag = tag
  }
  
  override Str toStr()
  {
    return "Tag:[${this.tag}]" + "Message:[${this.msg}]"
  }
}
