using concurrent
using fui
using fwt
using gfx
using util
using webfwt

@Js
class ThemesApp : App {
  ThemesList sideList := ThemesList {
    prefw = 300
    onSelect.add |e| { apiCall( Uri( ( (Str:Obj?) e.data )[ "name" ] ), name ).get |res| {
      json := (Str:Obj?) JsonInStream( res.content.in ).readJson
      _updateList( json )
      json = json[ "selected" ]
      selectedName = json[ "name" ]
      selectedTitle = json[ "title" ]
      selectedStyles = json[ "styles" ]
      modifyState
    } }
  }
  GridTablePane contentPane := GridTablePane {
    hgap = vgap = 0
    halignCells = Halign.fill
    valignCells = Valign.fill
  }
  Str myTheme := ""
  Str selectedName := ""
  Str selectedTitle := ""
  Str:Obj? selectedStyles := [:]
  
  new make() : super() {
    content = SashPane {
      BorderPane {
        it.bg = gfx::Color.green
      },
      BorderPane {
        it.bg = gfx::Gradient("linear(0% 0%,100% 100%,#f1c6ff 0.14,#f97766 0.38,#8eb92a 0.49,#72aa00 0.51,#f5ff3a 0.76,#5b38f7 0.9)")
      },
      BorderPane {
        it.bg = gfx::Pattern( Image( `/pod/fui/res/img/home-50.png` ) )
      },
    }
    content.children.each |borderPane| {
      borderPane.add( Text {
        it.bg = Color( 0, true ); text = Buf().writeObj( ( borderPane as BorderPane ).bg ).flip.readAllStr
        it.editable = false
        it.multiLine = true
      } )
    }
    
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
      center = BorderPane {
        border = Border( "1 solid #000000" )
        insets = Insets( 10 )
        contentPane,
      }
    }
  }
  
  private Obj?[] _myCurrentSelected() { [sideList.items.find |obj| { ( (Str:Obj?) obj)["name"] == myTheme }] }
  
  private Void _updateList( Str:Obj? json ) {
    myTheme = json[ "myTheme" ]
    if ( sideList.items != json[ "list" ] ) {
      selected := sideList.selected
      sideList.items = json[ "list" ]
      sideList.relayout
      sideList.selected = sideList.items.containsAll( selected ) ? selected : [,]
      updateState
    }
    //if ( sideList.selected.size == 0 ) sideList.selected = myCurrentSelected
  }
  
  override Void onGoto() { apiCall( ``, name ).get |res| { _updateList( JsonInStream( res.content.in ).readJson ) } }
  
  override Void onSaveState( State state ) {
    state[ "sideListSelected" ] = sideList.selectedIndex
    state[ "sideListItems" ] = sideList.items
    state[ "myTheme" ] = myTheme
    state[ "selectedName" ] = selectedName
    state[ "selectedTitle" ] = selectedTitle
    state[ "selectedStyles" ] = selectedStyles
  }
  
  override Void onLoadState( State state ) {
    sideList.items = state[ "sideListItems" ] ?: [,]
    sideList.relayout
    sideList.selectedIndex = state[ "sideListSelected" ]
    myTheme = state[ "myTheme" ] ?: ""
    selectedName = state[ "selectedName" ] ?: ""
    selectedTitle = state[ "selectedTitle" ] ?: ""
    selectedStyles = state[ "selectedStyles" ] ?: [:]
    if ( selectedStyles.size > 0 ) {
      Actor.locals[ "themes.name" ] = selectedName
      Actor.locals[ "themes.title" ] = selectedTitle
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
  }
}

@Js
class ThemesList : TreeList {
  override Str text( Obj item ) { ( item as Str:Obj? )?.get( "title" )?.toStr ?: "Untitled" }
}