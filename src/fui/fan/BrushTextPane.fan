using fwt

@Js
class BrushTextPane : BrushPane {
  Text text := Text { multiLine = wrap = true }
  
  new make( BrushDialog dialog ) : super( dialog ) {
    content = ConstraintPane {
      minh = 150
      text,
    }
  }
  
  override Void onLayout() {
    super.onLayout
    text.text = dialog.saved
  }
  
  override Str save() { text.text }
}
