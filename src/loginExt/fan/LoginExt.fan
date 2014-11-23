using proj
using util
using web
using db
using afBson

@ExtMeta {
  name = "login"
  app = loginExt::LoginApp#
  icon = "login-50.png"
}
const class LoginExt : Ext, Weblet {
  
  override Void onGet() {
    /*Obj? json
    switch ( req.modRel ) {
      case `ss`:
        json = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name", "password"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]])
        if ( json == null ) json = [,]
    }
    //json["users"] = DBConnector.cur.db["user"].findAll( ["type":"user"] )
    text := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = text.size.toStr
    out := res.out
    out.writeChars( text )
    out.close
    res.done*/
  }
}
