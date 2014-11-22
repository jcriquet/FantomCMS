using fwt
using gfx
using webfwt

@Js
class Slider : OverlayPane
{
  Widget toOpenIn
  Image[] imageList

  new make(Widget toOpenIn, Image[] list, Size s := Size((toOpenIn.size.w * .5F).toInt, (toOpenIn.size.h * .5F).toInt)) : super(){
    this.toOpenIn = toOpenIn
    this.imageList = list
    this.size = s
    
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
          it.content = ImageScrollPane{
            

          }
        }
        it.right = Label { it.text = "->" ; it.onMouseDown.add { this.doRight() }}
        it.right = Label { it.text = "<-" ; it.onMouseDown.add { this.doLeft() }}
      },
    }
    // End UI
    
    
  }

  Void display(){
    super.open(this.toOpenIn, getCoords)
  }
  
  Void onRight(){
    
  }

  Void onLeft(){
    
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
  
@Js
class ImageScrollPane : ScrollPane{
  GridPane contentGrid

  new make() : super(){
    content = this.contentGrid = GridPane{
      
    }
  }
  
  Void addImage(Image i){
    this.contentGrid.numCols++
    this.contentGrid.add(Label{it.image = i})
    this.relayout
  }
}
