using fui
using fwt
using gfx

@Js
class PagesApp : App {
  
  ScrollPane pageContent := ScrollPane()
  new make() : super() {
    content = pageContent
    /*
    
    */
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
    test := GridPane {
              it.halignPane = Halign.center
              it.valignPane = Valign.center
              Text {
                it.text = "Hello, I'm Pages!";
                it.font = Font.makeFields( "Ariel", 24 )
              },
            }
    buf := Buf()
    out := buf.out
    out.writeObj( test )
    out.close
    buf.flip
    str := buf.readAllStr
    echo( str )
    in := str.in
    contentRoot := in.readObj as Widget
    in.close
    pageContent.content = contentRoot
    pageContent.relayout
  }
}
