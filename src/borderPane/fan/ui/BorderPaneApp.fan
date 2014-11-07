using fui
using fwt
using gfx

@Js
class BorderPaneApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.green
//      EdgePane {
//        center = Label {
//          text = "Hello"
//        }
//      },
    }
  }
}
