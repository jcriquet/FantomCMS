using fwt
using gfx

@Js
class TableConfig {
  TestApp app
  const Str name
  const Uri api
  
  new make( TestApp app, Str name, Uri api ) {
    this.app = app
    this.name = name
    this.api = api
  }
  
  virtual once Str:Obj items() { [:] }
  
  virtual Halign halign( Str header ) { Halign.left }
  virtual Str text( Str header, Obj? cell ) { cell?.toStr ?: "" }
  virtual Image? image( Str header, Obj? cell ) { null }
  virtual Font? font( Str header, Obj? cell ) { null }
  virtual Color? fg( Str header, Obj? cell ) { null }
  virtual Color? bg( Str header, Obj? cell ) { null }
  virtual Int sortCompare( Str header, Obj? row1, Obj? row2 ) { text( header, row1 ).compare( text( header, row2 ) ) }
  virtual Void onPopup( Event e, Str:Obj? row ) {}
  
  override Str toStr() { name }
}

@Js
class TableConfigModel : TableModel {
  TableConfig? config
  Str[] headers := [,]
  Obj?[][] data := [,]
  
  override Int numCols() { headers.size }
  override Int numRows() { data.size }
  override Str header( Int col ) { headers[ col ] }
  override Halign halign( Int col ) { config?.halign( header( col ) ) ?: Halign.left }
  override Str text( Int col, Int row ) { config?.text( header( col ), data[ row ][ col ] ) ?: "" }
  override Image? image( Int col, Int row ) { config?.image( header( col ), data[ row ][ col ] ) ?: null }
  override Font? font( Int col, Int row ) { config?.font( header( col ), data[ row ][ col ] ) ?: null }
  override Color? fg( Int col, Int row ) { config?.fg( header( col ), data[ row ][ col ] ) ?: null }
  override Color? bg( Int col, Int row ) { config?.bg( header( col ), data[ row ][ col ] ) ?: null }
  override Int sortCompare( Int col, Int row1, Int row2 ) { config?.sortCompare( header( col ), data[ row1 ][ col ], data[ row2 ][ col ] ) ?: 0 }
  Void onPopup( Event e ) { if ( e.index != null ) config?.onPopup( e, Str:Obj?[:].addList( data[ e.index ] ) |obj, col| { headers[ col ] } ) }
}