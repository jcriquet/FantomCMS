using fui
using fwt
using gfx
using util
using webfwt

@Js
class ThemesApp : App {
  ThemesList sideList := ThemesList {
    prefw = 300
    onSelect.add { modifyState }
  }
  GridTablePane contentPane := GridTablePane {
    hgap = vgap = 0
    halignCells = Halign.fill
    valignCells = Valign.fill
  }
  
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
  
  override Void onSaveState( State state ) {
    state[ "sideListSelected" ] = sideList.selectedIndex
    state[ "sideListItems" ] = sideList.items
  }
  
  override Void onLoadState( State state ) {
    sideList.items = state[ "sideListItems" ] ?: [,]
    sideList.relayout
    sideList.selectedIndex = state[ "sideListSelected" ]
    apiCall( Uri( ( ([Str:Obj?]?) sideList.selected.getSafe( 0 ) )?.get( "name" ) ?: "" ), name ).get |res| {
      json := (Str:Obj?) JsonInStream( res.content.in ).readJson
      if ( sideList.items != json[ "list" ] ) {
        selected := sideList.selected
        sideList.items = json[ "list" ]
        sideList.relayout
        sideList.selected = sideList.items.containsAll( selected ) ? selected : [,]
      }
      if ( sideList.selectedIndex != null ) {
        insets := Insets( 7 )
        contentPane.populate( json[ "selected" ]->get( "styles" ) ) |cell, col, row| {
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
                    StyledButton {
                      it.bg = bgPressed = ( (Str) cell ).in.readObj
                    },
                  },;
                  Label { text = cell },;
                default: Label { text = cell.toStr },;
              }
            }
          }
        }
      }
    }
  }
}

@Js
class ThemesList : TreeList {
  override Str text( Obj item ) { ( item as Str:Obj? )?.get( "title" )?.toStr ?: "Untitled" }
}