using db
using proj
using util
using web

@ExtMeta {
  name = "settings"
  app = settingsExt::SettingsApp#
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
    echo( form )
    switch ( form[ "option" ] ) {
      case "Database":
        file := `etc/db/config.props`.toFile
        props := file.readProps
        keys := ["host", "port", "username", "password"]
        keys.each |key| { if ( form.containsKey( key ) ) props[ key ] = form[ key ] }
        file.create.writeProps( props )
      case "Server":
        file := `etc/proj/config.props`.toFile
        props := file.readProps
        if ( form.containsKey( "server.port" ) ) props[ "server.port" ] = form[ "server.port" ]
        file.create.writeProps( props )
    }
  }
}
