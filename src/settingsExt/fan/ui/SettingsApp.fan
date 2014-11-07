using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class SettingsApp : App {
  [Str:Str]? contentData { private set }
  Str:SettingsPane listMap := [
      DatabasePane.listName : DatabasePane( this ),
      ServerPane.listName : ServerPane( this )
    ] { private set }
  private BorderPane pageContent := BorderPane()
  
  private TreeList list := TreeList {
    it.items = listMap.keys
    it.onSelect.add |e| {
      selected := list.selected[0]
      a := Fui.cur.baseUri + "api/settings?option=$selected".toUri
      apiCall( a ).get |res| {
        list.selected[0] = selected
        contentData = ( (Str:Obj?) JsonInStream( res.content.in ).readJson ).map |Obj? o->Str| { o?.toStr ?: "" }
        listMap[ selected ].getData
        modifyState
      }
    }
  }
  
  new make() : super() {
    content = BorderPane {
      it.bg = Gradient.fromStr("0% 50%, 100% 50%, #f00 0.1, #00f 0.9", true)
      EdgePane {
        center = SashPane {
          it.weights = [25, 75]
          EdgePane {
            center = list
          },
          pageContent,
        }
      },
    }
    relayout
  }
  
  override Void onSaveState( State state ) {
    state[ "listSelected" ] = list.selectedIndex
    state[ "contentData" ] = contentData
    listMap[ list.selected[0] ].onSaveState( state )
  }
  
  override Void onLoadState( State state ) {
    list.selectedIndex = state[ "listSelected" ] ?: 0
    contentData = ( ([Str:Obj?]?) state[ "contentData" ] )?.map |Obj? o->Str| { o?.toStr ?: "" }
    if ( contentData != null ) listMap[ list.selected[0] ].onLoadState( state )
    pageContent.content = listMap[ list.selected[0] ]
    pageContent.relayout
  }
}
