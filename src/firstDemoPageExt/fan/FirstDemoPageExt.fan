using proj
using util
using web

@ExtMeta {
  name = "firstDemoPageExt"
  app = firstDemoPageExt::FirstDemoPageApp#
}
const class FirstDemoPageExt : Ext, Weblet {
}
