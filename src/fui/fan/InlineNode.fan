using fwt
using gfx

@Js
@Serializable
class InlineNode : Pane {
  const Str? fgStyle
  const Str? fontStyle
  native Color? fg
  native Font? font
  native Str:Str styles
  new make( |This|? f := null ) { f?.call( this ); checkStyles }
  virtual Bool isLeaf() { false }
  @Operator
  override This add( Widget? child ) {
    if ( !isLeaf && child is InlineNode ) super.add( child )
    return this
  }
  override This insert( Int index, Widget child ) {
    if ( !isLeaf && child is InlineNode ) super.insert( index, child )
    return this
  }
  override Void onLayout() { children.each |child| { ( child as Pane )?.onLayout } }
  override Size prefSize( Hints hints := Hints.defVal ) { sizeOf( hints ) }
  native Size sizeOf( Hints hints )
  Void checkStyles() {
    if ( fgStyle != null ) fg = FuiThemes.getFg( fgStyle )
    if ( fontStyle != null ) font = FuiThemes.getFont( fgStyle )
  }
}

@Js
@Serializable
class InlineText : InlineNode {
  const Str text
  new make( |This|? f := null ) : super( f ) {}
  static new fromStr( Str str ) { InlineText { text = str } }
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineNL : InlineNode {
  new make( |This|? f := null ) : super( f ) {}
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineImage : InlineNode {
  Uri uri { set { &uri = Main.resolve( it ) } }
  new make( |This|? f := null ) : super( f ) { uri = (Uri) uri }
  static new fromStr( Str str ) { InlineImage { uri = str.toUri } }
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineLink : InlineNode {
  Uri uri
  new make( |This|? f := null ) : super( f ) {
    uri = (Uri) uri
    styles := this.styles
    if ( fgStyle == null && fg == null ) fg = Color( "#0000FF" )
    if ( styles[ "text-decoration" ] == null ) styles[ "text-decoration" ] = "underline"
    if ( styles[ "cursor" ] == null ) styles[ "cursor" ] = "pointer"
    this.styles = styles
    onMouseDown.add |e| { if ( e.button == 1 ) Fui.cur.main.goto( uri ) }
  }
  override Bool isLeaf() { false }
  private native Void dummy()
}
