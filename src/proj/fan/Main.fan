using util
using web
using webmod
using wisp

class Main : AbstractMain {
  override Int run() { runServices( [WebService()] ) }
}
