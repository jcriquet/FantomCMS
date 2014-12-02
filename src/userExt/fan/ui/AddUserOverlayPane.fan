using fwt
using dom
using gfx
using webfwt
using util
using fui

@Js
class AddUserOverlayPane : OverlayPane
{
  Text usernameBox := Text { }
  Text passwordBox := Text { it.password = true }
  TreeList groupList

  new make(Str[] toAdd) : super(){
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
              it.items = toAdd
              this.groupList = it
            }
          }
          it.bottom = GridPane{
            it.numCols = 2
            Button { it.text = "Close" ; it.onAction.add { this.close }},
            Button { it.text = "Save" ; it.onAction.add { this.save() }},
          }
        }
      }
    }
  }
  
  Void save(){
    this.close
  }
}
