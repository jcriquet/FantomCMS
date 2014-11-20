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
          text = "MANAGE USER GROUPS"
        }
      }
      center = table
    }
  }
  
  override Void onLoadState( State state ) {
    /*permissionArray := Bool[true, true, true]
    permissionArray[0] = false
    permissionArray.add(false)
    echo(permissionArray)*/
    
    //Build state of data from checkboxes into map
    permissionMap := [Str:Map][:]
    
    adminPerm := [Str:Bool][:]
    permissionMap.add("admins", adminPerm)
    
    adminPerm.add("Pages", true)
    echo(permissionMap)
    echo(permissionMap["admins"])
    echo(adminPerm)
    /*permissionMap.add("cat1", true)
    permissionMap.add("cat2", false)
    permissionMap.set("cat1", false)
    echo(permissionMap)
    echo(permissionMap["cat1"])
    echo(permissionMap["cat2"])*/
    
    currCol := "nothing"
    
    app.apiCall( `groups`, app.name ).get |res| {
      json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
      insets := Insets( 7 )
      table.populate( json ) |cell, col, row| {
        if ( cell == null ) {
          if ( row == null ) return BorderPane {
            border = Border( "1 solid #000000" )
            it.insets = insets
            currCol = col
            echo(currCol)
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
          if(col == "name") {
            currCol = cell
            echo(currCol)
            Label { it.text = cell.toStr },
          } else {
            echo(col)
            Button {
              mode = ButtonMode.check
              onAction.add {
                echo(col)
              }
            },
          }
        }
      }
    }
  }
}
