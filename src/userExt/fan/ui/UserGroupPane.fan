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
        Button{ it.text = "Add Group" ; it.onAction.add { addGroup() } },
        Button{ it.text = "Remove Group" ; it.onAction.add { removeGroup( itemList.items[itemList.selectedIndex] ) } },
        Button{ it.text = "Edit Group" ; it.onAction.add { editGroup( itemList.items[itemList.selectedIndex] ) } },
      }
    }
  }

  override Void onLoadState( State state ) {
    app.apiCall( `list/group` ).get |res| {
      itemList.items = ( JsonInStream( res.content.in ).readJson as [Str:Obj?][] )?.map |item->Str| { item[ "name" ] ?: "" } ?: [,]
      itemList.relayout
    }
  }
  
  Void addGroup() { AddGroupOverlayPane( app ).open( this, Point( pos.x + size.w/2 - 100, pos.y + size.h/2 - 100 ) ) }

  Void editGroup( Str name ) {
    app.apiCall( `get/group/` + name.toUri ).get |res| {
      perms := ( ( JsonInStream( res.content.in ).readJson as Str:Obj? )?.get( "permissions" ) as Str:Obj? )?.map |str->Bool| { str == true } ?: Str:Bool[:]
      AddGroupOverlayPane( app, name, perms ).open( this, Point( pos.x + size.w/2 - 100, pos.y + size.h/2 - 100 ) )
    }
  }

  Void removeGroup(Str name){
    app.apiCall( `delete/group` ).post( itemList.items[itemList.selectedIndex] ) |res| {
      switch(res.status){
        case 200:
          Win.cur.alert("Deleted successfully.")
        default:
          Win.cur.alert("Failed to delete group.")
      }
      app.reload
    }
  }
}
