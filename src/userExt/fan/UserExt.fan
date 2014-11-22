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
    Obj? json
    switch ( req.modRel ) {
      case `list`:
        json = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name", "password"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]])
        if ( json == null ) json = [,]
      case `groups`:
        json = DBConnector.cur.db[typeof.pod.toStr].group(["name", "pages", "settings", "themes", "user"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"group"]])
        if ( json == null ) json = [,]
    }
    //json["users"] = DBConnector.cur.db["user"].findAll( ["type":"user"] )
    text := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = text.size.toStr
    out := res.out
    out.writeChars( text )
    out.close
    res.done
  }
}
