using db
using proj
using util
using web

@ExtMeta {
  name = "settings"
  app = settingsExt::SettingsApp#
  icon = "settings-50.png"
}
const class SettingsExt : Ext, Weblet {
  
  override Void onGet() {
    query := req.uri.query
    [Str:Str]? map
    switch ( query[ "option" ] ) {
      case "Database":
        map = Env.cur.props( Pod.find( "db" ), `config.props`, 0sec ).rw
        map.remove( "password" )
      case "Server":
        map = Env.cur.props( Pod.find( "proj" ), `config.props`, 0sec ).rw
    }
    
    myText := JsonOutStream.writeJsonToStr( map )
    //echo( myText )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = myText.size.toStr
    out := res.out
    out.writeChars( myText )
    out.close
    this.typeof.pod
  }
  
  override Void onPost() {
    form := req.form.rw
    //echo( form )
    switch ( form[ "option" ] ) {
      case "Database":
        file := Env.cur.homeDir + `etc/db/config.props`
        props := file.exists ? file.readProps : Str:Str[:]
        keys := ["host", "port", "username", "password", "database"]
        keys.each |key| { if ( form.containsKey( key ) ) props[ key ] = form[ key ] }
        file.create.writeProps( props )
      case "Server":
        file := Env.cur.homeDir + `etc/proj/config.props`
        props := file.readProps
        keys := ["server.port", "server.title"]
        keys.each |key| { if ( form.containsKey( key ) ) props[ key ] = form[ key ] }
        file.create.writeProps( props )
    }
  }
}
