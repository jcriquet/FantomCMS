using fui
using fwt
using gfx

@Js
class PagesApp : App {
  
  new make() : super() {
    content = ScrollPane {
      GridPane {
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        Text {
          it.text = "Hello, I'm Pages!";
          it.font = Font.makeFields( "Ariel", 24 )
        },
      },
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
