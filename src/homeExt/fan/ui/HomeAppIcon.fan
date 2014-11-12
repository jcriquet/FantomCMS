using fwt
using fui
using dom
using inet
using gfx

@Js
class HomeAppIcon : AppIcon {
  new make(Str appName, Uri? iconUri := null) : super(appName, iconUri){
  }
}
