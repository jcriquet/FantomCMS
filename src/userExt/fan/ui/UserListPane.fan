using fui
using webfwt
using fwt
using gfx
using util

@Js
class UserListPane : UserPane {
  TreeList itemList := TreeList{
    it.items = [,]
  }
  
  new make( UserApp app ) : super( app ) {
    content = EdgePane {
      top = EdgePane {
        left = Label {
          text = "Manage Users"
        }
      }
      center = itemList
      bottom = GridPane{
        it.numCols = 3
        Button{ it.text = "Add User" ; it.onAction.add { doAdd() } },
        Button{ it.text = "Remove User" ; it.onAction.add { doRemove() } },
        Button{ it.text = "Edit User" ; it.onAction.add { doEdit() } },
      }
    }
  }
  
  Void doAdd(){
    
  }

  Void doRemove(){
    
  }

  Void doEdit(){
    
  }
  
  override Void onLoadState( State state ) {
    Str[] toAdd := [,]
    app.apiCall( `list`, app.name ).get |res| {
      json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
      json.each |item| {
        item.each |v, k| {
          if(k == "name"){
            toAdd.add((Str)v)
          }
        }
      }
      itemList.items = toAdd
      itemList.relayout
    }
  }
}
