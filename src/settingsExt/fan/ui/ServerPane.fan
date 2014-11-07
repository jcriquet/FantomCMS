using fwt
using fui

@Js
class ServerPane : SettingsPane {
  static const Str listName := "Server"
  private Text servPort := Text()
  
  new make( SettingsApp app ) : super( app ) {
    content = GridPane {
      numCols = 2
      Label {
        text = "Port Number"
      },
      servPort,
      Button {
        text = "Cancel"
      },
      Button {
        text = "Apply"
        onAction.add {
          if ( servPort.text.toInt( 10, false ) == null ) servPort.text = contentData[ "server.port" ]
          contentData[ "server.port" ] = servPort.text
          app.apiCall( `http://localhost:8080/api/settings` ).postForm( contentData.dup[ "option" ] = listName ) {}
          app.modifyState
        }
      },
    }
  }
  
  override Void getData() {
    servPort.text = contentData[ "server.port" ]
  }
  
  override Void onSaveState( State state ) {
    if ( servPort.text != contentData[ "server.port" ] ) state[ "server.port" ] = servPort.text
  }
  
  override Void onLoadState( State state ) {
    servPort.text = state[ "server.port" ] ?: contentData[ "server.port" ]
  }
}
