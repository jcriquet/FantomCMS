using proj
using util
using web

@ExtMeta {
  name = "dockTest"
  app = dockTestExt::DockTestApp#
  label = "Dock Test"
  icon = "default-50.png"
}
const class DockTestExt : Ext {
}
