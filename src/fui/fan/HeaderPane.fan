using fwt
using webfwt
using gfx
using proj
using dom

@Js
class HeaderPane : BorderPane
{
  OverlayPane? appIconPane

  new make() : super(){
    this.bg = Color.white
    this.content = EdgePane{
      it.left = StyledButton { 
        it.bg = Color.white
        it.border = Border.fromStr("")
        button := it
        it.content = Label { 
          it.image = Image(Fui.cur.baseUri + `pod/fui/res/img/list-50.png`)
          button.onAction.add { getPane.open(this, button.posOnDisplay) }
        }
      }
    }
  }

  OverlayPane getPane(){
    return OverlayPane{
      appIconPane = it
      it.animate = true
      it.enabled = true
      it.content = BorderPane{
        it.border = Border.fromStr( "0,0,3 outset #444444" )
        it.bg = Color.white
        it.content = EdgePane {
          it.top = EdgePane {
            it.right = StyledButton { it.content = Label { text = "X" } ; onAction.add { appIconPane.close } }
          }
          it.center = GridPane {
            it.uniformCols = true
            it.halignCells = Halign.center
            it.halignPane = Halign.center
            it.hgap = 10
            appMap := Fui.cur.appMap
            it.numCols = appMap.size
            gridPane := it
            Fui.cur.appMap.each |AppSpec appSpec, Str appName| {  
              appIcon := null
              gridPane.add(AppIcon(appName, Fui.cur.baseUri + `pod/fui/res/img/home-50.png`){
                it.onMouseDown.add { 
                  Fui.cur.main.goto("fui://app/$appName".toUri) 
                  appIconPane.close
                }
              })
            }
          }
        }
      }
    }
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(0,75)
  }
}