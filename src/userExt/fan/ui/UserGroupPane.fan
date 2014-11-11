using fui
using fwt
using gfx
using util

@Js
class UserGroupPane : UserPane {
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
    app.apiCall( `groups`, app.name ).get |res| {
      json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
      insets := Insets( 7 )
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
          Label { it.text = cell.toStr },
        }
      }
    }
  }
}
