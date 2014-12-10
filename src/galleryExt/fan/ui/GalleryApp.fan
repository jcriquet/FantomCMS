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
  private BorderPane pageContent := BorderPane()
  Label img := Label()
  
  Void makeLB(Image img){
    Slider(this, [img]).display
  }
  
  GridPane gridViewContent := GridPane {
    numCols = 0
    halignCells = halignPane = Halign.center
    valignCells = valignPane = Valign.center
    apiCallApp(`getAll`, "image").get |res| {
      Buf b := res.content.toBuf
      map := b.readObj as Str:Uri

      map.each |uri, filename| {
        if(this.gridViewContent.numCols < maxCols) this.gridViewContent.numCols++
        this.gridViewContent.add( Label{ it.image = Image(Fui.cur.baseUri + uri + "?tb".toUri) ; it.onMouseDown.add { makeLB(Image( Fui.cur.baseUri + uri)) }} )
      }

      this.gridViewContent.relayout
    }
  }
  
  GridPane gridView := GridPane {
    it.halignPane = Halign.center
    it.valignPane = Valign.center
    BorderPane {
      it.border = Border.fromStr( "3 solid #000000 15" )
      it.insets = Insets( 10, 16 )
      it.bg = Color.makeArgb(100, 100, 100, 100)
      ScrollPane {
        gridViewContent,
      },
    },      
  }
  
  GridPane filmStrip := GridPane {
    numCols = 0
    apiCallApp(`getAll`, "image").get |res| {
      Buf b := res.content.toBuf
      map := b.readObj as Str:Uri
      map.each |uri, filename| {
        this.filmStrip.numCols++
        this.filmStrip.add( Label{ it.image = Image(Fui.cur.baseUri + uri + "?tb".toUri) ; it.onMouseDown.add { img.image = Image( Fui.cur.baseUri + uri) }} )
      }
      this.filmStrip.relayout
    }
  }
  
  EdgePane fullView := EdgePane {
    center = GridPane {
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      BorderPane {
        it.border = Border.fromStr( "3 solid #000000 15" )
        it.insets = Insets( 10, 16 )
        it.bg = Color.makeArgb(100, 100, 100, 100)
        img,
      },
    }
    bottom = BorderPane {
      it.border = Border.fromStr( "3 solid #000000 15" )
      it.insets = Insets( 10, 16 )
      it.bg = Color.makeArgb(100, 100, 100, 100)
      ScrollPane { filmStrip, },
    }
  }
  
  new make() : super() {
    content = EdgePane {
      top = GridPane {
        numCols = 2
        Button { 
          text = "Grid View" 
          onAction.add { pageContent.content = gridView } 
        },
        Button {
          text = "Full View" 
          onAction.add { pageContent.content = fullView } 
        },
      }
      center = pageContent
    }
  } 
  
  override Void onSaveState( State state ) {

  }
  
  override Void onLoadState( State state ) {
    pageContent.content = gridView
  }
}
