using fui
using dom
using proj
using fwt
using gfx
using util
using webfwt

@Js
class HomescreenApp : App {
  GridPane mainGrid

  new make() : super() {
    content = GridPane{
      mainGrid = it

      it.numCols = getOption("homescreen_cols")
      Fui.cur.appMap.each |AppSpec appSpec, Str appName | {   
        mainGrid.add(AppIcon(appName, HomescreenApp#.method("launchApp").func))
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
  
  Void launchApp(){
    Win.cur.alert("hi")
  }
}