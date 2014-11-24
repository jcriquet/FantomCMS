using gfx
using webfwt
using fui
using inet
using dom
using fwt

@Js
class FCMSImage
{
  Image image
  Image thumbnail
  Widget toOpenIn
  Size tbSize
  
  new make(Uri uri, Widget w, Size? tbSize := Size(100,100)){
    this.tbSize = tbSize
    this.image = Image(constructUri(uri, "full"))
    this.thumbnail = Image(constructUri(uri, "tb"))
    this.toOpenIn = w
  }
  
  Uri constructUri(Uri uri, Str toAdd){
    uriList := uri.path.dup
    uriList = uriList.insert(uri.path.size-1, toAdd)
    Win.cur.alert(uriList)
    Str newUriPath := ""
    uriList.each |item| {
      newUriPath += item
      if(item == uriList.last){
        return
      }
      newUriPath += "/"
    }
    Win.cur.alert(Fui.cur.baseUri + Uri.fromStr(newUriPath))
    return Fui.cur.baseUri + Uri.fromStr(newUriPath)
  }
  
  Lightbox getLightbox(){
    return Lightbox(this.toOpenIn, this.image)
  }

  Image getThumbnail(){
    return this.thumbnail
  }

  Image getImage(){
    return this.image
  }
}