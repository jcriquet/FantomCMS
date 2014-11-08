using dom
using fui
using fwt
using gfx

@Js
class PagesApp : App {
  ScrollPane pageContent := ScrollPane()
  Str? data
  
  new make() : super() {
    content = pageContent
  }
  
  override Void onSaveState( State state ) {
    state[ "data" ] = data
  }
  
  override Void onLoadState( State state ) {
    data = state[ "data" ] as Str
    if ( data == null ) {
      uri := Win.cur.uri
      uri = uri.pathOnly.relTo( Fui.cur.appUri( name ) ) + ( "?" + ( uri.queryStr ?: "" ) ).toUri
      apiCall( uri, name ).get |res| {
        data = res.content
        if ( res.status != 200 ) data = "fui::HtmlPaneSerial\n{\nsavedHtml=\"" + data.replace( "\\", "\\\\" ).replace( "\"", "\\\"" ) + "\"\nsavedWidth=960\n}"
        _loadPage
      }
    } else _loadPage
  }
  
  private Void _loadPage() {
    if ( data == null ) pageContent.content = null
    else {
      in := data.in
      contentRoot := in.readObj as Widget
      in.close
      pageContent.content = contentRoot
    }
    pageContent.relayout
  }
}
