using dom
using fwt
using gfx
using webfwt

@Js
@Serializable
class LoginPane : ThemedBorderPane {
  const Str? curUser
  const Bool force
  
  new make( |This|? f := null ) : super( f ) {
    curUser = force ? null : Env.cur.vars[ "fui.curUser" ] as Str
    if ( curUser == null ) {
      field_username := Text()
      field_password := Text{ password = true }
      rememberButton := Button { mode = ButtonMode.check; text = "Remember me" }
      loginButton := Button {
        text = "Log in"
        onAction.add {
          App.apiCallApp( ``, "login" ).postForm( ["username":field_username.text,"password":field_password.text] ) |res| {  
            switch ( res.status ) {
              case 200:
                if ( Fui.cur.curApp?.name == "login" ) Win.cur.hyperlink( Main.resolve(`fui://app/home/` ) )
                else Win.cur.reload( true )
              default:
                Win.cur.alert( "Invalid username/password." )
            }
          }
        }
      }
      actionEvent := |Event e| { loginButton.onAction.fire( e ) }
      field_username.onAction.add( actionEvent )
      field_password.onAction.add( actionEvent )
      rememberButton.onAction.add( actionEvent )
      content = GridPane {
        halignCells = Halign.right
        GridPane {
          numCols = 2
          Label { text = "Username" },
          field_username,
          Label { text = "Password" },
          field_password,
        },
        GridPane {
          numCols = 2
          rememberButton,
          loginButton,
        },
      }
    } else {
      content = FlowPane {
        Label { text = "Welcome, $curUser! " },
        GotoButton( `fui://logout` ) {
          Label {
            font = Font( "Arial", 8 )
            text = "(logout)"
          },
        },
      }
    }
  }
}
