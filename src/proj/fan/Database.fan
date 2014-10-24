using sql

class Database {
  static private Str url() { Database#.pod.config( "core.uri", "jdbc:mysql://128.114.9.179:3306/" ) }
  static private Str user() { Database#.pod.config( "core.username", "" ) }
  static private Str pass() { Database#.pod.config( "core.password", "" ) }
  
  static internal Obj execute( Str q, [Str:Str]? params := null ) {
    conn := SqlConn.open( url, user, pass )
    statement := conn.sql( q )
    result := statement.prepare.execute( params )
    statement.close
    conn.close
    return result
  }
  
  static Row[] query( Str q, [Str:Str]? params := null ) {
    conn := SqlConn.open( url, user, pass )
    statement := conn.sql( q )
    result := statement.prepare.query( params )
    statement.close
    conn.close
    return result
  }
  
  static internal Void queryEach( Str q, [Str:Str]? params, |Row| f ) {
    conn := SqlConn.open( url, user, pass )
    statement := conn.sql( q )
    statement.prepare.queryEach( params, f )
    statement.close
    conn.close
  }
}
