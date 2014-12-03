using fui
using web
using fwt
using gfx
using util
using dom

@Js
class LoginApp : App {
  new make() : super() {
    content = GridPane {
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      LoginPane {
        force = true
        bg = Color.gray
        border = Border.fromStr( "3 solid #000000 15" )
        insets = Insets( 10, 16 )
      },
    }
  }
}
