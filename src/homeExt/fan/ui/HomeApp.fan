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
      it.content = HomeAppPane(Fui.cur.appMap.size){
        it.halignCells = Halign.center
        it.valignCells = Valign.center
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        it.hgap = 10
        it.vgap = 10
        gridPane := it
        Fui.cur.appMap.each |AppSpec appSpec, Str appName| {  
          gridPane.add(HomeAppIcon(appSpec.label, Fui.cur.baseUri + `pod/fui/res/img/` + Uri.fromStr(appSpec.icon)){
            it.onMouseDown.add { Fui.cur.main.goto("fui://app/$appName".toUri) }
          })
        }
      }
    }
  }
}

@Js
class HomeAppPane : GridPane{
  Int numberOfApps
  new make(Int numberOfApps) : super(){
    this.numberOfApps = numberOfApps
  }
    
  override Void onLayout(){
    super.onLayout
    if(this.size.w < 800){
      this.numCols = 4
    }
    else{
      this.numCols = this.numberOfApps
    }
  }
}