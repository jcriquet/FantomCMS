using proj
using util
using web

@ExtMeta {
  name = "main"
  app = mainExt::MainApp#
}
const class MainExt : Ext, Weblet {
  
  override Void onGet() {
    type := req.modRel.path.first
    switch ( type ) {
      default: res.sendErr( 404 ); return
    }
    res.headers[ "Content-Type" ] = "text/plain"
  }
}
