using fwt
using gfx

@Js
class GridTablePane : GridPane {
  Void populate( Obj? items, |Obj? cell, Obj? col, Obj? row->Widget| createFunc ) {
    removeAll
    if ( items == null ) {
      numCols = 1
      add( createFunc( null, 0, 0 ) )
    } else if ( items is Obj?[] || items is Str:Obj? ) {
      items = items->dup
      hasRowLabels := items is Str:Obj?
      hasColLabels := (Bool) items->all |Obj? row->Bool| { row is Str:Obj? }
      if ( hasColLabels ) {
        colLabels := Str[,]
        items->each |Str:Obj? row| { colLabels = colLabels.union( row.keys ) }
        if ( hasRowLabels ) {
          numCols = 1 + colLabels.size
          add( createFunc( null, null, null ) )
        } else numCols = colLabels.size
        colLabels.each |colLabel| { add( createFunc( null, colLabel, null ) ) }
        items->each |Str:Obj? row, Obj rowLabel| {
          if ( hasRowLabels ) add( createFunc( null, null, rowLabel ) )
          colLabels.each |colLabel| { add( createFunc( row[ colLabel ], colLabel, rowLabel ) ) }
        }
      } else {
        colCount := 0
        items->each |Obj? row| { colCount = colCount.max( row is Obj?[] || row is Str:Obj? ? row->size : 1 ) }
        items->each |Obj? row, Obj rowLabel| {
          if ( hasRowLabels ) add( createFunc( null, null, rowLabel ) )
          missing := colCount - (Int) ( row is Obj?[] || row is Str:Obj? ? row->size : 1 )
          if ( row is Obj?[] )
            row->each |Obj? cell, Int colLabel| { add( createFunc( cell, colLabel, rowLabel ) ) }
          else if ( row is Str:Obj? )
            row->vals->each |Obj? cell, Int colLabel| { add( createFunc( cell, colLabel, rowLabel ) ) }
          else
            add( createFunc( row, 0, rowLabel ) )
          missing.times |i| { add( createFunc( null, colCount - missing + i, rowLabel ) ) }
        }
        numCols = hasRowLabels ? colCount + 1 : colCount
      }
    } else {
      add( createFunc( items, 0, 0 ) )
      numCols = 1
    }
    relayout
  }
}