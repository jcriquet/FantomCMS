using proj
using util
using web

@ExtMeta {
  name = "login"
  app = loginExt::LoginApp#
}
const class LoginExt : Ext, Weblet {
  
  override Void onGet() {
    type := req.modRel.path.first
    Str? sql
    Str[]? colNames
    switch ( type ) {
      case "meters": sql = "utilities.meter"; colNames = [ "meter_id", "name", "utility", "unit", "is_virtual", "lat", "long", "caan_id", "vendor_id", "ratecode_id" ]
      case "installs": sql = "utilities.meter_install"; colNames = [ "meter_id", "install_date", "initial_read", "rollover", "multi", "physical_id", "register_id", "mxu_id" ]
      default: res.sendErr( 404 ); return
    }
    
    sql = " FROM " + sql
    where := req.uri.query
    if ( where.size > 0 ) {
      where = [:]
      req.uri.query.each |v, k| {
        if ( v != "false" && v != "true" ) v = "'" + v.replace( "\\'", "'" ).replace( "'", "\\'" ) + "'"
        if ( colNames.remove( k ) != null ) where.add( k, v )
      }
      if ( where.size > 0 ) {
        colNames = colNames.map |str| { "`$str`" }
        sql = "SELECT " + colNames.join( "," ) + sql + " WHERE " + where.join( " AND " ) |v, k| { "$k=$v"  }
      } else sql = "SELECT *" + sql
    } else sql = "SELECT *" + sql
    
    rows := Database.query( sql )
    if ( rows.size == 0 ) sql = "null"
    else {
      cols := rows[ 0 ].cols
      json := (Str:Obj) [ "headers" : cols.map |col| { col.name } ]
      data := Obj?[][,]
      rows.each |sqlRow| {
        row := Obj?[,]
        cols.each |col| { row.add( sqlRow[ col ] ) }
        data.add( row )
      }
      json[ "data" ] = data
      buf := StrBuf()
      JsonOutStream( buf.out ).writeJson( json ).close
      sql = buf.toStr
    }
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = sql.size.toStr
    out := res.out
    out.writeChars( sql )
    out.close
  }
}
