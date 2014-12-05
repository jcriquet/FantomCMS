using concurrent
using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class LayoutsApp : App {
  LayoutsList sideList := LayoutsList {
    prefw = 300
    onSelect.add |e| { apiCall( Uri( ( (Str:Obj?) e.data )[ "_id" ] ) ).get |res| { load( res ) } }
  }
  StyledButton newButton := StyledButton { onAction.add { newLayout }; Label { it.text = "New" }, }
  StyledButton deleteButton := StyledButton { onAction.add { delete }; Label { it.text = "Delete" }, }
  StyledButton saveButton := StyledButton { onAction.add { save }; Label { it.text = "Save" }, }
  StyledButton revertButton := StyledButton { onAction.add { revert }; Label { it.text = "Revert" }, }
  StyledButton defaultButton := StyledButton { onAction.add { setDefault }; Label { it.text = "Set Default" }, }
  Str myLayout := ""
  Str selectedId := ""
  Text selectedTitle := Text()
  Text selectedTop := Text { prefRows = 12; multiLine = true }
  Text selectedBottom := Text { prefRows = 12; multiLine = true }
  Text selectedLeft := Text { prefRows = 12; multiLine = true }
  Text selectedRight := Text { prefRows = 12; multiLine = true }
  
  new make() : super() {
    content = EdgePane {
      left = EdgePane {
        top = BorderPane {
          border = Border( "1 solid #000000" )
          bg = Color( "#CCCCCC" )
          Label {
            halign = Halign.center
            text = "Installed Layouts"
          },
        }
        center = sideList
      }
      center = EdgePane {
        top = BorderPane {
          border = Border( "1,1,0 solid #000000" )
          insets = Insets( 5, 10 )
          FlowPane {
            StyledButton.group( [newButton, deleteButton] ),
            StyledButton.group( [saveButton, revertButton] ),
            defaultButton,
          },
        }
        center = ScrollPane {
          hbar.visible = false
          vbar.visible = false
          BorderPane {
            border = Border( "1 solid #000000" )
            insets = Insets( 10 )
            GridPane {
              numCols = 2
              expandCol = 1
              halignCells = Halign.fill
              valignCells = Valign.center
              Label { it.text = "Title:" }, selectedTitle,
              Label { it.text = "Top:" }, selectedTop,
              Label { it.text = "Bottom:" }, selectedBottom,
              Label { it.text = "Left:" }, selectedLeft,
              Label { it.text = "Right:" }, selectedRight,
            },
          },
        }
      }
    }
  }
  
  private Obj?[] _myCurrentSelected() { [sideList.items.find |obj| { ( (Str:Obj?) obj)["_id"] == myLayout }] }
  
  private Void _updateList( Str:Obj? json ) {
    myLayout = json[ "myLayout" ]
    if ( sideList.items != json[ "list" ] ) {
      selected := sideList.selected
      sideList.items = json[ "list" ]
      sideList.relayout
      sideList.selected = sideList.items.containsAll( selected ) ? selected : [,]
      updateState
    }
  }
  
  Void load( HttpRes res ) {
    json := (Str:Obj?) JsonInStream( res.content.in ).readJson
    _updateList( json )
    json = json[ "selected" ]
    selectedId = json[ "_id" ]
    selectedTitle.text = json[ "title" ]
    selectedTop.text = json[ "paneTop" ] ?: "null"
    selectedBottom.text = json[ "paneBottom" ] ?: "null"
    selectedLeft.text = json[ "paneLeft" ] ?: "null"
    selectedRight.text = json[ "paneRight" ] ?: "null"
    modifyState
  }
  Void revert() { apiCall( selectedId.toUri ).get |res| { load( res ) } }
  
  Void save() {
    json := State.valueToStr( ["title":selectedTitle.text, "paneTop":selectedTop.text, "paneBottom":selectedBottom.text, "paneLeft":selectedLeft.text, "paneRight":selectedRight.text] )
    apiCall( selectedId.toUri ).post( json ) |res| { load( res ) }
  }
  
  Void newLayout() {
    selectedId = ""
    selectedTitle.text = "New Layout"
    selectedTop.text = selectedBottom.text = selectedLeft.text = selectedRight.text = "null"
    modifyState
  }
  
  Void delete() { apiCall( selectedId.toUri + `?delete` ).get |res| { load( res ) } }
  
  Void setDefault() { apiCall( selectedId.toUri + `?default` ).get |res| { load( res ) } }
  
  override Void onGoto() { apiCall( `` ).get |res| { _updateList( JsonInStream( res.content.in ).readJson ) } }
  
  override Void onSaveState( State state ) {
    state[ "sideListItems" ] = sideList.items
    state[ "myLayout" ] = myLayout
    state[ "selectedId" ] = selectedId
    state[ "selectedTitle" ] = selectedTitle.text
    state[ "selectedTop" ] = selectedTop.text
    state[ "selectedBottom" ] = selectedBottom.text
    state[ "selectedLeft" ] = selectedLeft.text
    state[ "selectedRight" ] = selectedRight.text
  }
  
  override Void onLoadState( State state ) {
    myLayout = state[ "myLayout" ] ?: ""
    selectedId = state[ "selectedId" ] ?: ""
    selectedTitle.text = state[ "selectedTitle" ] ?: ""
    selectedTop.text = state[ "selectedTop" ] ?: "null"
    selectedBottom.text = state[ "selectedBottom" ] ?: "null"
    selectedLeft.text = state[ "selectedLeft" ] ?: "null"
    selectedRight.text = state[ "selectedRight" ] ?: "null"
    sideList.items = state[ "sideListItems" ] ?: [,]
    sideList.relayout
    sideList.selectedIndex = sideList.items.findIndex |item| { ( item as Str:Obj? ).get( "_id" ) == selectedId }
    deleteButton.enabled = defaultButton.enabled = sideList.selectedIndex != null && !sideList.isDefault( sideList.selected[ 0 ] )
    if ( selectedId != "" ) {
      Actor.locals[ "layouts._id" ] = selectedId
      Actor.locals[ "layouts.title" ] = selectedTitle.text
      Actor.locals[ "layouts.paneTop" ] = selectedTop.text
      Actor.locals[ "layouts.paneBottom" ] = selectedBottom.text
      Actor.locals[ "layouts.paneLeft" ] = selectedLeft.text
      Actor.locals[ "layouts.paneRight" ] = selectedRight.text
    }
    Fui.cur.main.refreshLayout
  }
}

@Js
class LayoutsList : TreeList {
  override Str text( Obj item ) { ( isDefault( item ) ? "*" : "" ) + title( item ) }
  Bool isDefault( [Str:Obj?]? item ) { item?.get( "default" ) == true }
  Str title( [Str:Obj?]? item ) { item?.get( "title" )?.toStr ?: "Untitled" }
}