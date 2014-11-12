using proj
using util
using web

@ExtMeta {
  name = "test"
  app = testExt::TestApp#
  icon = "default-50.png"
}
const class TestExt : Ext {
}
