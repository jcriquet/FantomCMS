using afBson
using db
using proj
using util
using web

@ExtMeta {
  name = "pages"
  app = pagesExt::PagesApp#
}
const class PagesExt : Ext, Weblet {
  override Void onGet() {
    uri := req.modRel
    _id := uri.query[ "_id" ]
    path := uri.pathOnly.pathStr
    Obj? document
    Str? data
    if ( _id != null ) document = DBConnector.cur.db[ "pages" ].find( ["_id":ObjectId( _id )] ) |cursor| { cursor.hasNext ? cursor.next : null }
    else {
      if ( uri.pathOnly == `` ) path = "index"
      if ( path != "" ) document = DBConnector.cur.db[ "pages" ].find( ["uri":path] ) |cursor| { cursor.hasNext ? cursor.next : null }
    }
    if ( document == null || ( data = ( document as Str:Obj? )?.get( "data" ) ) == null ) {
      res.sendErr( 404 )
      return
    }
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = data.size.toStr
    res.out.writeChars( data ).close
    res.done
    //DBConnector.cur.db[ "pages" ].insert( [
    /*
    db := DBConnector.cur.db[ "pages" ].insert( [
      "title":"A Sample Page",
      "uri":"sample",
      "data":"fwt::GridPane
              {
              numCols=1
              hgap=4
              vgap=4
              halignCells=gfx::Halign(\"left\")
              valignCells=gfx::Valign(\"center\")
              halignPane=gfx::Halign(\"center\")
              valignPane=gfx::Valign(\"center\")
              expandRow=null
              expandCol=null
              uniformCols=false
              uniformRows=false
              fwt::Text
              {
              password=false
              text=\"Hello, I'm Pages!\"
              fg=null
              bg=null
              },
              }"] )
    res.sendErr( 500 );
    */
  }
}
