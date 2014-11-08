using fwt
using webfwt
using gfx
using proj
using dom

@Js
class HeaderPane : BorderPane
{
  OverlayPane? appIconPane
  Bool paneOpen := false

  new make() : super(){
    this.onFocus.add { appIconPane.close }
    this.border = Border.fromStr( "0,0,3 outset #444444" )
    this.bg = Color.white
    this.content = EdgePane{
      it.left = BorderPane{
        it.insets = Insets(10)
        Label { 
          label := it
          it.bg = Color.white
          it.image = Image(Fui.cur.baseUri + `pod/fui/res/img/list-50.png`)
          it.onMouseDown.add { 
            if(this.paneOpen == false) {
              getPane.open(this, Point(label.pos.x, this.size.h))
              this.paneOpen = true 
            }
          }
        },
      }
    }
  }
  

  OverlayPane getPane(){
    return OverlayPane{
      appIconPane = it
      it.animate = true
      it.enabled = true
      it.content = BorderPane{
        it.insets = Insets(10,5)
        it.bg = Color.white
        it.content = EdgePane {
          it.top = EdgePane {
            it.right = BorderPane{
              Label { 
                it.text = "X"
                it.onMouseDown.add { 
                  appIconPane.close 
                  this.paneOpen = false
                } 
              },
            }
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
                  this.paneOpen = false
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