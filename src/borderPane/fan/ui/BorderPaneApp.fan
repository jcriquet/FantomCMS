// Author:Joshua Leihe

using fui
using fwt
using gfx

@Js
class BorderPaneApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.black
      it.insets = Insets(30, 30)
      GridPane {
        numCols = 5
        
        BorderPane {
          it.bg = Color.blue
          it.insets = Insets( 15, 20 )
          Label { 
              text = "pane1" 
            },
        },
        BorderPane {
          it.bg = Color.yellow
          it.insets = Insets( 75, 90 )
          Label { 
              text = "pane2" 
            },
        },
        BorderPane {
          it.bg = Color.red
          it.insets = Insets( 150, 200 )
          Label { 
              text = "pane3" 
            },
        },
        Label { 
          text = "This is a BorderPane example!"
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
