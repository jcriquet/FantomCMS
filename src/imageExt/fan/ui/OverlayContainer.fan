using gfx
using fwt
using webfwt
using dom

@Js
class OverlayContainer : OverlayPane
{
  OverlayPane? op
  Widget toOpenIn
  
  new make(Widget w, OverlayPane o) : super(){
    this.animate = true
    this.toOpenIn = w
    this.op = o
    op.onClose.add { this.close }
    this.content = OverlayContainerCP{
      it.onMouseDown.add { op.close }
    }
  }
  
  Void display(Widget w, Point p){
    super.open(toOpenIn, Point.defVal)
    op.open(w, p)
  }
}

@Js
class OverlayContainerCP : ContentPane{
  new make() : super(){}
  
  override Size prefSize(Hints h := Hints.defVal){
    return Win.cur.viewport
  }
}