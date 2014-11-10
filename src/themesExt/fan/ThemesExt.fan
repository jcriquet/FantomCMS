using afBson
using db
using proj
using util
using web

@ExtMeta {
  name = "themes"
  app = themesExt::ThemesApp#
}
const class ThemesExt : Ext, Weblet {
  override Void onGet() {
    res.done
  }
  
  static Str:Str getTheme( Str name ) {
    [Str:Obj?]? document := DBConnector.cur.db[ "themes" ].findOne( ["name":name], false )
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
