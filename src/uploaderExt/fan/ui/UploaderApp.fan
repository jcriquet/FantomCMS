using fui
using fwt
using gfx
using webfwt

@Js
class UploaderApp : App {
  
  new make() : super() {
    content = GridPane {
      halignPane = halignCells = Halign.center
      valignPane = Valign.center
      Button {
        text = "Upload"
        onAction.add {
          uploader := FileUploader {
            it.uri = Fui.cur.baseUri + `/api/uploader/`
            it.onComplete.add |e| { echo(e); echo(e.data) }
          }
          diag := FileUploader.dialog( this.window, uploader ).open
        }
      },
    }
  }
}
