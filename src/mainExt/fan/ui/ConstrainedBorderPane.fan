using gfx
using fwt
using dom

@Js
class ConstrainedBorderPane : BorderPane {
  BorderPane bp
  ConstraintPane cp
  Int h
  Int w
  Bool percents

  new make(Int w, Int h) : super(){
    this.w = w
    this.h = h
    this.bp = this
    this.content = ConstraintPane{
      this.cp = it
    }
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size( w, h )
  }
}