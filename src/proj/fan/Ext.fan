using afMongo

@ExtMeta
abstract const class Ext {
  new make() {}
  virtual Void initializeDB( Collection collection ) {}
}
