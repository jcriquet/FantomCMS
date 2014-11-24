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
  
  new make(Uri uri, Widget w){
    this.image = Image(uri)
    this.thumbnail = Image("$uri?tb".toUri)
    this.toOpenIn = w
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