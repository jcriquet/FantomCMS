using fui
using fwt
using gfx
using webfwt

@Js
class UserApp : App {
  
  new make() : super() {
    content = SashPane {
      it.weights = [15, 85]
      BorderPane {
        it.bg = Color.gray
        EdgePane {
          top = GridPane {
            numCols = 1
            Button {
              text = "Manage users"
            },
            Button {
              text = "Manage user groups"
            }
          }
        },
      },
      EdgePane {
        top = EdgePane {
          left = Label {
            text = "MANAGE USERS"
          }
          right = Text {
            text = "Search"
          }
        }
        center = GridPane {
          numCols = 3
          uniformCols = true
          Label {
            text = "Name"
          },
          Label {
            text = "Group"
          },
          Label {
            text = "Registration"
          },
          Label {
            text = "admin"
          },
          Label {
            text = "Administrators"
          },
          Label {
            text = "10/27/14"
          },
          Label {
            text = "TestUser"
          },
          Label {
            text = "Authors"
          },
          Label {
            text = "10/28/14"
          },
          Label {
            text = "TestUser2"
          },
          Label {
            text = "Authors, Editors"
          },
          Label {
            text = "10/28/14"
          }
        }
      }
    }
  }
  
  override Void onSaveState( State state ) {
  }
  
  override Void onLoadState( State state ) {
  }
}
