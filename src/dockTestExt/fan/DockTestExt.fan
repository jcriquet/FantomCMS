using proj
using util
using web

@ExtMeta {
  name = "dockTest"
  app = dockTestExt::DockTestApp#
  label = "Dock Test"
}
const class DockTestExt : Ext {
}
