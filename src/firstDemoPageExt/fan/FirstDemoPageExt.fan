// Author:Joshua Leihe

using proj
using util
using web

@ExtMeta {
  name = "firstDemoPage"
  label = "First Demo Page"
  app = firstDemoPageExt::FirstDemoPageApp#
}
const class FirstDemoPageExt : Ext, Weblet {
  
}
