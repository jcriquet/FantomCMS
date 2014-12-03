using fwt
using dom
using gfx
using webfwt
using util
using fui

@Js
class AddUserOverlayPane : OverlayPane {
  Text usernameBox := Text { }
  Text passwordBox := Text { it.password = true }
  TreeList groupList
  App app
  Bool isEdit := false
  Str? originalName

  new make(App app, Str[] toAdd, Str? name := null) : super(){
    this.app = app
    if(name != null) isEdit = true
    if(isEdit){
      this.originalName = name
      usernameBox.text = name
    }
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
  
  Void save() {
    toSend := [:]
    toSend["type"] = "user"
    toSend["name"] = this.usernameBox.text
    toSend["password"] = this.passwordBox.text
    toSend["group"] = (Str)this.groupList.items[this.groupList.selectedIndex]
    callType := `edit/new`
    if ( isEdit ) {
      callType = `edit`
      if ( this.usernameBox.text != this.originalName )
        app.apiCall( `delete/user` ).post(originalName) |res| { }
    }
    app.apiCall( callType ).postForm(toSend) |res| {
      switch(res.status){
        case 304:
          Win.cur.alert("Error: User already exists. Please delete first.")
        case 201:
          Win.cur.alert("Saved.")
        default:
          Win.cur.alert("Internal error saving.")
      }
      close
      app.reload
    }
  }
}
