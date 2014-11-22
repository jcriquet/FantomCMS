// Author:Joshua Leihe

using proj
using util
using web

@ExtMeta {
  name = "firstDemoPage"
  label = "First Demo Page"
  app = firstDemoPageExt::FirstDemoPageApp#
  icon = "settings-50.png"
}

const class FirstDemoPageExt : Ext, Weblet {
  
}
