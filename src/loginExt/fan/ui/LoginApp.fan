using fui
using web
using fwt
using gfx
using util
using proj
using dom

@Js
class LoginApp : App {
  LoginApp app := this
  Text field_username:= Text()
  Text field_password := Text{password = true}
  
  BorderPane loginPane := BorderPane {
    insets = Insets( 10 )
      it.bg = Color.white
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
               app.apiCall( `list`, "user" ).get |res| {
                  Bool userFound := false
                  json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
                  for(Int i := 0; i < json.size; ++i) {
                    if(json[i]["name"] == field_username.text) {
                      if(json[i]["password"] == field_password.text) {
                        echo("successfully logged in")
                        this.apiCall(Uri.fromStr(field_username.text)).get{}
                        loginPane.content = Label{text = "You logged in successfully kinda not really..."}
                        loginPane.relayout
                        userFound = true
                        break
                      } else {
                        echo("incorrect password")
                        loginPane.content = Label{text = "Your login details were incorrect."}
                        loginPane.relayout
                        userFound = true
                        break
                      }
                    }
                  }
                  if(userFound == false){
                      echo("username not found")
                      loginPane.content = Label{text = "Your login details were incorrect."}
                      loginPane.relayout
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
