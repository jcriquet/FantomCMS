using fui
using dom
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
          it.text = "Manage Users"
        }
      }
      center = itemList
      bottom = GridPane{
        it.numCols = 3
        Button{ it.text = "Add User" ; it.onAction.add { addUser() }},
        Button{ it.text = "Remove User" ; it.onAction.add { removeUser(itemList.items[itemList.selectedIndex]) }},
        Button{ it.text = "Edit User" ; it.onAction.add { editUser(itemList.items[itemList.selectedIndex]) }},
      }
    }
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

  Void addUser(){
    AddOverlayPane.make.open(this, Point(this.pos.x+this.size.w/2-100, this.pos.y+this.size.h/2-100))
  }

  Void removeUser(Str name){
    return
  }

  Void editUser(Str name){
    return
  }
}
