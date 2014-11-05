using fui
using fwt
using gfx

class BorderPaneApp : App {
  new make() : super() {
    content = BorderPane {
      GridPane {
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        BorderPane {
          Label {
            text = "hello"
          },
        },
      },
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
