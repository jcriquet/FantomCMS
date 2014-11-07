using fwt
using gfx
using proj
using dom

@Js
class HeaderPane : BorderPane
{
  new make() : super(){
    this.bg = Gradient("0% 50%, 100% 50%, #f00 0.1, #00f 0.9")
    this.content = GridPane {
      it.uniformCols = true
      it.halignCells = Halign.center
      it.halignPane = Halign.center
      appMap := Fui.cur.appMap
      it.numCols = appMap.size
      me := it
      Fui.cur.appMap.each |AppSpec appSpec, Str appName| {  
        appIcon := null
        me.add(AppIcon(appName, Fui.cur.baseUri + `pod/fui/res/img/home-50.png`){
          it.onMouseDown.add { Fui.cur.main.goto("fui://app/$appName".toUri) }
        })
      }
    }
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(0,75)
  }
}