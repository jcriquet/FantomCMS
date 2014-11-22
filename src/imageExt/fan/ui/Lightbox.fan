using fwt
using fui
using gfx
using webfwt

@Js
class Lightbox : OverlayPane
{
  Widget toOpenIn
  Image image
  OverlayContainer oc

  new make(Widget toOpenIn, Image image) : super(){
    this.toOpenIn = toOpenIn
    this.image = image
    this.oc = OverlayContainer(toOpenIn, this)
    this.size = Size(this.image.size.w+30, this.image.size.h+50)
    this.content = BorderPane{
      it.insets = Insets(5)
      it.bg = Color.white
      it.border = Border.fromStr("1")
      EdgePane{
        it.top = GridPane{
          it.halignCells = Halign.right
          it.halignPane = Halign.right
          BorderPane{
            it.bg = Color.white
            it.content = Label { it.text = "X" ; it.onMouseUp.add { this.close }}
          },
        }
        it.center = BorderPane{
          it.insets = Insets(10)
          it.bg = Color.white
          it.content = Label{it.image = this.image}
        }
      },
    }
  }

  new makeFromUri(Widget toOpenIn, Uri uri) : super.make(){
    this.toOpenIn = toOpenIn
    this.oc = OverlayContainer(toOpenIn, this)
    this.image = Image.make(uri)
    this.size = Size(this.image.size.w+30, this.image.size.h+75)
  }

  Void display(){
    oc.display(this.toOpenIn, getCoords)
  }
  
  // get coords that will display the lightbox in the center of the widget
  Point getCoords(){
    x := toOpenIn.size.w
    y := toOpenIn.size.h
    w := this.size.w
    h := this.size.h
    
    x1 := ((x/2).toInt)-((w/2).toInt)
    y1 := ((y/2).toInt)-((h/2).toInt)
    return Point(x1, y1)
  }
  
}
