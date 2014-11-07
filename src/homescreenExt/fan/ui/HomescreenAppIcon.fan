using fwt
using dom
using inet
using gfx

@Js
class HomescreenAppIcon : fui::AppIcon
{
  new make(Str appName, Uri? iconUri := null) : super(appName, iconUri){
  }
}
