using fwt
using gfx
using webfwt
using util
using fui

@Js
class AddOverlayPane : OverlayPane
{
  Text usernameBox := Text { }
  Text passwordBox := Text { it.password = true }

  new make() : super(){
    this.content = BorderPane{
      it.border = Border.fromStr("1")
      it.bg = Color.white
      it.content = EdgePane{
        top = GridPane{
          it.numCols = 1
          it.halignCells = Halign.left
          it.halignPane = Halign.left
          it.valignCells = Valign.center
          it.valignPane = Valign.center
          Label{ it.text = "Add User" },
        }
        center = GridPane{
          it.numCols = 1
          GridPane{
            it.numCols = 2
            Label { it.text = "Username" },
            usernameBox,
          },
          GridPane{
            it.numCols = 2
            Label { it.text = "Password" },
            passwordBox,
          },
        }
        bottom = EdgePane{
          it.center = ScrollPane{
            it.content = TreeList{
              Str[] apps := [,]
              Fui.cur.appMap.each |v, k| { 
                if(k == "loginExt") return
                apps.add(k)
              }
              it.items = apps
            }
          }
          it.bottom = GridPane{
            it.numCols = 2
            Button { it.text = "Close" },
            Button { it.text = "Save" },
          }
        }
      }
    }
  }
}
