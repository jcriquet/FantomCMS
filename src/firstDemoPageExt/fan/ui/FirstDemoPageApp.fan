// Author:Joshua Leihe

using fui
using fwt
using gfx

@Js
class FirstDemoPageApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.black
      it.insets = Insets(30, 30)
      GridPane {
        numCols = 4
        
        BorderPane {
          it.bg = Color.black
          it.insets = Insets( 15, 20 )
        Label {
          text = "Under construction!"
          fg = Color.red
        },
        },
        Label { 
          text = "This is the first demo page!"
          fg = Color.white
        },
        GotoButton(`fui://app/pages/`) {
          it.text = "Back"
        },
      },
    }
  }
  
  override Void onSaveState( State state ) {
    buf := Buf()
    out := buf.out
    out.writeObj(this.content)
    out.close
    buf.flip
    echo( buf.readAllStr.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n"))
  }
  
  Void main() {
    buf := Buf()
    out := buf.out
    out.writeObj(this.content)
    out.close
    buf.flip
    echo( buf.readAllStr.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n"))
  }
  
  override Void onLoadState( State state ) {
  }
}
