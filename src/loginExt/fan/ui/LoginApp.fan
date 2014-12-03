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
                doLogin()
              }
            },
            Label { 
              text = "Password"
            },
            field_password,
            /*Button {
              mode = ButtonMode.check;
              text = "Remember me";
            },*/
          },
        },  
      },
  }
  
  new make() : super() {
    content = loginPane
  }
  
  Void doLogin(){
    creds := ["username":this.field_username.text,"password":this.field_password.text]
    this.apiCall(`login`).postForm(creds) |res| {  
      switch(res.status){
        case 200:
          Win.cur.alert("Login Successful")
        default:
          Win.cur.alert("Invalid username/password.")
      }
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
