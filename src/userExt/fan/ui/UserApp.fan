using fui
using fwt
using gfx
using webfwt

@Js
class UserApp : App {
  
  new make() : super() {
    content = SashPane {
      it.weights = [25, 75]
      BorderPane {
        it.bg = Color.red
        EdgePane {
          top = GridPane {
            numCols = 1
            Label {
              text = "test"
            },
            Label {
              text = "test2"
            }
          }
        },
      },
      EdgePane {
        top = EdgePane {
          left = Label {
            text = "Header Name"
          }
          right = Label {
            text = "Search"
          }
        }
        center = BorderPane {
          it.bg = Color.blue
        }
      }
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
