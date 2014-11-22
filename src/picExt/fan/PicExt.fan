using util
using proj
using web
@ExtMeta {
  name = "pic"
  app = picExt::PicExt#
}
const class PicExt : Ext, Weblet {
  
  override Void onGet() {
    type := req.modRel.path.first
    switch ( type ) {
      default: res.sendErr( 404 ); return
    }
    res.headers[ "Content-Type" ] = "text/plain"
  }
}
