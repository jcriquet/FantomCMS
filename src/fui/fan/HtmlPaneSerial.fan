using webfwt

@Js
@Serializable
class HtmlPaneSerial : HtmlPane {
  Str savedHtml { set { html = &savedHtml = it } }
  Int savedWidth { set { width = &savedWidth = it } }
  
  new make( Str savedHtml, Int savedWidth := 960 ) {
    this.savedWidth = savedWidth
    this.savedHtml = savedHtml
  }
}
