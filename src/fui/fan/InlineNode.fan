using fwt
using gfx

@Js
@Serializable
class InlineNode : Pane {
  native [Str:Str]? styles
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
  override Size prefSize( Hints hints := Hints.defVal ) { sizeOf( hints.w, hints.h ) }
  native Size sizeOf( Int? w, Int? h )
}

@Js
@Serializable
class InlineText : InlineNode {
  const Str text
  new make( |This|? f := null ) { f?.call( this ) }
  static new fromStr( Str str ) { InlineText { text = str } }
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineNL : InlineNode {
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineImage : InlineNode {
  Uri uri { set { &uri = Main.resolve( it ) } }
  new make( |This|? f := null ) {
    f?.call( this )
    uri = (Uri) uri
  }
  static new fromStr( Str str ) { InlineImage { uri = str.toUri } }
  override Bool isLeaf() { true }
  private native Void dummy()
}

@Js
@Serializable
class InlineLink : InlineNode {
  Uri uri
  new make( |This|? f := null ) {
    f?.call( this )
    uri = (Uri) uri
    styles := this.styles
    if ( styles == null ) styles = Str:Str[:]
    if ( styles[ "color" ] == null ) styles[ "color" ] = "#0000FF"
    if ( styles[ "text-decoration" ] == null ) styles[ "text-decoration" ] = "underline"
    if ( styles[ "cursor" ] == null ) styles[ "cursor" ] = "pointer"
    this.styles = styles
    onMouseDown.add |e| { if ( e.button == 1 ) Fui.cur.main.goto( uri ) }
  }
  override Bool isLeaf() { false }
  private native Void dummy()
}
