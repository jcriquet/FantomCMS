using fui
using fwt
using gfx
//using [java] org.mindrot.jbcrypt.BCrypt

//class BCrypt() extends java.lang.Object
//
@Js
class SecurityApp : App {
  
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
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
