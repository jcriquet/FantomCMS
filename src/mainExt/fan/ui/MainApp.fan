using fui
using dom
using fwt
using gfx
using util
using webfwt

@Js
class MainApp : App {
  
  ConstrainedBorderPane topPane
  ConstrainedBorderPane centerPane
  ConstrainedBorderPane bottomPane

  EdgePane mainEdgePane

  new make() : super() {
    content = EdgePane{
      mainEdgePane = it
      it.top = ConstrainedBorderPane(100,10,true){
        topPane = it
        it.bg = Color.black
      }

      it.center = ConstrainedBorderPane(100,90,true){
        centerPane = it
        it.bg = Color.gray
      }

      it.bottom = ConstrainedBorderPane(100,10,true){
        bottomPane = it
        it.bg = Color.black
      }
    }
  }
  
  
  // getOption checks the database for config options
  // TODO: interface with db
  Obj getOption(Str obj, Str opt) {
    switch(opt) {
      case "bgcolor":
      // sweet gradient
      return Gradient("0% 50%, 100% 50%, #f00 0.1, #00f 0.9")
    }
    throw Err("Option not found")
  }
}
