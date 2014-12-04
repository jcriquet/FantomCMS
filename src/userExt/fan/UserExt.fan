using proj
using util
using web
using db
using afBson

@ExtMeta {
  name = "user"
  app = userExt::UserApp#
  icon = "users-50.png"
}
const class UserExt : Ext, Weblet {
  override Void onGet() {
    Obj? data
    paths := req.modRel.path
    switch ( paths[0] ) {
      case "list":
        data = db.group( ["_id", "name"], [:], emptyCode, ["cond":["type":paths[1]]] )
        if ( data->size == 0 ) data = null
      case "get":
        data = db.findOne( ["name":paths[2],"type":paths[1]], false )
    }
    if ( data == null ) { res.sendErr(404); return }
    out := JsonOutStream.writeJsonToStr( data )
    res.headers[ "Content-Type" ] = "application/json"
    res.headers[ "Content-Length" ] = out.size.toStr
    res.out.writeChars( out ).close
    res.done
  }
  
  override Void onPost() {
    paths := req.modRel.path
    switch( paths[0] ){
      case "edit":
        map := Str:Obj?[:].addAll( req.form )
        if ( !map.containsKey( "name" ) ) { res.sendErr( 404 ); return }
        if ( paths.getSafe( 1 ) == "new" && db.group( [,], [:], emptyCode, ["cond":["name":map["name"],"type":map["type"]]] ).size > 0 ) { res.sendErr( 304 ); return }
        if ( map.containsKey( "permissions" ) ) map[ "permissions" ] = JsonInStream( map[ "permissions" ]->in ).readJson
        db.update( ["name":map["name"],"type":map["type"]], map, false, true )
      case "delete":
        if ( paths.size < 3 ) { res.sendErr( 404 ); return }
        i := db.delete( ["name":req.in.readAllStr,"type":paths[1]] )
        if ( i > 0 ) { res.sendErr( 404 ); return }
      default:
        res.sendErr( 404 );
        return
    }
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = "0"
    res.done
  }
  
  // Returning null means all permissions
  static Str[]? getPerms(Str? name){
    group := getGroup( getUser( name )["group"] )
    if ( group["permissions"] == true ) return null
    return ( group["permissions"] as Str:Obj? )?.findAll |v| { v == true }?.keys ?: [:]
  }
  
  static Bool checkPerm(Str? name, Str app){
    checkGroupPerm( getUser( name )["group"], app )
  }
  
  static Bool checkGroupPerm(Str? name, Str app){
    if ( getGroup( name )["permissions"] == true ) return true
    return app == "login" || ( ( getGroup( name )["permissions"] as Str:Obj? )?.get( app ) as Bool ?: false )
  }
  
  static [Str:Obj?] getUser(Str? name){
    if ( name == null ) name = "guest"
    data := DBConnector.cur.db[ "userExt" ].findOne( ["name":name,"type":"user"], false ) as Str:Obj?
    if ( data == null ) {
      if ( name != "guest" ) return [:]
      data = DBConnector.cur.db[ "userExt" ].findAndUpdate( ["name":"guest","type":"user"], ["name":"guest", "type":"user", "password":null, "group":"guest"], true, ["upsert":true] )
    }
    return data
  }
  
  static Str:Obj? getGroup(Str? name){
    if ( name == null ) name = "guest"
    data := DBConnector.cur.db[ "userExt" ].findOne( ["name":name,"type":"group"], false ) as Str:Obj?
    if ( data == null ) {
      if ( name != "guest" ) return [:]
      data = DBConnector.cur.db[ "userExt" ].findAndUpdate( ["name":"guest","type":"group"], ["name":"guest", "type":"group", "permissions":["login":true, "home":true, "settings":true]], true, ["upsert":true] )
    }
    return data
  }
  
  static Bool checkPass(Str name, Str pass){
    data := DBConnector.cur.db[ "userExt" ].findAll(["name":name,"type":"user"]) as [Str:Obj?][]
    if(data == null) return false
    return pass == data[0]["password"]
  }
}
