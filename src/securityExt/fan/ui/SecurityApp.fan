// Author:Joshua Leihe

using fui
using fwt
using gfx
//using [js]bCrypt.js

@Js
class SecurityApp : App {
  Text passwordField := Text { password = true }
    
  new make() : super() {
    content = BorderPane {
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
              onAction.add { modifyState }
            },
            Label { 
              text = "Password"
            },
            passwordField,
            Button {
              mode = ButtonMode.check;
              text = "Remember me";
            },
          },
        },  
      },
    }
  }
  
  override Void onSaveState( State state ) {
    bcrypt := Bcrypt()
    salt := bcrypt.genSalt( 5 )
    
    password := passwordField.text
    
    echo( password )
    
    cb := |Str str| { echo( str ) }
    
    bcrypt.hashPw(password, salt, cb )
  }
  
  override Void onLoadState( State state ) {
  }
}

//class ServerEncrypt : BCrypt {
//  new make () {
//    mypass := BCrypt.hashpw("foobar", BCrypt.gensalt())
//  }
//  
//  Void test() {
//    
//  }
//}
