using fui
using fwt
using gfx
using util

@Js
class LoginApp : App {
  LoginApp app := this
  
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
            Text {
            
            },
            Button {
              text = "Log in"
              onAction.add {
                echo("Falcon YES")
                loginPane.content = Label{text = "You logged in kinda not really..."}
                loginPane.relayout
                /*Obj? json
                json = DBConnector.cur.db["user"].group(["name", "password"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]])
                echo(json)*/
               app.apiCall( ``, app.name ).get |res| {
                  json := ([Str:Obj?][]) JsonInStream( res.content.in ).readJson
                  echo( json )
                }
              }
            },
            Label { 
              text = "Password"
            },
            Text {
              password = true;
            },
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
