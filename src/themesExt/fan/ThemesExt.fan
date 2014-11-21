using afBson
using db
using proj
using util
using web

@ExtMeta {
  name = "themes"
  app = themesExt::ThemesApp#
  icon = "themes-50.png"
}
const class ThemesExt : Ext, Weblet {
  override Void onGet() { _get( req.modRel.pathOnly.toStr ) }
  
  override Void onPost() {
    in := JsonInStream( req.in )
    data := in.readJson
    in.close
    reqTheme := ObjectId( req.modRel.pathOnly.toStr, false )
    db := DBConnector.cur.db[ "themes" ]
    if ( reqTheme == null || db.findAndUpdate( ["_id":reqTheme], data, false ) == null ) {
      document := db.findAndUpdate( ["_false":true], data, true, ["upsert":true] )
      reqTheme = document[ "_id" ]
    }
    _get( reqTheme.toStr )
  }
  
  private Void _get( Str _id ) {
    Str:Obj? json := [:]
    settingsDoc := DBConnector.cur.db[ "settings" ].findOne( ["ext":"themesExt"], false )
    defaultId := settingsDoc[ "default" ].toStr
    reqTheme := ObjectId( _id, false )
    db := DBConnector.cur.db[ "themes" ]
    if ( reqTheme != null && _id != defaultId ) {
      if ( req.uri.query[ "default" ] == "true" ) {
        settingsDoc[ "default" ] = reqTheme
        if ( DBConnector.cur.db[ "settings" ].update( ["ext":"themesExt"], settingsDoc ) > 0 ) defaultId = settingsDoc[ "default" ].toStr
      }
      if ( req.uri.query[ "delete" ] == "true" && db.delete( ["_id":reqTheme] ) > 0 ) reqTheme = ObjectId( defaultId )
    }
    json[ "myTheme" ] = defaultId
    json[ "list" ] = db.group( ["_id", "title"], [:], Code.makeCode( "function(){}" ) )
    if ( reqTheme != null && ( ([Str:Obj?][]) json[ "list" ] ).any |map| { map[ "_id" ] == reqTheme } ) {
      document := db.findOne( ["_id":reqTheme], false )
      json[ "selected" ] = document
    }
    ( ([Str:Obj?][]) json[ "list" ] ).find |theme| { theme[ "_id" ].toStr == defaultId }?.set( "default", true )
    content := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = content.size.toStr
    out := res.out
    out.writeChars( content )
    out.close
    res.done
  }
  
  static Str:Str getTheme( Str id ) {
    [Str:Obj?]? document
    try document = DBConnector.cur.db[ "themes" ].findOne( ["_id":ObjectId( id )], false )
    catch ( Err e ) {}
    map := [:]
    if ( document == null ) return map
    |Str, Obj?, Str|? eachFunc
    eachFunc = |Str leading, Obj? v, Str k| {
      if ( v is Str:Obj? ) {
        ( (Str:Obj?) v ).each( eachFunc.bind( [leading + "." + k] ) )
      } else if ( v != null ) map[ leading + "." + k ] = v.toStr
    }
    document.each( eachFunc.bind( ["themes"] ) )
    return map
  }
}
