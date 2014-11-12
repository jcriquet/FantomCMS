using fwt
using fui
using gfx
using dom
using webfwt
using util

@Js
class HtmlEditor : OverlayPane
{
  HtmlEditorApp app
  Bool newFile := false
  Text filenameText := Text{}
  Text uriText := Text{}
  Str? html
  Editor editor
  
  new make(HtmlEditorApp app, Str? title := null, Str? uri := null, Str? file := null) : super(){
    this.app = app
    this.onClose.add { app.doRefresh }
    if(file == null) newFile = true
    else{
      Buf a := Buf()
      a.writeChars(file)
      a.flip
      HtmlPaneSerial pane := a.readObj
      this.html = pane.savedHtml
    }
    this.animate = true
    this.content = BorderPane{
      it.bg = Color.gray
      it.border = Border.fromStr("1")
      it.content = EdgePane(){
        it.center = GridPane(){
          it.halignCells = Halign.center
          it.valignCells = Valign.center
          it.halignPane = Halign.center
          it.valignPane = Valign.center
          Editor(){
            this.editor = it
            if(!newFile){
              this.filenameText.text = title
              this.uriText.text = uri
              it.textbox.text = this.html
            }
          },
        }
        it.top = BorderPane{
          it.bg = Color.white
          it.border = Border.fromStr("1")
          it.content = EdgePane{
            it.left = GridPane{
              it.halignCells = Halign.left
              it.halignPane = Halign.left
              it.valignCells = Valign.center
              it.valignPane = Valign.center
              it.numCols = 4
              Label { it.text = "Page Title: " },
              filenameText,
              Label { it.text = "Page URI: " },
              uriText,
            }
            it.right = GridPane{
              it.halignCells = Halign.right
              it.halignPane = Halign.right
              it.valignCells = Valign.center
              it.valignPane = Valign.center
              it.numCols = 2
              Button{
                it.text = "Save"
                it.onAction.add {   
                  doSave()
                }
              },
              Button{
                it.text = "Exit"
                it.onAction.add {   
                  doExit()
                }
              },
            }
          }
        }
      }
    }
  }
  
  Void doSave(){
    htmlData := HtmlPaneSerial(this.editor.textbox.text)
    Buf a := Buf()
    a.writeObj(htmlData)
    a.flip
    toSend := ["title":this.filenameText.text, "data":a.readAllStr, "uri":this.uriText.text]
    this.app.apiCall(`newpage`).postForm(toSend) |res| {
      echo( res.status )
      echo( res.content )
      echo( res.headers )
      switch(res.status){
      case 304:
        doOverwrite(toSend)
      case 201:
        Win.cur.alert("Saved.")
        doExit()
      }
    }
  }
  
  Void doOverwrite(Map toSend){
    Bool? toOverwrite
    OverlayPane{
      pane := it
      it.content = BorderPane{
        it.border = Border.fromStr("1")
        it.insets = Insets(2)
        it.bg = Color.white
        EdgePane{
          it.center = Label{ it.text = "Entry already exists. Overwrite?" }
          it.bottom = GridPane{
            it.numCols = 2
            it.halignCells = Halign.center
            it.valignCells = Valign.center
            it.halignCells = Halign.center
            it.valignCells = Valign.center
            Button { it.text = "Yes" ; it.onAction.add { toOverwrite = true ; pane.close }},
            Button { it.text = "No" ; it.onAction.add { toOverwrite = false ; pane.close }},
          }
        },
      }
      it.onClose.add { 
        if(toOverwrite){
          this.app.apiCall(`overwrite`).postForm(toSend) |res| {
            switch(res.status){
              case 201:
                Win.cur.alert("Overwritten.")
                doExit()
              default:
                Win.cur.alert("Error saving.")
            }
          }
        }
      }
    }.open(this, Point(Point.defVal.x + 200, Point.defVal.y + 200))
  }

  Void doExit(){
    this.close
  }
}

@Js
class Editor : BorderPane{
  WebText textbox := WebText(){
    it.multiLine = true
    it.font = Font.fromStr("12pt Courier")
  }
  
  new make() : super(){
    this.bg = Color.white
    this.content = textbox
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(800, 500)
  }
}