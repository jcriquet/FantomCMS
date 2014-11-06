using proj
using util
using web

@ExtMeta {
  name = "test"
  app = testExt::TestApp#
}
const class TestExt : Ext {
}
