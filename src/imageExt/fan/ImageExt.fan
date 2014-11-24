using util
using [java]com.colegrim.fcms
using gfx
using fwt
using afBson
using db
using proj
using web

@ExtMeta {
  name = "image"
}
const class ImageExt : Ext, Weblet {
  
  override Void onGet() {
    filename := req.modRel.path[1]
    File f := File(`imageStore/`+Uri.fromStr(filename))
    File temp := File.createTemp
    if(!f.exists){
      res.sendErr(404)
    }

    switch (req.modRel.path[0]){
      case "tb":
        FCMSThumbnailMaker.resize(f.uri.toStr, temp.uri.toStr, f.ext, 100, 100)
        FileWeblet(temp).onService
      case "full":
        FileWeblet(f).onService
    }
  }
  
  static Void makeThumb(File i, File o){
    
  }
}
