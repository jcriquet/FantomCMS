using fui
using fwt
using gfx
using util
using webfwt

@Js
class TestApp : App {
  private TreeList list := TreeList { it.items = [ TableMeterConfig( this ), TableInstallConfig( this ) ] }
  private GridPane optionGrid := GridPane()
  private WebCombo optionCombo := WebCombo()
  private TableConfigModel tableModel := TableConfigModel()
  Table table := Table { it.model = tableModel } { private set }
  internal [Str:Obj]? options
  Bool showErrors := false
  
  new make() : super() {
    list.onSelect.add |e| {
      tableModel.config = e.data
      options = null
      modifyState
    }
    table.onPopup.add |e| { echo( e ); tableModel.onPopup( e ) }
    
    content = SashPane {
      it.weights = [ 30, 70 ]
      SashPane {
        it.orientation = Orientation.vertical
        it.weights = [ 50, 50 ]
        list,
        EdgePane {
          it.top = BorderPane {
            it.bg = Color.gray
            GridPane {
              it.numCols = 3
              it.expandCol = 1
              optionCombo,
              MiniButton {
                it.text = "Add"
                it.onAction.add {
                  if ( ( optionCombo.selected ?: "" ) != "" ) {
                    addPane( optionCombo.selected, tableModel.config.items[ optionCombo.selected ] )
                    optionGrid.relayout
                    optionCombo.items = optionCombo.items.exclude |obj| { obj == optionCombo.selected }
                    optionCombo.selected = null
                    optionCombo.relayout
                    optionCombo.parent.relayout
                  }
                }
              },
              MiniButton {
                it.text = "Apply"
                it.onAction.add {
                  options = Str:Obj[:] { it.ordered = true }
                  optionGrid.each |widget| { options[ ( (OptionPane) widget ).label ] = ( (OptionPane) widget ).getValue }
                  modifyState
                }
              }
            },
          }
          it.center = ScrollPane { optionGrid, }
        },
      },
      EdgePane {
        top = BorderPane {
          it.bg = Color.gray
          GridPane {
            it.numCols = 2
            Button {
              it.text = "Hello"
            },
            Button {
              it.text = "Hello"
            },
          },
        }
        center = table
      },
    }
    relayout
  }
  
  Void addPane( Str label, Obj data, Int? selected := null ) {
    pane := OptionPane( label, data, selected )
    ( (Button) pane.right ).onAction.add {
      optionGrid.remove( pane )
      optionGrid.relayout
      optionCombo.items = optionCombo.items.add( pane.label )
      optionCombo.relayout
      optionCombo.parent.relayout
    }
    optionGrid.add( pane )
  }
  
  Void loadData( TableConfig config, [Str:Obj]? options := null ) {
    tableModel.config = config
    this.options = options
    apiCall( config.api + ( options != null ? ( "?" + options.join( "&" ) |v, k| { "$k=$v" } ).toUri : `` ) ).get |res| {
      data := ([Str:Obj]?) JsonInStream( res.content.in ).readJson
      if ( data == null ) {
        tableModel.headers = [,]
        tableModel.data = [,]
      } else {
        tableModel.headers = data[ "headers" ]
        tableModel.data = data[ "data" ]
      }
      table.refreshAll
    }
  }
  
  override Void onSaveState( State state ) {
    state[ "tableChoice" ] = list.items.index( tableModel.config )
    state[ "options" ] = options
  }
  
  override Void onLoadState( State state ) {
    if ( state[ "tableChoice" ] != null ) {
      tableModel.headers = [,]
      tableModel.data = [,]
      loadData( list.items[ list.selectedIndex = state[ "tableChoice" ] ], state[ "options" ] )
    } else {
      tableModel.config = null
      options = null
      tableModel.headers = [,]
      tableModel.data = [,]
    }
    optionGrid.removeAll
    if ( tableModel.config == null ) optionCombo.items = [ "" ]
    else {
      items := tableModel.config.items.keys
      if ( options != null && options.size > 0 ) {
        items.removeAll( options.keys )
        options.each |value, label| {
          data := tableModel.config.items[ label ]
          if ( data is Str[] ) addPane( label, data, ( (Str[]) data ).index( value ) )
          else addPane( label, value )
        }
      }
      optionCombo.items = items.sort
    }
    optionCombo.selected = null
    optionCombo.relayout
    optionCombo.parent.relayout
    optionGrid.relayout
    table.refreshAll
  }
}
