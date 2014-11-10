using fui
using dom
using proj
using fwt
using gfx
using util
using webfwt

@Js
class HomeApp : App {

  new make() : super() {
    content = BorderPane{
      it.bg = Color.white
      it.content = GridPane{
        it.numCols = 4
        it.halignCells = Halign.center
        it.valignCells = Valign.center
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        it.hgap = 10
        it.vgap = 10
        gridPane := it
        it.numCols = Fui.cur.appMap.size
        Fui.cur.appMap.each |AppSpec appSpec, Str appName| {  
          gridPane.add(HomeAppIcon(appSpec.label, Fui.cur.baseUri + `pod/fui/res/img/home-50.png`){
            it.onMouseDown.add { Fui.cur.main.goto("fui://app/$appName".toUri) }
          })
        }
      }
    }
  }
  
  // getOption checks the database for config options
  // TODO: interface with db
  Obj getOption(Str opt) {
    switch(opt) {
      case "home_cols":
      return 5
    }
    throw Err("Option not found")
  }
}
