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

const class DBConnector {
  static const DBConnector cur := DBConnector(
    Env.cur.config( Pod.find( "db" ), "host" ) ?: "",
    Env.cur.config( Pod.find( "db" ), "port" )?.toInt ?: 0,
    Env.cur.config( Pod.find( "db" ), "database" ) ?: "fantomcms",
    Env.cur.config( Pod.find( "db" ), "username" ),
    Env.cur.config( Pod.find( "db" ), "password" ) )
  
  // Fields
  
  /// The ConnectionManagerPooled that will manage our connections to the MongoDB
  private const ConnectionManagerPooled cm
  
  /// The MongoClient that this Database Connector will use to communicate with
  /// the server.
  private const MongoClient? mc
  
  /// The Database object that we will primarily be working with.
  private const Str databaseName
  Database db() { try { return mc.db( databaseName ) } catch ( NullErr e ) { throw Err( "Database did not connect.  Please configure it and reconnect the server." ) } }
  
  // Constructor
  /// Can be provided with a username, password, and database to be used to connect
  /// to the MongoDB. The first databaseName is the name of the database that the
  /// server will primarily work with. If the username and password are null, it 
  /// will simply connect with no authentication (which is the default for MongoDB). 
  /// If username and password are provided but authdatabase is null, it will use 
  /// the admin database to check authentication.
  private new make( Str host, Int port, Str databaseName := "fantomcms", Str? username := null, 
                    Str? password := null, Str authDatabase := "admin") {
    address := "$host:$port"
    if ( username != null && password != null ) address = "$username:$password@$address/$authDatabase"
    address = "mongodb://" + address
    this.databaseName = databaseName
    cm = ConnectionManagerPooled( ActorPool(), address.toUri )
    try { mc = MongoClient( cm ) } catch ( Err e ) {}
  }
  
  // Public
  override Str toStr() { cm.connectionUri.toStr }
  
  // Startup will take in a list of strings containing the
  // names of the collections we will be using. It will ensure
  // that all the collections we need for the app have been
  // created on the Mongo server.
  Void startup( Str[] collections ) {
    echo( "\nChecking that all required collections exist on server... " )
    collections.each |Str name| {
      if ( collectionExists( name ) ) {
        echo( "${name}...exists." )
      } else {
        makeCollection( name )
        echo( "${name}...doesn't exist. Created." )
      }
    }
    echo( "Database setup completed." )
  }
  
  /// put will enter a DBEntry into the database in the appropriate
  /// collection (depending on its "app" field). It will throw an
  /// error if you don't fill out the detail or if the collection
  /// doesn't exist.
  Void put( DBEntry o ) {
    collection := getCollection( o.app )
    collection.insert( o.getMap )
  }
  
  /// get will find entries in the provided collection matching the
  /// query that you provide. It will by
  DBEntry[] get( Str name, Str:Str? query, Int limit := 0 ) {
    collection := getCollection( name )
    result := limit > 0 ? collection.findAll( query, null, 0, limit ) : collection.findAll( query )
    return result.map |map| { DBEntry( map ) }
  }
  
  /// delete will remove an object from the database. You should get
  /// the object first before removing it so you have the _id.
  Void delete ( DBEntry o ) {
    if ( o._id == null ) throw DBErr( "delete", "Cannot delete an object with no _id. (Are you sure it was added to the database?)" )
    collection := getCollection( o.app )
    collection.delete( ["_id":o._id] )
  }
  
  // Private
  
  // Returns a Collection. Throws an error if the collection
  // doens't exist.
  private Collection getCollection( Str name ) {
    if ( !collectionExists( name ) ) throw DBErr ("exists", "Collection ${name} doesn't exist.")
    return db.get(name)
  }

  /// Checks if a collection exists in the database. Returns
  /// true if so, otherwise returns false.
  private Bool collectionExists( Str name ) { db.collection( name ).exists }
  
  /// Creates a new collection in the database.
  /// Throws DBErr if the collection exists.
  private Void makeCollection( Str name ) {
    if ( collectionExists( name ) ) throw DBErr( "exists", "makeCollection called when the collection ($name) already exists." )
    db.collection( name ).create
    if ( !collectionExists( name ) ) throw DBErr ("failed", "Failed to create collection.")
  }

  /// Delete a collection in the database.
  /// Throws DBErr if the collection doesn't exist.
  Void deleteCollection( Str name ) {
    if ( !collectionExists( name ) ) throw DBErr( "exists", "deleteCollection called when the collection ($name) doesn't exist." )
    db.collection( name ).drop
    if ( collectionExists( name ) ) throw DBErr ("failed", "Failed to delete collection.")
  }
}

// Classes


/// DBEntry represents an entry in the database. It can be created
/// directly, or created using the Factory method.
@Serializable
class DBEntry {
  Str app
  Str:Str? entryData := [:]
  Str? bsonData
  ObjectId? _id

  new make ( Str app ) {
    this.app = app
  }
  
  /// getFromMap is a static method getting an entry from
  /// a map.
  static new makeFromMap( Str:Obj? map ) {
    newMap := map.dup
    toReturn := DBEntry( (Str) newMap.remove( "app" ) )
    if ( newMap.containsKey( "_id" ) ) toReturn._id = newMap.remove( "_id" )
    if ( newMap.containsKey( "bsonData" ) ) toReturn.bsonData = newMap.remove( "bsonData" )
    toReturn.setAll( newMap )
    return toReturn
  }
  
  @Operator
  Void set( Str key, Str? val ) { entryData[key] = val }
  Void setAll( Str:Str? vals ) { entryData.setAll( vals ) }
  Void setBsonData( Obj:Obj? o ) { bsonData = writeBson(o) }
  
  @Operator
  Str get( Str key ) { entryData[key] ?: throw DBErr("notfound", "Key ${key} was not found.") }
  Str:Str? getAll( Str[] tags ) {
    toReturn := Str:Str?[:]
    tags.each |Str key| { toReturn[key] = entryData[key] }
    return toReturn
  }
  Str:Obj? getBsonData() { readBson( bsonData ) }

  /// getMap returns the map representing this object.
  Str:Str getMap() {
    toReturn := entryData.dup
    /*
    toReturn := [
      "app"       : app,
      ]
    toReturn.addAll( entryData )
    */
    if (this.bsonData != null) toReturn["bsonData"] = bsonData
    return toReturn
  }

  static private Str:Obj? readBson( Str string ) { BsonReader( string.in ).readDocument }

  static private Str writeBson( Obj:Obj? o ) {
    Buf b := Buf()
    BsonWriter( b.out ).writeDocument( o )
    return b.flip.in.readAllStr
  }
}

/// DCErr : DatabaseConnector Err that also has a tag where we can put
/// a reason.
const class DBErr : Err {
  const Str tag

  new make (Str tag, Str s, Err? e := null) : super(s, e) {
    this.tag = tag
  }
  
  override Str toStr() { "Tag:[$this.tag] Message:[$this.msg]" }
}
