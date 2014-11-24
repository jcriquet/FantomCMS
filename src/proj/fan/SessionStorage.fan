using util
using concurrent

class SessionStorage {
  Str:Session sessionMap := [:]
  
  Int getSession(Str username) {
    Int retSessionID
    if(sessionMap[username] == null) {
      sessionMap.add(username, Session(username))
    }
    retSessionID = sessionMap[username].sessionID
    return retSessionID
  }
  
  static SessionStorage cur() { return Actor.locals["sessionstorage.cur"] }
}

class Session {
  Str username
  Int sessionID
  
  new make(Str inputUsername) {
    username = inputUsername
    sessionID = generateID()
  }
  
  Int generateID() {
    return Int.random(0..1337)
  }
}