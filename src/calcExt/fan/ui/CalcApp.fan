using fui
using fwt
using gfx
using util
using webfwt

@Js
class CalcApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.black
      BorderPane calc := BorderPane {
        bg = Color.gray
        WebBrowser {
          
        },
      }
      BorderPane clock := BorderPane {
        bg = Color.gray
      }
      BorderPane timer := BorderPane {
        bg = Color.gray
      }
      
      EdgePane {
        it.center = InsetPane.make(10) { 
          ConstraintPane {
            it.maxh = 200
            it.maxw = 200
            it.content = TabPane {
              Tab { text = "Calculator"; calc, },
              Tab { text = "Timer"; InsetPane { timer, }, },
              Tab { text = "Clock"; InsetPane { clock, }, },
            }
          },
        }
      },
     }
  }
  
  
  
  override Void onSaveState( State state ) {
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