using fui
using fwt
using gfx
using util

@Js
class UserListPane : UserPane {
  GridTablePane table := GridTablePane {
    halignCells = Halign.fill
    valignCells = Valign.fill
    hgap = vgap = 0
  }
  
  new make( UserApp app ) : super( app ) {
    content = EdgePane {
      top = EdgePane {
        left = Label {
          text = "MANAGE USERS"
        }
        right = Text {
          text = "Search"
        }
      }
      center = table
    }
  }
  
  override Void onLoadState( State state ) {
    app.apiCall( `list`, app.name ).get |res| {
      json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
      //echo( json )
      insets := Insets( 7 )
      //json.each |row| { row.remove( "_id" ) }
      table.populate( json ) |cell, col, row| {
        if ( cell == null ) {
          if ( row == null ) return BorderPane {
            border = Border( "1 solid #000000" )
            it.insets = insets
            Label { text = col.toStr.capitalize },
          }
          else return BorderPane {
            border = Border( "1 solid #000000" )
            it.insets = insets
          }
        }
        return BorderPane {
          border = Border( "1 solid #000000" )
          it.insets = insets
          /*if ( col == "_id" ) {
            Button { it.onAction.add { EditPane( cell ).open } },
          } else {
            //add label
          }*/
          Label { it.text = cell.toStr },
        }
      }
      //json.each |map| { echo( map ) }
      //echo( json[ 0 ][ "name" ] )
    }
  }
}
