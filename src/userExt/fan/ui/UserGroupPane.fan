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
        Button{ it.text = "Add Group" ; it.onAction.add { addGroup() }},
        Button{ it.text = "Remove Group" ; it.onAction.add { removeGroup(itemList.items[itemList.selectedIndex]) }},
        Button{ it.text = "Edit Group" ; it.onAction.add { editGroup(itemList.items[itemList.selectedIndex]) }},
      }
    }
  }

  override Void onLoadState( State state ) {
    refreshList
  }
  
  Void refreshList(){
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
    AddGroupOverlayPane(app){
      it.onClose.add { refreshList }
    }.open(this, Point(this.pos.x+this.size.w/2-100, this.pos.y+this.size.h/2-100))
  }

  Void removeGroup(Str name){
    app.apiCall( `deletegroup`, app.name ).post(this.itemList.items[this.itemList.selectedIndex]) |res| {
      switch(res.status){
        case 200:
          Win.cur.alert("Deleted successfully.")
        default:
          Win.cur.alert("Failed to delete group.")
      }
    }
    refreshList
  }

  Void editGroup(Str name){
    app.apiCall(`getgroup/` + Uri.fromStr(name)).get |res| {
      map := JsonInStream(res.content.in).readJson as [Str:Obj?][]
      Str:Bool toPass := [:]
      map[0].each |v, k| {  
        if(k == "_id" || k == "name" || k == "type") return
        try{
          toPass[k] = Bool.fromStr(v)
        }catch{}
      }
      Win.cur.alert(toPass)
      AddGroupOverlayPane(app, name, toPass){
        it.onClose.add { refreshList }
      }.open(this, Point(this.pos.x+this.size.w/2-100, this.pos.y+this.size.h/2-100))
    }
  }
}
