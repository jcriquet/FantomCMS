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
          Fui.cur.appMap.each |v, k| { 
            if(v.name == "home" || v.name == "settings" || v.name == "login") return
            permPane.add(Label{ it.text = v.name })
            if(!this.isEdit){
              permPane.add(Button{ it.mode = ButtonMode.check ; this.permMap[v.name] = it })
            }else{
              if(!editMap.containsKey(v.name)){
                permPane.add(Button{ it.mode = ButtonMode.check ; this.permMap[v.name] = it })
                return
              }
              if(editMap[v.name] == true){
                permPane.add(Button{ it.mode = ButtonMode.check ; it.selected = true ; this.permMap[v.name] = it })
              }else{
                permPane.add(Button{ it.mode = ButtonMode.check ; this.permMap[v.name] = it })
                
              }
            }
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
    toSend := [:]
    toSend["type"] = "group"
    toSend["name"] = this.groupnameBox.text
    Fui.cur.appMap.each |v, k| { 
      if(v.name == "home" || v.name == "settings" || v.name == "login"){
        toSend[v.name] = true
        return
      }
      toSend[v.name] = this.permMap[v.name].selected
    }
    callType := `addgroup`
    if(this.isEdit){
      callType = `editgroup`
      if(this.groupnameBox.text != this.originalName){
        app.apiCall( `deletegroup`, app.name ).post(originalName) |res| { }
      }
    }
    this.app.apiCall(callType).postForm(toSend) |res| {
      switch(res.status){
      case 304:
        Win.cur.alert("Error: Group already exists. Please delete first.")
        this.close
      case 201:
        Win.cur.alert("Saved.")
        this.close
      default:
        Win.cur.alert("Internal error saving.")
        this.close
      }
    }
  }
}
