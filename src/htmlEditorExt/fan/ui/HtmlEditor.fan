using fwt
using fui
using gfx
using dom
using webfwt
using util

@Js
class HtmlEditor : OverlayPane
{
  Bool newFile := false
  Text filenameText := Text{}
  Text uriText := Text{}
  Str? html
  Editor editor
  
  new make(Str? title := null, Str? uri := null, Str? file := null) : super(){
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
    Buf b := Buf()
    b.writeObj(toSend)
    b.flip
    HttpReq { uri = Fui.cur.baseUri + `/api/htmleditor/newpage` }.post(b.readAllStr) |res| {
      if(res.status == 200) this.doExit
    }
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