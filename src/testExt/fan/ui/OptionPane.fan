using fwt
using gfx
using webfwt

@Js
class OptionPane : EdgePane {
  Str label
  Obj data
  
  new make( Str label, Obj data, Int? selected := null ) : super() {
    this.label = label
    this.data = data
    left = InsetPane( 5 ) { Label { it.text = label + ": " }, }
    switch ( data.typeof ) {
      case Str#: center = WebText { it.text = data }
      case Str[]#: center = WebCombo { it.items = data; if ( selected != null ) it.selectedIndex = selected }
      case Bool#: center = Button { it.mode = ButtonMode.check; it.selected = data }
    }
    right = Button { text = "X" }
  }
  
  Obj getValue() {
    switch ( data.typeof ) {
      case Str#: return ( (WebText) center ).text
      case Str[]#: return ( (WebCombo) center ).selected ?: ""
      case Bool#: return ( (Button) center ).selected
      default: return ""
    }
  }
  
  override Size prefSize( Hints hints := Hints.defVal ) { Size( parent.size.w - 20, super.prefSize( hints ).h ) }
}
