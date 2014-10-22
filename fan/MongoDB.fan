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
  private Database db
  
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
    if(o.detail == null)
    {
      throw DBErr ("insert", "Cannot put an object with no detail.")
    }
    collection := getCollection(o.app)
    collection.insert(o.getMap)
  }
  
  /// get will find entries in the provided collection matching the
  /// query that you provide.
  DBEntry[] get(Str name, [Str:Str?]query)
  {
    collection := getCollection(name)
    [Str:Obj?][] result := collection.findAll(query)
    toReturn := [,]
    if(!result.isEmpty)
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
  Str? app
  Str? title
  Str? created
  Str? author
  Str[]? tags
  Obj? detail
  Bool bsonDetail
  ObjectId? _id
  
  /// addBsonDetail allows you to add a BSON object
  /// to the details field.
  Void addBsonDetail([Obj:Obj?] o)
  {
    Buf b := Buf()
    BsonWriter(b.out).writeDocument(o)
    this.detail = b.flip.in.readAllStr
    this.bsonDetail = true
  }
  
  // Private
  /// getFromMap is a static method getting an entry from
  /// a map.
  static DBEntry getFromMap([Str:Obj?] map)
  {
    toReturn := DBEntry
    {
       it.app = map["app"]
       it.title = map["title"]
       it.created = map["created"]
       it.author = map["author"]
       it.tags = map["tags"]
       it.detail = map["detail"]
       it.bsonDetail = map["bsonDetail"]
    }
    if(map.containsKey("_id"))
    {
      toReturn._id = map["_id"]
    }
    if(toReturn.bsonDetail)
    {
      toReturn.detail = toReturn.readBsonObject
    }
    return toReturn
  }

  /// getMap returns the map representing this object.
  Map getMap()
  {
    toReturn := [
      "app" : this.app,
      "title" : this.title,
      "created" : this.created,
      "author" : this.author,
      "tags" : this.tags,
      "detail" : this.detail,
      "bsonDetail" : this.bsonDetail
      ]
    return toReturn
  }
  /// readBsonObject reads the BSON from the detail.
  private [Str:Obj?] readBsonObject(){
    if(!this.bsonDetail) { throw DBErr("object", "readBsonObject called on a non-bson object") }
    Str toProcess := this.detail
    return BsonReader(toProcess.toBuf.in).readDocument
  }
}

/// DBEntryFactory is a convenience method that uses the factory
/// idea commonly seen in Java. You can set the fields once and
/// only update the ones that need changing, and generate objects
/// quickly using the getEntry method.
class DBEntryFactory
{
  Str? app
  Str? title
  Str? created
  Str? author
  Str[]? tags
  Str? detail
  Bool bsonDetail

  /// Creates a new factory with the app set to the appropriate
  /// value.
  new make(Str app)
  {
    this.app = app
    this.bsonDetail = false
  }
  
  /// Adds a BSON object to the detail field.
  Void addBsonDetail([Obj:Obj?] o)
  {
    Buf b := Buf()
    BsonWriter(b.out).writeDocument(o)
    this.detail = b.flip.in.readAllStr
    this.bsonDetail = true
  }
  
  /// Generates an Entry with the fields the factory
  /// currently has. Throws an error if the detail
  /// is not set.
  DBEntry getEntry()
  {
    if(this.detail == null)
    {
      throw DBErr("object", "Detail cannot be null.")
    }

    toReturn := DBEntry
    {
       it.app = this.app
       it.title = this.title
       it.created = this.created
       it.author = this.author
       it.tags = this.tags
       it.detail = this.detail
       it.bsonDetail = this.bsonDetail
    }
    return toReturn
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