using gfx
using fwt
using dom

@Js
class ConstrainedBorderPane : BorderPane {
  BorderPane bp
  ConstraintPane cp

  new make(Int w, Int h, Bool percents := false) : super(){
    this.bp = this
    this.content = ConstraintPane{
      this.cp = it
      if(!percents){
        it.minh = h
        it.maxh = h
        it.minw = w
        it.maxw = w
      }else{
        it.minh = (Win.cur.viewport.h * (h/100)).toInt
        it.maxh = (Win.cur.viewport.h * (h/100)).toInt
        it.minw = (Win.cur.viewport.w * (w/100)).toInt
        it.maxw = (Win.cur.viewport.w * (w/100)).toInt
      }
    }
  }
}