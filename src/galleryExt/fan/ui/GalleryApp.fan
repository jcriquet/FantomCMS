using audioExt
using imageExt
using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class GalleryApp : App {
  Int maxCols := 7
  
  GridPane gridView := GridPane {
    numCols = 0
    halignCells = halignPane = Halign.center
    valignCells = valignPane = Valign.center
    apiCallApp(`getAll`, "image").get |res| {
      Buf b := res.content.toBuf
      map := b.readObj as Str:Uri

      map.each |uri, filename| {
        if(this.gridView.numCols < maxCols) this.gridView.numCols++
        this.gridView.add( Label{ it.image = Image(Fui.cur.baseUri + uri + "?tb".toUri) ; it.onMouseDown.add { makeLB(Image( Fui.cur.baseUri + uri)) }} )
      }

      this.gridView.relayout
    }
  }

//  EdgePane fullView := EdgePane {
//    center = 
//    bottom = GridPane {
//      apiCallApp(`getAll`, "image").get |res| {
//        Buf b := res.content.toBuf
//        map := b.readObj as Str:Uri
//  
//        map.each |uri, filename| {
//          this.gridView.numCols++
//          this.gridView.add( Label{ it.image = Image(Fui.cur.baseUri + uri + "?tb".toUri) ; it.onMouseDown.add { makeLB(Image( Fui.cur.baseUri + uri)) }} )
//        }
//  
//        this.gridView.relayout
//      }
//    }
//  }

  new make() : super() {
    content = GridPane {
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      BorderPane {
        it.border = Border.fromStr( "3 solid #000000 15" )
        it.insets = Insets( 10, 16 )
        it.bg = Color.makeArgb(100, 100, 100, 100)
        ScrollPane {
          gridView,
        },
      },      
    }
  } 
  
  Void makeLB(Image img){
    Slider(this, [img]).display
  }
  
  override Void onSaveState( State state ) {

  }
  
  override Void onLoadState( State state ) {

  }
}
