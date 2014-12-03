using util
using concurrent

class SessionStorage {
  Str:Session sessionMap := [:]
  
  new make() {
    File? f
    try{
      f = `cached/proj/session.props`.toFile
      props := f.readProps
      sessionMap = props.map |v, k->Session| { Session.fromStr( v ) }
    }catch(Err e){
      if(f.exists) f.delete
      f.create
    }
  }
  
  @Operator
  Int get(Str username) {
    Bool mod := false
    toRet := sessionMap.getOrAdd( username ) |->Session| { 
      mod = true
      return Session()
    }.sessionID
    if ( mod ) updateFile
    return toRet
  }
  
  Void remove(Str username) { if ( sessionMap.remove(username) != null ) updateFile }
  
  private Void updateFile() { `cached/proj/session.props`.toFile.writeProps( sessionMap.map |session->Str| { session.toStr } ) }
  
  static SessionStorage cur() {
    ret := Actor.locals["sessionstorage.cur"] as SessionStorage
    if ( ret == null ) Actor.locals["sessionstorage.cur"] = ret = SessionStorage()
    return ret
  }
  
}

class Session {
  Int sessionID
  
  new make(Int sessionID := generateID) {
    this.sessionID = sessionID
  }
  
  static new fromStr(Str s){
    return Session(s.toInt)
  }
  
  Int generateID() {
    return Int.random(0..5000)
  }
  
  override Str toStr(){
    sessionID.toStr
  }
}