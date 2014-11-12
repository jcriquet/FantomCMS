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
  override Void onGet() {
    Str:Obj? json := [:]
    json[ "list" ] = DBConnector.cur.db[ "themes" ].group( ["name", "title"], [:], Code.makeCode( "function(){}" ) )
    reqTheme := req.modRel.toStr
    if ( ( ([Str:Obj?][]) json[ "list" ] ).any |map| { map[ "name" ] == reqTheme } ) {
      document := DBConnector.cur.db[ "themes" ].findOne( ["name":reqTheme], false )
      document.remove( "_id" )
      json[ "selected" ] = document
    }
    content := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = content.size.toStr
    out := res.out
    out.writeChars( content )
    out.close
    res.done
  }
  
  static Str:Str getTheme( Str name ) {
    [Str:Obj?]? document
    try document = DBConnector.cur.db[ "themes" ].findOne( ["name":name], false )
    catch ( Err e ) {}
    map := [:]
    if ( document == null ) return map
    document.remove( "_id" )
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
