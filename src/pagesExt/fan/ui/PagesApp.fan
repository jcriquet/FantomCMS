using dom
using fui
using fwt
using gfx
using util

@Js
class PagesApp : App {
  ScrollPane pageContent := ScrollPane()
  Str? data
  Str? title
  
  new make() : super() {
    content = pageContent
  }
  
  override Str? curTitle() { title }
  
  override Void onSaveState( State state ) {
    state[ "data" ] = data
    state[ "title" ] = title
  }
  
  override Void onLoadState( State state ) {
    data = state[ "data" ] as Str
    if ( data == null ) {
      uri := Win.cur.uri
      uri = uri.pathOnly.relTo( Fui.cur.appUri( name ) ) + ( "?" + ( uri.queryStr ?: "" ) ).toUri
      apiCall( uri, name ).get |res| {
        data = res.content
        if ( res.status != 200 ) data = "fui::HtmlPaneSerial\n{\nsavedHtml=\"" + data.replace( "\\", "\\\\" ).replace( "\"", "\\\"" ) + "\"\nsavedWidth=960\n}"
        else {
          map := JsonInStream( data.in ).readJson as Str:Obj?
          title = map[ "title" ]
          data = map[ "data" ]
        }
        _loadPage
      }
    } else _loadPage
  }
  
  private Void _loadPage() {
    /*
    item := BorderPane {
      it.bg = Gradient( "linear(0% 0%, 100% 100%, #f1c6ff 0.14, #f97766 0.38, #8eb92a 0.49, #72aa00 0.51, #f5ff3a 0.76, #5b38f7 0.90)" )
      it.border = Border( "10 outset #f97766" )
      GridPane {
        halignCells = halignPane = Halign.center
        valignCells = valignPane = Valign.center
        vgap = 70
        Label {
          text = "Welcome to Pages!"
          font = Font.makeFields( "Ariel", 24, true )
        },
        Label {
          text = "We got a lot in store for you so stay tuned!"
          font = Font.makeFields( "Ariel", 20 )
        },
        Label {
          text = "Grooooovy colors maaaaaan"
          font = Font.makeFields( "Ariel", 10 )
        }
      },
    }
    data = Buf().writeObj( item ).flip.readAllStr
    echo( data.replace( "\\", "\\\\" ).replace( "\"", "\\\"" ).replace( "\n", "\\n" ) )
    */
    if ( data == null ) pageContent.content = null
    else {
      in := data.in
      contentRoot := in.readObj as Widget
      in.close
      pageContent.content = contentRoot
    }
    Fui.cur.updateTitle
    pageContent.relayout
  }
}
