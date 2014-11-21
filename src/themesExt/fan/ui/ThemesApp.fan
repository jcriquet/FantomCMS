using concurrent
using dom
using fui
using fwt
using gfx
using util
using webfwt

@Js
class ThemesApp : App {
  ThemesList sideList := ThemesList {
    prefw = 300
    onSelect.add |e| { apiCall( Uri( ( (Str:Obj?) e.data )[ "_id" ] ), name ).get |res| { load( res ) } }
  }
  StyledButton newButton := StyledButton { onAction.add { newTheme }; Label { it.text = "New" }, }
  StyledButton deleteButton := StyledButton { onAction.add { delete }; Label { it.text = "Delete" }, }
  StyledButton saveButton := StyledButton { onAction.add { save }; Label { it.text = "Save" }, }
  StyledButton revertButton := StyledButton { onAction.add { revert }; Label { it.text = "Revert" }, }
  StyledButton defaultButton := StyledButton { onAction.add { setDefault }; Label { it.text = "Set Default" }, }
  GridTablePane contentPane := GridTablePane {
    hgap = vgap = 0
    halignCells = Halign.fill
    valignCells = Valign.fill
  }
  Str myTheme := ""
  Str selectedId := ""
  Text selectedTitle := Text {}
  Str:Obj? selectedStyles := [:]
  
  new make() : super() {
    content = EdgePane {
      left = EdgePane {
        top = BorderPane {
          border = Border( "1 solid #000000" )
          bg = Color( "#CCCCCC" )
          Label {
            halign = Halign.center
            text = "Installed Themes"
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
        center = BorderPane {
          border = Border( "1 solid #000000" )
          insets = Insets( 10 )
          GridPane {
            FlowPane {
              Label { it.text = "Title:" },
              selectedTitle,
            },
            contentPane,
          },
        }
      }
    }
  }
  
  private Obj?[] _myCurrentSelected() { [sideList.items.find |obj| { ( (Str:Obj?) obj)["_id"] == myTheme }] }
  
  private Void _updateList( Str:Obj? json ) {
    myTheme = json[ "myTheme" ]
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
    selectedStyles = json[ "styles" ]
    modifyState
  }
  Void revert() { apiCall( selectedId.toUri, name ).get |res| { load( res ) } }
  
  Void save() {
    json := State.valueToStr( ["title":selectedTitle.text, "styles":selectedStyles] )
    apiCall( selectedId.toUri, name ).post( json ) |res| { load( res ) }
  }
  
  Void newTheme() {
    selectedId = ""
    selectedTitle.text = "New Theme"
    selectedStyles = [
      "header":["bg":"gfx::Color(\"#FFFFFF\")"],
      "footer":["bg":"gfx::Color(\"#FFFFFF\")"],
    ]
    modifyState
  }
  
  Void delete() { apiCall( selectedId.toUri + `?delete`, name).get |res| { load( res ) } }
  
  Void setDefault() { apiCall( selectedId.toUri + `?default`, name).get |res| { load( res ) } }
  
  override Void onGoto() { echo( "onGoto" ); apiCall( ``, name ).get |res| { _updateList( JsonInStream( res.content.in ).readJson ) } }
  
  override Void onSaveState( State state ) {
    state[ "sideListItems" ] = sideList.items
    state[ "myTheme" ] = myTheme
    state[ "selectedId" ] = selectedId
    state[ "selectedTitle" ] = selectedTitle.text
    state[ "selectedStyles" ] = selectedStyles
  }
  
  override Void onLoadState( State state ) {
    myTheme = state[ "myTheme" ] ?: ""
    selectedId = state[ "selectedId" ] ?: ""
    selectedTitle.text = state[ "selectedTitle" ] ?: ""
    selectedStyles = state[ "selectedStyles" ] ?: [:]
    sideList.items = state[ "sideListItems" ] ?: [,]
    sideList.relayout
    sideList.selectedIndex = sideList.items.findIndex |item| { ( item as Str:Obj? ).get( "_id" ) == selectedId }
    deleteButton.enabled = defaultButton.enabled = sideList.selectedIndex != null && !sideList.isDefault( sideList.selected[ 0 ] )
    if ( selectedStyles.size > 0 ) {
      Actor.locals[ "themes.id" ] = selectedId
      Actor.locals[ "themes.title" ] = selectedTitle.text
      selectedStyles.each |style, styleName| { ( (Str:Obj?) style ).each |v, objName| { Actor.locals[ "themes.styles.${styleName}.${objName}" ] = v } }
      //if ( Actor.locals[ "themessaved.name" ] == null )
      //  Actor.locals.findAll |v, k| { k.startsWith( "themes." ) }.each |v, k| { Actor.locals[ "themessaved." + k[ 7..-1 ] ] = v }
      insets := Insets( 7 )
      contentPane.populate( selectedStyles ) |cell, col, row| {
        if ( cell == null ) {
          if ( col == null ) {
            if ( row == null ) return BorderPane { border = Border( "1 solid #000000" ); ContentPane(), }
            else return BorderPane { border = Border( "0,1,1 solid #000000" ); it.insets = insets; GridPane { valignPane = Valign.center; Label { text = row.toStr.capitalize }, }, }
          } else if ( row == null ) return BorderPane { border = Border( "1,1,1,0 solid #000000" ); it.insets = insets; GridPane { halignPane = Halign.center; Label { text = col.toStr.capitalize }, }, }
          else return ContentPane()
        } else {
          return BorderPane {
            border = Border( "0,1,1,0 solid #000000" )
            it.insets = insets
            switch ( col ) {
              case "bg":
                ConstraintPane {
                  minw = maxw = minh = maxh = 50
                  me := it
                  |Str|? makeButton
                  makeButton = |Str text| {
                    me.content = StyledButton {
                      it.bg = bgPressed = text.in.readObj
                      onAction.add |e| { BrushDialog( cell ) |result| {
                        makeButton( result )
                        selectedStyles[ row ]->set( "bg", result )
                        modifyState
                      }.open( e.widget, Point( 0, e.widget.size.h ) ) }
                    }
                    me.relayout
                  }
                  makeButton( cell )
                },
                Label { text = cell },;
              default: Label { text = cell.toStr },;
            }
          }
        }
      }
    } else contentPane.populate( null ) { ContentPane() }
    contentPane.parent.relayout
  }
}

@Js
class ThemesList : TreeList {
  override Str text( Obj item ) { ( isDefault( item ) ? "*" : "" ) + title( item ) }
  Bool isDefault( [Str:Obj?]? item ) { item?.get( "default" ) == true }
  Str title( [Str:Obj?]? item ) { item?.get( "title" )?.toStr ?: "Untitled" }
}