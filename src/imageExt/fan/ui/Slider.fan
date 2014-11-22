using fwt
using dom
using gfx
using webfwt

@Js
class Slider : OverlayPane
{
  Widget toOpenIn
  Image[] imageList
  Size s
  ImageScrollPane isp

  new make(Widget toOpenIn, Image[] list, Size s := Size((toOpenIn.size.w * .5F).toInt, (toOpenIn.size.h * .5F).toInt)) : super(){
    this.s = s
    this.toOpenIn = toOpenIn
    this.imageList = list
    
    // Start UI
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
          // Content here
          isp = it.content = ImageScrollPane(s){ }
          this.imageList.each |img| {   
            isp.addImage(img)
          }
        }

        it.right = Label { it.text = "->" ; it.onMouseDown.add { doRight() }}
        it.left = Label { it.text = "<-" ; it.onMouseDown.add { doLeft() }}
      },
    }
    // End UI
    
    
  }

  Void display(){
    super.open(this.toOpenIn, getCoords)
  }
  
  Void doRight(){
    isp.scrollRight
    relayout
  }

  Void doLeft(){
    isp.scrollLeft
    relayout
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
  
  override Size prefSize(Hints h := Hints.defVal){
    return this.s
  }
  
}
  
@Js
class ImageScrollPane : ScrollPane{
  GridPane contentGrid
  Size s

  new make(Size s) : super(){
    this.s = Size(s.w, Size.defVal.h)
    this.vbar.visible = false
    this.vbar.enabled = false
    content = this.contentGrid = GridPane{
      it.halignCells = Halign.center
      it.valignCells = Valign.center
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      it.hgap = 25
      it.numCols = 0
    }
  }
  
  Void addImage(Image i){
    this.contentGrid.numCols++
    this.contentGrid.add(Label{it.image = i})
    this.relayout
  }
  
  Void scrollRight(){
    this.hbar.val += 25
  }
  
  Void scrollLeft(){
    this.hbar.val -= 25
  }
  
  override Size prefSize(Hints h := Hints.defVal){
    return this.s
  }
}
