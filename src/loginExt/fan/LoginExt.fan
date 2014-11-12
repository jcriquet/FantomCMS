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
  }
}
