using afBson
using db
using layoutsExt
using proj
using util
using web

@ExtMeta {
  name = "themes"
  app = themesExt::ThemesApp#
  icon = "themes-50.png"
}
const class ThemesExt : Ext, Weblet {
  static const Type stype := ThemesExt#
  override Void onGet() {
    query := req.modRel.query
    _get( req.modRel.pathOnly.toStr, query[ "layout" ] )
  }
  
  override Void onPost() {
    in := JsonInStream( req.in )
    data := in.readJson as Str:Obj?
    in.close
    reqTheme := ObjectId( req.modRel.pathOnly.toStr, false )
    if ( data != null ) {
      if ( data[ "layout" ] == null ) data[ "layout" ] = LayoutsExt.getSettings[ "default" ]
      else data[ "layout" ] = ObjectId( data[ "layout" ], false )
      if ( data[ "layout" ] == null ) return
      db := DBConnector.cur.db[ typeof.pod.toStr ]
      if ( reqTheme == null || db.findAndUpdate( ["_id":reqTheme], data, false ) == null ) {
        document := db.findAndUpdate( ["_false":true], data, true, ["upsert":true] )
        reqTheme = document[ "_id" ]
      }
    }
    _get( reqTheme.toStr, null )
  }
  
  private Void _get( Str _id, Str? forcedLayout ) {
    Str:Obj? json := [:]
    settingsDoc := getSettings
    defaultId := settingsDoc[ "default" ].toStr
    reqTheme := ObjectId( _id, false )
    db := DBConnector.cur.db[ typeof.pod.toStr ]
    if ( reqTheme != null && _id != defaultId ) {
      if ( req.uri.query[ "default" ] == "true" ) {
        settingsDoc[ "default" ] = reqTheme
        if ( DBConnector.cur.db[ "settingsExt" ].update( ["ext":"themesExt"], settingsDoc ) > 0 ) defaultId = settingsDoc[ "default" ].toStr
      }
      if ( req.uri.query[ "delete" ] == "true" && db.delete( ["_id":reqTheme] ) > 0 ) reqTheme = ObjectId( defaultId )
    }
    json[ "myTheme" ] = defaultId
    json[ "list" ] = db.group( ["_id", "title"], [:], Code.makeCode( "function(){}" ) )
    json[ "layouts" ] = LayoutsExt.getLayouts
    if ( reqTheme != null && ( ([Str:Obj?][]) json[ "list" ] ).any |map| { map[ "_id" ] == reqTheme } ) {
      document := db.findOne( ["_id":reqTheme], false )
      if ( forcedLayout != null ) document[ "layout" ] = ObjectId( forcedLayout, false ) ?: document[ "layout" ]
      if ( document[ "layout" ] == null ) document[ "layout" ] = json[ "layouts" ]->get( 0 )->get( "_id" )
      document[ "layout" ] = LayoutsExt.getLayout( document[ "layout" ].toStr )
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
  
  static Str:Obj? getSettings() {
    settingsDoc := DBConnector.cur.db[ "settingsExt" ].findOne( ["ext":stype.pod.toStr], false )
    if ( settingsDoc == null ) settingsDoc = DBConnector.cur.db[ "settingsExt" ].findAndUpdate( ["ext":stype.pod.toStr], ["ext":stype.pod.toStr], true, ["upsert":true] )
    defaultId := settingsDoc[ "default" ] as ObjectId
    if ( defaultId == null || DBConnector.cur.db[ stype.pod.toStr ].findCount( ["_id":defaultId] ) == 0 ) {
      defaultId = DBConnector.cur.db[ stype.pod.toStr ].findOne( [:], false )?.get( "_id" ) as ObjectId
      if ( defaultId == null ) {
        sampleTheme := [
          "title":"Sample Theme",
          "layout":LayoutsExt.getSettings[ "default" ],
          "styles":["window":["bg":"gfx::Color(\"#FFFFFF\")"]],
        ]
        defaultId = DBConnector.cur.db[ stype.pod.toStr ].findAndUpdate( ["_false":true], sampleTheme, true, ["upsert":true] )[ "_id" ]
      }
      settingsDoc[ "default" ] = defaultId
      DBConnector.cur.db[ "settingsExt" ].findAndUpdate( ["ext":stype.pod.toStr], settingsDoc, true )
    }
    return settingsDoc
  }
  
  static Str:Str getTheme( Str id ) {
    [Str:Obj?]? document
    try document = DBConnector.cur.db[ stype.pod.toStr ].findOne( ["_id":ObjectId( id )], false )
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
