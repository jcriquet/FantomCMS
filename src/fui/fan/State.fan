using util

@Js
class State {
  private Str:Obj map := [:]
  const Str key
  
  new make( Str key ) { this.key = key }
  
  Bool has( Str key ) { map.containsKey( key ) }
  @Operator
  Obj? get( Str key ) { map[ key ] }
  @Operator
  Void set( Str key, Obj? val ) {
    if ( map.isRO ) throw ReadonlyErr( "State is readonly" )
    if ( val == null ) map.remove( key )
    else map[ key ] = val;
  }
  Void remove( Str key ) {
    if ( map.isRO ) throw ReadonlyErr( "State is readonly" )
    map.remove( key )
  }
  Void setAll( State that ) { that.map.each |v, k| { map[ k ] = v } }
  Bool isEmpty() { map.isEmpty }
  Int size() { map.size }
  Bool isRO() { map.isRO }
  Bool isRW() { map.isRW }
  This ro() {
    if ( map.isRO ) return this
    copy := State( key )
    copy.map = map.ro
    return copy
  }
  This rw() {
    if ( map.isRW ) return this
    copy := State( key )
    copy.map = map.rw
    return copy
  }
  
  override Str toStr() {
    |Obj?->Str|? valueToStr
    valueToStr = |Obj? value->Str| {
      if ( value == null ) return "null"
      if ( value is Num || value is Bool ) return value.toStr
      if ( value is Str ) return "\"" + ( (Str) value ).replace( "\\", "\\\\" ).replace( "\"", "\\\"" ) + "\""
      if ( value is Str:Obj? ) return "{" + ( (Str:Obj?) value ).join( "," ) |v, k| { "\"$k\":" + valueToStr( v ) } + "}"
      if ( value is Obj?[] ) return "[" + ( (Obj?[]) value ).join( "," ) |v| { valueToStr( v ) } + "]"
      return "null"
    }
    return valueToStr( map )
  }
  
  static State? fromStr( Str key, Str json, Bool checked := true ) {
    try {
      state := State( key )
      state.map = JsonInStream( json.in ).readJson
      return state
    } catch ( Err e ) {
      if ( !checked ) return null
      throw ParseErr( "Invalid State format " + json )
    }
  }
}
