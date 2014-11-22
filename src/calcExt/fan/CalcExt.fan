using proj
using util
using web

@ExtMeta {
  name = "calcExt"
  app = calcExt::CalcApp#
}
const class CalcExt : Ext, Weblet {
}
