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
        appMap := Fui.cur.appMap.dup
        appMap.remove( "login" )
        homeApp := appMap.remove( "home" )
        it.top = EdgePane {
          if ( homeApp != null ) it.left = GotoButton( `fui://app/home/` ) {
            bg = bgPressed = null
            border = null
            dropShadow = innerShadow = innerShadowPressed = null
            onAction.add { close }
            FlowPane {
              WebLabel {
                image = Image( Fui.cur.baseUri + `pod/fui/res/img/` + homeApp.icon.toUri )
                imageSize = Size( 30, 30 )
              },
              Label { text = "Home" },
            },
          }
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
          if ( appMap.size >= 4 ) it.numCols = 4
          else it.numCols = appMap.size
          gridPane := it
          appMap.vals.sort.each |app| {
            gridPane.add( AppIcon( app.label, Fui.cur.baseUri + `pod/fui/res/img/` + app.icon.toUri ) {
              it.onMouseDown.add { 
                Fui.cur.main.goto( "fui://app/$app.name".toUri )
                close
              }
            } )
          }
        }
      }
    }
  }
}
