using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class SettingsApp : App {
  private Text userText := Text()
  private Text servPort := Text()
  
  private Widget dbWidget() {
    return GridPane {
      numCols = 2
      Label {
        text = "Server Address"
      },
      Text {
            
      },
      Label {
        text = "Port Number"
      },
      servPort,
      Label {
        text = "User Name"
      },
      userText,
      Label {
        text = "Password"
      },
      Text {
        password = true
      },
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
      Text {
        
      },
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
        userText.text = (Str) jsonMap[ "user" ]
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
    state[ "username" ] = userText.text
    state[ "port number"]
  }
  
  override Void onLoadState( State state ) {
    list.onSelect.fire( Event { it.data = listMap.keys[ list.selectedIndex ] } )
    userText.text = state[ "username" ] ?: ""
  }
}
