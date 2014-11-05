using fui
using fwt
using gfx

class borderPane : App {
  new make() : super() {
    content = BorderPane {
      GridPane {
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        BorderPane {
          it.bg = Color.gray
          GridPane {
            Label { 
              text = "hello" 
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
