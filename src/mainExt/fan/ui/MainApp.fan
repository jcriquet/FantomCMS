using fui
using dom
using fwt
using gfx
using util
using webfwt

@Js
class MainApp : App {
  
  EdgePane mainEdgePane

  new make() : super() {
    content = EdgePane{
      mainEdgePane = it

      top = ConstrainedBorderPane(Win.cur.viewport.w, (Win.cur.viewport.h * 0.2F).toInt){
        it.bg = Color.black
      }

      center = ContentPane{
        GridPane{
          it.numCols = 5
          Label{ text = "hi" },
          Label{ text = "hi" },
          Label{ text = "hi" },
          Label{ text = "hi" },
          Label{ text = "hi" },
        },
      }

      bottom = ContentPane{
        
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