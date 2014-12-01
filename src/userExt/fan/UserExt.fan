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
    switch ( req.modRel ) {
      case `list`:
        data = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]]) as [Str:Obj?][]
        if ( data == null ) data = [,]
      case `groups`:
        data = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"group"]]) as [Str:Obj?][]
        if ( data == null ) data = [,]
    }
    echo(data.toStr)
    echo("hi")
    out := JsonOutStream.writeJsonToStr(data)
    res.headers[ "Content-Type" ] = "application/json"
    res.headers[ "Content-Length" ] = out.size.toStr
    res.out.writeChars( out ).close
    res.done
  }
}
