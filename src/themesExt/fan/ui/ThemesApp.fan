using fui
using fwt
using gfx

@Js
class ThemesApp : App {
  
  new make() : super() {
    content = SashPane {
      BorderPane {
        it.bg = gfx::Color.green
      },
      BorderPane {
        it.bg = gfx::Gradient("linear(0% 0%,100% 100%,#f1c6ff 0.14,#f97766 0.38,#8eb92a 0.49,#72aa00 0.51,#f5ff3a 0.76,#5b38f7 0.9)")
      },
      BorderPane {
        it.bg = gfx::Pattern( Image( `/pod/fui/res/img/home-50.png` ) )
      },
    }
    content.children.each |borderPane| {
      borderPane.add( Text {
        it.bg = Color( 0, true ); text = Buf().writeObj( ( borderPane as BorderPane ).bg ).flip.readAllStr
        it.editable = false
        it.multiLine = true
      } )
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
