using fwt
using fui

@Js
class ServerPane : SettingsPane {
  static const Str listName := "Server"
  private Text servPort := Text()
  private Text servTitle := Text()
  
  new make( SettingsApp app ) : super( app ) {
    content = GridPane {
      numCols = 2
      Label { text = "Port Number" },
      servPort,
      Label { text = "Web Server Title" },
      servTitle,
      Button { text = "Cancel" },
      Button {
        text = "Apply"
        onAction.add {
          if ( servPort.text.toInt( 10, false ) == null ) servPort.text = contentData[ "server.port" ]
          contentData[ "server.port" ] = servPort.text
          contentData[ "server.title" ] = servTitle.text
          app.apiCall( Fui.cur.baseUri + `api/settings` ).postForm( contentData.dup[ "option" ] = listName ) {}
          app.modifyState
        }
      },
    }
  }
  
  override Void getData() {
    servPort.text = contentData[ "server.port" ]
    servTitle.text = contentData[ "server.title" ]
  }
  
  override Void onSaveState( State state ) {
    if ( servPort.text != contentData[ "server.port" ] ) state[ "server.port" ] = servPort.text
    if ( servTitle.text != contentData[ "server.title" ] ) state[ "server.title" ] = servTitle.text
  }
  
  override Void onLoadState( State state ) {
    servPort.text = state[ "server.port" ] ?: contentData[ "server.port" ]
    servTitle.text = state[ "server.title" ] ?: contentData[ "server.title" ]
  }
}
