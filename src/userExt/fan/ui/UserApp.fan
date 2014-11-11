using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class UserApp : App {
  BorderPane contentPane := BorderPane {
    insets = Insets( 10 )
  }
  Str:UserPane contentPaneMap := ["Manage Users":UserListPane( this ), "Manage User Groups":UserGroupPane( this )]
  TreeList sideList := TreeList {
    onSelect.add { modifyState }
  }
  
  new make() : super() {
    sideList.items = contentPaneMap.keys
    content = SashPane {
      it.weights = [15, 85]
      sideList,
      contentPane,
    }
  }
  
  override Void onSaveState( State state ) {
    state[ "selectedIndex" ] = sideList.selectedIndex
    ( (UserPane?) contentPane.content )?.onSaveState( state )
  }
  
  override Void onLoadState( State state ) {
    sideList.selectedIndex = state[ "selectedIndex" ]
    contentPane.content = contentPaneMap[ sideList.selected.getSafe( 0 ) ?: "" ]
    ( (UserPane?) contentPane.content )?.onLoadState( state )
    contentPane.relayout
  }
}
