using fwt
using webfwt
using gfx
using proj
using dom

@Js
class HeaderPane : StatePane{
  OverlayPane? appIconPane
  Bool paneOpen := false
  BorderPane themedMain := BorderPane{
    it.border = Border.fromStr( "0,0,3 outset #444444" )
    EdgePane{
      it.left = BorderPane{
        it.insets = Insets(10)
        Label { 
          label := it
          it.bg = FuiThemes.defColorNone
          it.image = Image(Fui.cur.baseUri + `pod/fui/res/img/list-50.png`)
          it.onMouseDown.add { 
            if(this.paneOpen == false) {
              getPane.open(this, Point(label.pos.x, this.size.h))
              this.paneOpen = true 
            }
          }
        },
      }
    },
  }

  new make() : super(){
    this.content = themedMain
  }
  

  OverlayPane getPane(){
    OverlayPane{
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
            if(appMap.size >= 4) it.numCols = 4
            else it.numCols = appMap.size
            gridPane := it
            Fui.cur.appMap.keys.sort.each |Str appName| {  
              appSpec := Fui.cur.appMap[ appName ]
              appIcon := null
              gridPane.add(AppIcon(appSpec.label, Fui.cur.baseUri + `pod/fui/res/img/` + Uri.fromStr(appSpec.icon)){
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
  
  override Void onLoadState(State state){
    themedMain.bg = FuiThemes.getBg( "header" )
    themedMain.repaint
  }
}