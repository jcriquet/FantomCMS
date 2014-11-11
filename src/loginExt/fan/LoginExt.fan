using proj
using util
using web
using db
using afBson

@ExtMeta {
  name = "login"
  app = loginExt::LoginApp#
}
const class LoginExt : Ext, Weblet {
  
  override Void onGet() {
    Obj? json
    json = DBConnector.cur.db["user"].group(["_id", "name", "password"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]])
    text := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = text.size.toStr
    out := res.out
    out.writeChars( text )
    out.close
    res.done
  }
}
