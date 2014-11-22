using util
using proj
using web
@ExtMeta {
  name = "image"
}
const class ImageExt : Ext, Weblet {
  
  override Void onGet() {
    type := req.modRel.path.first
    switch ( type ) {
      default: res.sendErr( 404 ); return
    }
    res.headers[ "Content-Type" ] = "text/plain"
  }
}
