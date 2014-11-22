using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class GalleryApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Gradient.fromStr("0% 50%, 100% 50%, #f00 0.1, #00f 0.9", true)
      EdgePane {
        left = ConstraintPane {
          it.minw = it.maxw = 100
          GridPane {
            it.halignPane = Halign.center
            it.valignPane = Valign.center
            Button { text = "prev" },           
          },
        }
        center = BorderPane {
          it.border = Border.fromStr( "3 solid #000000 30" )
          it.insets = Insets( 10, 16 )
          it.bg = Color.purple
          //numCols = 50
          Image a := Image("https://i.imgur.com/bkqu6Ss.jpg")
          //me := it
          //50.times { me.add( Label { it.image = a } ) }
          GridPane {
            it.halignPane = Halign.center
            it.valignPane = Valign.center
            
            Label { it.image = a },            
          },
        }
        right = ConstraintPane {
          it.minw = it.maxw = 100
          GridPane {
            it.halignPane = Halign.center
            it.valignPane = Valign.center
            Button { text = "next" },                  
          },
        }
      },
    }
    relayout
  }
  
  override Void onSaveState( State state ) {

  }
  
  override Void onLoadState( State state ) {

  }
}
