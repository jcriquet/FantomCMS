using fwt
using dom
using gfx
using webfwt
using util
using fui

@Js
class AddGroupOverlayPane : OverlayPane
{
  Text groupnameBox := Text { }
  App app
  Bool isEdit := false
  Str? originalName
  Str:Button permMap := [:]

  new make(App app, Str? name := null, [Str:Bool]? editMap := null) : super(){
    this.app = app
    if(name != null && editMap != null) isEdit = true
    if(isEdit){
      this.originalName = name
      groupnameBox.text = name
    }
    this.content = BorderPane{
      it.insets = Insets(5)
      it.border = Border.fromStr("1")
      it.bg = Color.white
      it.content = EdgePane{
        it.top = GridPane{
          permPane := it
          it.numCols = 2
          it.uniformCols = true
          it.halignCells = Halign.left
          it.halignPane = Halign.left
          it.valignCells = Valign.center
          it.valignPane = Valign.center
          it.add(Label { it.text = "Group Name:" })
          it.add(this.groupnameBox)
          Fui.cur.exts.union( Fui.cur.appMap.keys ).each |ext| { 
            if ( ext == "home" || ext == "settings" || ext == "login") return
            permPane.add( Label { it.text = ext } )
            permPane.add( Button{
              it.mode = ButtonMode.check;
              it.selected = isEdit && ( editMap[ext] ?: false )
              this.permMap[ext] = it
            } )
          }
        }
        it.bottom = GridPane{
          it.numCols = 2
          it.halignCells = Halign.center
          it.halignPane = Halign.center
          it.valignCells = Valign.center
          it.valignPane = Valign.center
          Button { it.text = "Close" ; it.onAction.add { this.close }},
          Button { it.text = "Save" ; it.onAction.add { this.save }},
        }
      }
    }
  }
  
  Void save(){
    toSend := Str:Str[:]
    toSend["type"] = "group"
    toSend["name"] = this.groupnameBox.text
    toSend["permissions"] = State.valueToStr( permMap.map |button->Bool| { button.selected }.add( "home", true ).add( "login", true ).add( "settings", true ) )
    callType := `edit/new`
    if ( isEdit ) {
      callType = `edit`
      if ( this.groupnameBox.text != this.originalName )
        app.apiCall( `delete/group` ).post(originalName) |res| { }
    }
    app.apiCall( callType ).postForm(toSend) |res| {
      switch(res.status){
        case 304:
          Win.cur.alert("Error: Group already exists. Please delete first.")
        case 200:
          Win.cur.alert("Saved.")
        default:
          Win.cur.alert("Internal error saving.")
      }
      close
      app.reload
    }
  }
}
