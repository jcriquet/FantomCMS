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
        Button{ it.text = "Add User" ; it.onAction.add { addUser } },
        Button{ it.text = "Remove User" ; it.onAction.add { removeUser( itemList.items[itemList.selectedIndex] ) } },
        Button{ it.text = "Edit User" ; it.onAction.add { editUser( itemList.items[itemList.selectedIndex] ) } },
      }
    }
  }
  
  override Void onLoadState( State state ) {
    app.apiCall( `list/user` ).get |res| {
      itemList.items = ( JsonInStream( res.content.in ).readJson as [Str:Obj?][] )?.map |item->Str| { item[ "name" ] ?: "" } ?: [,]
      itemList.relayout
    }
  }
  
  Void addUser() { editUser( null ) }

  Void editUser( Str? name ) {
    app.apiCall( `list/group` ).get |res| {
      groups := ( JsonInStream( res.content.in ).readJson as [Str:Obj?][] )?.map |item->Str| { item[ "name" ] ?: "" } ?: [,]
      AddUserOverlayPane( app, groups, name ).open( this, Point( pos.x + size.w/2 - 100, pos.y + size.h/2 - 100 ) )
    }
  }

  Void removeUser( Str name ) {
    app.apiCall( `delete/user` ).post( itemList.items[ itemList.selectedIndex ] ) |res| {
      switch ( res.status ) {
        case 200:
          Win.cur.alert("Deleted successfully.")
        default:
          Win.cur.alert("Failed to delete user.")
      }
      app.reload
    }
  }
}
