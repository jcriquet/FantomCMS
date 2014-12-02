using fui
using dom
using fwt
using gfx
using util
using webfwt

@Js
class UserGroupPane : UserPane {
  TreeList itemList := TreeList(){
    it.items = [,]
  }
  
  new make( UserApp app ) : super( app ) {
    content = EdgePane {
      top = EdgePane {
        left = Label {
          it.text = "Manage User Groups"
        }
      }

      center = itemList
      bottom = GridPane{
        it.numCols = 3
        Button{ it.text = "Add User" ; it.onAction.add { addGroup() }},
        Button{ it.text = "Remove User" ; it.onAction.add { removeGroup(itemList.items[itemList.selectedIndex]) }},
        Button{ it.text = "Edit User" ; it.onAction.add { editGroup(itemList.items[itemList.selectedIndex]) }},
      }
    }
  }

  override Void onLoadState( State state ) {
    Str[] toAdd := [,]
    app.apiCall( `groups`, app.name ).get |res| {
      json := JsonInStream( res.content.in ).readJson as [Str:Obj?][]
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
  
  Void addGroup(){
    return
  }

  Void removeGroup(Str name){
    return
  }

  Void editGroup(Str name){
    return
  }
}
