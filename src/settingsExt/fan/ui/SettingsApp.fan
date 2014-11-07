using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class SettingsApp : App {
  static const Int DEFAULTSERVPORT := 8080
  private Text dbHost:= Text()
  private Text dbPort := Text()
  private Text dbUsername := Text()
  private Text dbPassword := Text {
    password = true
    onModify.add { dbPasswordChanged = true }
    it.onFocus.add { if ( !dbPasswordChanged ) dbPassword.text = "" }
  }
  private Bool dbPasswordChanged
  private Text servPort := Text()
  private [Str:Str]? contentData
  
  private Widget dbWidget() {
    return GridPane {
      numCols = 2
      Label {
        text = "Host"
      },
      dbHost,
      Label {
        text = "Port Number"
      },
      dbPort,
      Label {
        text = "User Name"
      },
      dbUsername,
      Label {
        text = "Password"
      },
      dbPassword,
      Button {
        text = "Cancel"
      },
      Button {
        text = "Apply"
        onAction.add {
          contentData[ "host" ] = dbHost.text
          if ( dbPort.text.toInt( 10, false ) == null ) dbPort.text = contentData[ "port" ]
          contentData[ "port" ] = dbPort.text
          contentData[ "username" ] = dbUsername.text
          if ( dbPasswordChanged ) contentData[ "password" ] = dbPassword.text
          apiCall( `http://localhost:8080/api/settings` ).postForm( contentData.dup[ "option" ] = (Str) list.selected[0] ) {}
          modifyState
        }
      },
    }
  }
  
  private Widget servWidget() {
    return GridPane {
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
          apiCall( `http://localhost:8080/api/settings` ).postForm( contentData.dup[ "option" ] = (Str) list.selected[0] ) {}
          modifyState
        }
      },
    }
  }
  
  Str:Widget listMap := ["Database" : dbWidget, "Server" : servWidget,]
  
  private BorderPane pageContent := BorderPane()
  
  private TreeList list := TreeList {
    it.items = listMap.keys
    it.onSelect.add |e| {
      selected := list.selected[0]
      apiCall( "http://localhost:8080/api/settings?option=$selected".toUri ).get |res| {
        list.selected[0] = selected
        contentData = ( (Str:Obj?) JsonInStream( res.content.in ).readJson ).map |Obj? o->Str| { o?.toStr ?: "" }
        switch ( (Str) selected ) {
          case "Database":
            dbHost.text = contentData[ "host" ] ?: ""
            dbPort.text = contentData[ "port" ] ?: ""
            dbUsername.text = contentData[ "username" ] ?: ""
          case "Server":
            servPort.text = contentData[ "server.port" ]
        }
        modifyState
      }
    }
  }
  
  new make() : super() {
    content = BorderPane {
      it.bg = Gradient.fromStr("0% 50%, 100% 50%, #f00 0.1, #00f 0.9", true)
      EdgePane {
        center = SashPane {
          it.weights = [25, 75]
          EdgePane {
            center = list
          },
          pageContent,
        }
      },
    }
    relayout
  }
  
  override Void onSaveState( State state ) {
    state[ "listSelected" ] = list.selectedIndex
    state[ "contentData" ] = contentData
    switch ( (Str) list.selected[0] ) {
      case "Database":
        if ( dbHost.text != contentData[ "host" ] ) state[ "host" ] = dbHost.text
        if ( dbPort.text != contentData[ "port" ] ) state[ "port" ] = dbPort.text
        if ( dbUsername.text != contentData[ "username" ] ) state[ "username" ] = dbUsername.text
      case "Server":
        if ( servPort.text != contentData[ "server.port" ] ) state[ "server.port" ] = servPort.text
    }
  }
  
  override Void onLoadState( State state ) {
    list.selectedIndex = state[ "listSelected" ] ?: 0
    contentData = ( ([Str:Obj?]?) state[ "contentData" ] )?.map |Obj? o->Str| { o?.toStr ?: "" }
    if ( contentData != null ) {
      switch ( (Str) list.selected[0] ) {
        case "Database":
          dbHost.text = state[ "host" ] ?: contentData[ "host" ]
          dbPort.text = state[ "port" ] ?: contentData[ "port" ]
          dbUsername.text = state[ "username" ] ?: contentData[ "username" ]
          dbPassword.text = "asdfasdfasdf"
          dbPasswordChanged = false
        case "Server":
          servPort.text = state[ "server.port" ] ?: contentData[ "server.port" ]
      }
    }
    pageContent.content = listMap[ list.selected[0] ]
    pageContent.relayout
  }
}
