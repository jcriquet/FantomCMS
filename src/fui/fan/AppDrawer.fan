using fwt
using webfwt
using gfx
using proj
using dom

@Js
@Serializable
class AppDrawerButton : Label {
  AppDrawer? appDrawer
  
  new make() {
    bg = FuiThemes.defColorNone
    image = Image( Fui.cur.baseUri + `pod/fui/res/img/list-50.png` )
    onMouseDown.add { 
      if ( appDrawer == null ) {
        appDrawer = AppDrawer()
        OverlayContainer( this, appDrawer )
                        { it.onClose.add { appDrawer = null } }
                        .display( this, Point( 0, this.size.h ) )
      }
    }
  }
}

@Js
class AppDrawer : OverlayPane {
  new make() {
    animate = true
    enabled = true
    content = BorderPane{
      it.insets = Insets(10,5)
      it.bg = Color.white
      it.content = EdgePane {
        it.top = EdgePane {
          it.right = Label { 
            it.text = "X"
            it.onMouseDown.add { close }
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
                close
              }
            })
          }
        }
      }
    }
  }
}
