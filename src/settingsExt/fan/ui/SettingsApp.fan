using fui
using fwt
using gfx
using webfwt

@Js
class SettingsApp : App {
  private Widget makeButtons() {
    return GridPane {
      numCols = 2
      Button {
        text = "ass"
      },
      
      Button {
        text = "lol"
      },
      Button {
        text = "asd"
      },
    }
  }
  
  private Label label := Label {
    text = "hello"
  }
  
  Str:Widget listMap := ["lol" : makeButtons, "asdf" : label,]
  
  private BorderPane pageContent := BorderPane()
  
  private TreeList list := TreeList {
    it.items = listMap.keys
    it.onSelect.add |e| {
      pageContent.content = listMap[ e.data ]
      pageContent.relayout
    }
  }
  
  new make() : super() {
    content = BorderPane {
      it.bg = Gradient.fromStr("0% 50%, 100% 50%, #f00 0.1, #00f 0.9", true)
      EdgePane {
        top = BorderPane {
          it.bg = Color.gray
          Label {
            text = "hello"
          },
        }
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
    list.onSelect.fire( Event { it.data = listMap.keys[ list.selectedIndex = 0 ] } )
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
