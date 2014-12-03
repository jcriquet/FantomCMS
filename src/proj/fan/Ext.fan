using afMongo
using afBson
using db

@ExtMeta
abstract const class Ext {
  static Code emptyCode() { Code.makeCode( "function(){}" ) }
  new make() {}
  virtual Void initializeDB( Collection collection ) {}
  Collection db() { DBConnector.cur.db[typeof.pod.toStr] }
}
