using proj
using util
using web

@ExtMeta {
  name = "pages"
  app = pagesExt::PagesApp#
}
const class PagesExt : Ext, Weblet {
  override Void onGet() {
    db := DBConnector.cur
    db.put( DBEntry.makeFromMap( ["app":"pages", "test":123, "asff":"foo"] ) )
    res.sendErr( 500 );
  }
}
