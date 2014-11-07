using fui
using dom
using proj
using fwt
using gfx
using util
using webfwt

@Js
class HomescreenApp : App {

  new make() : super() {
    content = BorderPane{
      it.bg = Gradient("0% 50%, 100% 50%, #f00 0.1, #00f 0.9")
      it.content = GridPane{
        it.numCols = Fui.cur.appMap.size
        Fui.cur.appMap.each |AppSpec appSpec, Str appName | {   
          add(HomescreenAppIcon(appName))
        }
      }
    }
  }
  
  // getOption checks the database for config options
  // TODO: interface with db
  Obj getOption(Str opt) {
    switch(opt) {
      case "homescreen_cols":
      return 5
    }
    throw Err("Option not found")
  }
}
