using fwt
using fui

@Js
class DatabasePane : SettingsPane {
  static const Str listName := "Database"
  Text dbHost:= Text()
  Text dbPort := Text()
  Text dbUsername := Text()
  Text dbPassword := Text {
    password = true
    onModify.add { dbPasswordChanged = true }
    it.onFocus.add { if ( !dbPasswordChanged ) dbPassword.text = "" }
  }
  private Bool dbPasswordChanged
  Text dbDatabase := Text()
  
  new make( SettingsApp app ) : super( app ) {
    content = GridPane {
      numCols = 2
      Label { text = "Host" },
      dbHost,
      Label { text = "Port Number" },
      dbPort,
      Label { text = "User Name" },
      dbUsername,
      Label { text = "Password" },
      dbPassword,
      Label { text = "Database" },
      dbDatabase,
      Button { text = "Cancel" },
      Button {
        text = "Apply"
        onAction.add {
          echo( contentData )
          contentData[ "host" ] = dbHost.text
          if ( dbPort.text.toInt( 10, false ) == null ) dbPort.text = contentData[ "port" ] ?: "0"
          contentData[ "port" ] = dbPort.text
          contentData[ "username" ] = dbUsername.text
          if ( dbPasswordChanged ) contentData[ "password" ] = dbPassword.text
          contentData[ "database" ] = dbDatabase.text
          app.apiCall( `http://localhost:8080/api/settings` ).postForm( contentData.dup[ "option" ] = listName ) {}
          app.modifyState
        }
      }, 
    }
  }
  
  override Void getData() {
    dbHost.text = contentData[ "host" ] ?: ""
    dbPort.text = contentData[ "port" ] ?: ""
    dbUsername.text = contentData[ "username" ] ?: ""
    dbDatabase.text = contentData[ "database" ] ?: ""
  }
  
  override Void onSaveState( State state ) {
    if ( dbHost.text != contentData[ "host" ] ) state[ "host" ] = dbHost.text
    if ( dbPort.text != contentData[ "port" ] ) state[ "port" ] = dbPort.text
    if ( dbUsername.text != contentData[ "username" ] ) state[ "username" ] = dbUsername.text
    if ( dbDatabase.text != contentData[ "database" ] ) state[ "database" ] = dbDatabase.text
  }
  
  override Void onLoadState( State state ) {
    dbHost.text = state[ "host" ] ?: contentData[ "host" ]
    dbPort.text = state[ "port" ] ?: contentData[ "port" ]
    dbUsername.text = state[ "username" ] ?: contentData[ "username" ]
    dbPassword.text = "asdfasdfasdf"
    dbPasswordChanged = false
    dbDatabase.text = state[ "database" ] ?: contentData[ "database" ]
  }
}
