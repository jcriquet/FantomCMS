using gfx
using fwt
using dom

@Js
class ConstrainedBorderPane : BorderPane {
  BorderPane bp
  Int h
  Int w

  new make(Int w, Int h) : super(){
    this.w = w
    this.h = h
    this.bp = this
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size( w, h )
  }
}