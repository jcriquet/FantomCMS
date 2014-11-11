using fui
using fwt
using gfx
using util

@Js
class LoginApp : App {
  LoginApp app := this
  Text field_username:= Text()
  Text field_password := Text{password = true}
  
  BorderPane loginPane := BorderPane {
    insets = Insets( 10 )
          it.bg = Gradient.fromStr("0% 50%, 100% 50%, #f00 0.1, #00f 0.9", true)
      GridPane {
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        BorderPane {
          it.bg = Color.gray
          it.border = Border.fromStr( "3 solid #000000 15" )
          it.insets = Insets( 10, 16 )
          GridPane {
            numCols = 3
            Label { 
              text = "Username" 
            },
            field_username,
            Button {
              text = "Log in"
              onAction.add {
               app.apiCall( ``, app.name ).get |res| {
                  json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
                  for(Int i := 0; i < json.size; ++ i) {
                    if(json[i]["name"] == field_username.text) {
                      if(json[i]["password"] == field_password.text) {
                        echo("successfully logged in")
                        loginPane.content = Label{text = "You logged in successfully kinda not really..."}
                        loginPane.relayout
                      } else {
                        echo("incorrect password")
                        loginPane.content = Label{text = "Your login details were incorrect."}
                        loginPane.relayout
                      }
                    } else {
                      echo("username not found")
                      loginPane.content = Label{text = "Your login details were incorrect."}
                      loginPane.relayout
                    }
                  }
                }
              }
            },
            Label { 
              text = "Password"
            },
            field_password,
            Button {
              mode = ButtonMode.check;
              text = "Remember me";
            },
          },
        },  
      },
  }
  
  new make() : super() {
    content = loginPane
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
