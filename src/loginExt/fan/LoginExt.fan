using proj
using fui
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
    /*
    username := req.modRel
    //Session session := SessionStorage.cur[username.toStr]
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = session.toStr.size.toStr
    out := res.out
    res.cookies.add(Cookie("id", session.toStr.toBuf.toBase64){
      it.domain = Fui.cur.baseUri.toStr
      it.secure = false
    })
    out.writeChars( session.toStr )
    out.close
    res.done*/
  }
}
