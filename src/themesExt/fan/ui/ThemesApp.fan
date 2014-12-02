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
    cols = ["bg", "fg", "font"]
  }
  LayoutCombo layoutSelector := LayoutCombo {
    onModify.add |e| {
      newLayout := ( layoutSelector.selected as Str:Obj? )?.get( "_id" )
      if ( newLayout == selectedLayoutId || newLayout == null ) return
      apiCall( ( selectedId + "?layout=" + newLayout ).toUri, name ).get |res| { load( res ) }
    }
  }
  Str myTheme := ""
  Str selectedId := ""
  Str:Obj? selectedLayout := [:]
  Str? selectedLayoutId() { selectedLayout[ "layouts._id" ] }
  Text selectedTitle := Text {}
  Str:Obj? selectedStyles := Str:[Str:Str?][:] { ordered = true }
  
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
          bg = Color( 134217728, true )
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
          ScrollPane {
            InsetPane {
              insets = Insets( 10 )
              GridPane {
                GridPane {
                  numCols = 2
                  Label { it.text = "Title:" },
                  selectedTitle,
                  Label { it.text = "Layout:" },
                  layoutSelector,
                },
                BorderPane {
                  border = Border( "1 solid #000000" )
                  contentPane,
                },
              },
            },
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
    if ( layoutSelector.items != json[ "layouts" ] ) {
      layoutSelector.items = json[ "layouts" ]
      layoutSelector.parent.parent.relayout
      layoutSelector.selectedIndex = layoutSelector.items.findIndex |item| { ( item as Str:Obj? ).get( "_id" ) == selectedLayoutId }
      updateState
    }
  }
  
  Void load( HttpRes res ) {
    json := (Str:Obj?) JsonInStream( res.content.in ).readJson
    _updateList( json )
    json = json[ "selected" ]
    selectedId = json[ "_id" ]
    selectedTitle.text = json[ "title" ]
    selectedLayout = json[ "layout" ]
    selectedStyles = json[ "styles" ] ?: [:]
    modifyState
  }
  Void revert() { apiCall( selectedId.toUri, name ).get |res| { load( res ) } }
  
  Void save() {
    json := State.valueToStr( ["title":selectedTitle.text, "layout":selectedLayoutId, "styles":selectedStyles] )
    apiCall( selectedId.toUri, name ).post( json ) |res| { load( res ) }
  }
  
  Void newTheme() {
    selectedId = ""
    selectedTitle.text = "New Theme"
    selectedStyles.clear.add( "window", ["bg":"gfx::Color(\"#FFFFFF\")"] )
    modifyState
  }
  
  Void delete() { apiCall( selectedId.toUri + `?delete`, name).get |res| { load( res ) } }
  
  Void setDefault() { apiCall( "$selectedId?default&layout=$selectedLayoutId".toUri, name).get |res| { load( res ) } }
  
  override Void onGoto() { apiCall( ``, name ).get |res| { _updateList( JsonInStream( res.content.in ).readJson ) } }
  
  override Void onSaveState( State state ) {
    state[ "sideListItems" ] = sideList.items
    state[ "layoutSelectorItems" ] = layoutSelector.items
    state[ "myTheme" ] = myTheme
    state[ "selectedId" ] = selectedId
    state[ "selectedTitle" ] = selectedTitle.text
    state[ "selectedLayout" ] = selectedLayout
    state[ "selectedStyles" ] = selectedStyles
  }
  
  override Void onLoadState( State state ) {
    myTheme = state[ "myTheme" ] ?: ""
    selectedId = state[ "selectedId" ] ?: ""
    selectedTitle.text = state[ "selectedTitle" ] ?: ""
    selectedLayout = state[ "selectedLayout" ] ?: [:]
    selectedStyles = state[ "selectedStyles" ] ?: Str:[Str:Str?][:] { ordered = true }
    sideList.items = state[ "sideListItems" ] ?: [,]
    sideList.relayout
    sideList.selectedIndex = sideList.items.findIndex |item| { ( item as Str:Obj? ).get( "_id" ) == selectedId }
    layoutSelector.enabled = saveButton.enabled = selectedStyles.size > 0
    layoutSelector.items = state[ "layoutSelectorItems" ] ?: [,]
    layoutSelector.selectedIndex = layoutSelector.items.findIndex |item| { ( item as Str:Obj? ).get( "_id" ) == selectedLayoutId }
    revertButton.enabled = saveButton.enabled && selectedId != ""
    deleteButton.enabled = defaultButton.enabled = sideList.selectedIndex != null && !sideList.isDefault( sideList.selected[ 0 ] )
    if ( saveButton.enabled ) {
      Actor.locals.keys.each |k| { if ( k.startsWith( "themes." ) ) Actor.locals.remove( k ) }
      Actor.locals[ "themes._id" ] = selectedId
      Actor.locals[ "themes.title" ] = selectedTitle.text
      selectedStyles.each |style, styleName| { ( (Str:Obj?) style ).each |v, objName| { Actor.locals[ "themes.styles.${styleName}.${objName}" ] = v } }
      selectedLayout.each |v, k| { if ( k.startsWith( "layouts." ) ) Actor.locals[ k ] = v }
      insets := Insets( 7 )
      stdBorder := Border( "1 solid #000000,#CCCCCC" )
      contentPane.populate( selectedStyles.dup.add( "New Style", Str:Obj?[:] ) ) |cell, col, row| {
        if ( col == null ) {
          if ( row == null ) return BorderPane { bg = Color.white; border = stdBorder; ContentPane(), }
          else return BorderPane { bg = Color.white; border = stdBorder; widgetRowHeader( row ), }
        } else if ( row == null ) return BorderPane { bg = Color.white; border = stdBorder; it.insets = insets; GridPane { halignPane = Halign.center; Label { text = col }, }, }
        else return BorderPane {
          bg = Color.white; border = stdBorder; it.insets = insets
          if ( cell == null ) widgetNew( col, row ),;
          else switch ( col ) {
            case "bg":
            case "fg":
              widgetBrush( cell, col, row ),;
            case "font":
              widgetFont( cell, col, row ),;
            default: Label { text = cell.toStr },;
          }
        }
      }
    } else contentPane.populate( null ) { Label { text = "Select a theme or create a new one!" } }
    Fui.cur.main.refreshLayout
  }
  
  private Widget widgetRowHeader( Obj? row ) {
    GridPane {
      numCols = 2
      valignCells = Valign.fill
      expandCol = expandRow = 0
      Text? newText
      GridPane {
        vgap = 0;
        expandRow = 1
        valignPane = Valign.fill
        valignCells = Valign.center
        if ( row != "New Style" ) {
          i := selectedStyles.keys.index( row )
          StyledButton {
            border = null; bg = null
            if ( i > 0 ) {
              onAction.add {
                keys := selectedStyles.keys
                newStyles := Str:Obj?[:] { ordered = true }
                keys.insert( i - 1, keys.remove( row ) ).each |key| { newStyles.add( key, selectedStyles[ key ] ) }
                selectedStyles = newStyles
                modifyState
              }
              Label { image = Image( Main.resolve( `fui://pod/fwt/res/img/arrowUp.png` ) ) },
            } else { it.enabled = false; Label { image = Image( Main.resolve( `fui://pod/fwt/res/img/arrowUp.png` ) ) }, }
          },
          InsetPane { it.insets = Insets( 0, 0, 0, 30 ); Label { text = row }, },
          StyledButton {
            border = null; bg = null
            if ( i < selectedStyles.size - 1 ) {
              onAction.add {
                keys := selectedStyles.keys
                newStyles := Str:Obj?[:] { ordered = true }
                keys.insert( i + 1, keys.remove( row ) ).each |key| { newStyles.add( key, selectedStyles[ key ] ) }
                selectedStyles = newStyles
                modifyState
              }
              Label { image = Image( Main.resolve( `fui://pod/fwt/res/img/arrowDown.png` ) ) },
            } else { it.enabled = false; Label { image = Image( Main.resolve( `fui://pod/fwt/res/img/arrowDown.png` ) ) }, }
          },
        } else ( newText = WebText { placeHolder = "New Style" } ),
      },
      GridPane {
        valignPane = Valign.top
        if ( row != "New Style" ) StyledButton {
          border = null; bg = null
          onAction.add { selectedStyles.remove( row ); modifyState }
          Label { text = "x" },
        },;
        else StyledButton {
          border = null; bg = null
          event := |->| {
            if ( newText.text.containsChar( ' ' ) ) Dialog(null, null) { body = "You can not have spaces in the style name."; commands = [Dialog.ok] }.open
            else if ( newText.text != "" ) { selectedStyles.add( newText.text, Str:Str?[:] ); modifyState }
          }
          onAction.add( event ); newText.onAction.add( event )
          Label { text = "+" },
        },
      },
    }
  }
  
  private Widget widgetNew( Obj? col, Obj? row ) {
    if ( row == "New Style" ) return ContentPane()
    return ConstraintPane {
      minw = maxw = minh = maxh = 50
      it.content = StyledButton {
        border = null; bg = null
        onAction.add {
          switch ( col ) {
            case "bg":
              selectedStyles[ row ]->set( col, "gfx::Color(\"#FFFFFF\")" )
            case "fg":
              selectedStyles[ row ]->set( col, "gfx::Color(\"#000000\")" )
            case "font":
              selectedStyles[ row ]->set( col, "gfx::Font(\"12pt Ariel\")" )
          }
          modifyState
        }
        Label { font = Font.makeFields( "Ariel", 24 ); text = "+" },
      }
    }
  }
  
  private Widget widgetBrush( Obj? cell, Obj? col, Obj? row ) {
    ConstraintPane {
      minw = maxw = minh = maxh = 50
      it.content = StyledButton {
        try it.bg = bgPressed = ( ( (Str) cell ).in.readObj as Brush ) ?: FuiThemes.defColorNone
        catch ( Err e ) it.bg = bgPressed = FuiThemes.defColorNone
        onAction.add |e| {
          overlay := BrushDialog( cell ) |result| {
            if ( result == "" ) {
              selectedStyles[ row ]->remove( col )
              modifyState
            } else if ( selectedStyles[ row ]->get( col ) != result ) {
              selectedStyles[ row ]->set( col, result )
              modifyState
            }
          }
          OverlayContainer( e.widget, overlay ).display( e.widget, Point( 0, e.widget.size.h ) )
        }
      }
    }
  }
  
  private Widget widgetFont( Obj? cell, Obj? col, Obj? row ) {
    ConstraintPane {
      minw = maxw = minh = maxh = 50
      it.content = StyledButton {
        onAction.add |e| {
          overlay := BrushDialog( cell ) |result| {
            if ( result == "" ) {
              selectedStyles[ row ]->remove( col )
              modifyState
            } else if ( selectedStyles[ row ]->get( col ) != result ) {
              selectedStyles[ row ]->set( col, result )
              modifyState
            }
          }
          OverlayContainer( e.widget, overlay ).display( e.widget, Point( 0, e.widget.size.h ) )
        }
        Label {
          text = "Abc"
          halign = Halign.center
          try font = ( ( (Str) cell ).in.readObj as Font ) ?: null
          catch ( Err e ) font = null
        },
      }
    }
  }
}

@Js
class ThemesList : TreeList {
  override Str text( Obj item ) { ( isDefault( item ) ? "*" : "" ) + title( item ) }
  Bool isDefault( [Str:Obj?]? item ) { item?.get( "default" ) == true }
  Str title( [Str:Obj?]? item ) { item?.get( "title" )?.toStr ?: "Untitled" }
}

@Js
class LayoutCombo : WebCombo {
  new make( |This|? f := null ) : super( f ) {}
  override Str itemText( Obj item ) { item->get( "title" ) as Str ?: "Untitled" }
}