using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class SettingsApp : App {
  private Text dbAddress:= Text()
  private Text dbPort := Text()
  private Text dbUsername := Text()
  private Text dbPassword := Text {
    password = true
  }
  private Text servPort := Text()
  
  private Widget dbWidget() {
    return GridPane {
      numCols = 2
      Label {
        text = "Server Address"
      },
      dbAddress,
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
        onAction.add { modifyState }
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
      },
    }
  }
  
  Str:Widget listMap := ["Database" : dbWidget, "Server" : servWidget,]
  
  private BorderPane pageContent := BorderPane()
  
  private TreeList list := TreeList {
    it.items = listMap.keys
    it.onSelect.add |e| {
      apiCall( `http://localhost:8080/api/settings` ).get |res| {
        jsonMap := (Str:Obj?) JsonInStream( res.content.in ).readJson
        dbUsername.text = (Str) jsonMap[ "user" ]
      }
      apiCall( `http://localhost:8080/api/settings` ).postForm( ["user":"jono"] ) {}
      //ajaxcall( `some/uri/here.place` ) |Str receivedData| {
      //  
      //}
      pageContent.content = listMap[ e.data ]
      pageContent.relayout
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
    list.selectedIndex = 0
  }
  
  override Void onSaveState( State state ) {
    state[ "username" ] = dbUsername.text
  }
  
  override Void onLoadState( State state ) {
    list.onSelect.fire( Event { it.data = listMap.keys[ list.selectedIndex ] } )
    dbUsername.text = state[ "dbUsername" ] ?: ""
  }
}
