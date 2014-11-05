using proj
using util
using web

@ExtMeta {
  name = "settings"
  app = settingsExt::SettingsApp#
}
const class SettingsExt : Ext, Weblet {
  
  override Void onGet() {
    someFile := File()
    myText := someFile.readAllStr
    //Str:Str map := ["user":"jeremy"]
    myText := JsonOutStream.writeJsonToStr( map )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = myText.size.toStr
    out := res.out
    out.writeChars( myText )
    out.close
  }
  
  override Void onPost() {
    echo( req.form[ "user" ] )
  }
}
