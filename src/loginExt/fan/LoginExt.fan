using proj
using userExt
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
  
  override Void onPost() {
    Obj? data
    if(!req.form.containsKey("username") && !req.form.containsKey("password")){
      // jacked up form
      res.sendErr(500)
      res.done
      return
    }
    if(UserExt.checkPass(req.form["username"], req.form["password"])){
      // login good
      session := SessionStorage.cur.get(req.form["username"])
      res.cookies.add(Cookie.make("username", req.form["username"]))
      res.cookies.add(Cookie.make("session", session.toStr))
      res.statusCode = 200
      data = "good"
    }else{
      // login bad
      res.sendErr(500)
      res.done
      return
    }
    out := JsonOutStream.writeJsonToStr(data)
    res.headers[ "Content-Type" ] = "application/json"
    res.headers[ "Content-Length" ] = out.size.toStr
    res.out.writeChars(out)
    res.out.close
    res.done
    }
}
