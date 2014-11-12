using fwt
using gfx
using webfwt

@Js
class BrushDialog : OverlayPane {
  ContentPane contentPane := ContentPane() { private set }
  TabPane tabPane := TabPane {
    onSelect.add |e| {
      saved = save
      tab := ( (BrushTab) e.data )
      contentPane.content = tab.content
      tabPane.selectedIndex = tabPane.children.index( tab )
      this.relayout
      e.consume
    }
  }
  Str saved
  
  new make( Str load, |Str|? callback := null ) {
    saved = load
    content = BorderPane {
      bg = Color.white
      GridPane {
        halignCells = Halign.fill
        EdgePane {
          right = Button {
            text = "x"
            onAction.add { close }
          }
          center = Label { text = "Select a Brush" }
        },
        ConstraintPane {
          minh = 30
          minw = 150
          tabPane,
        },
        contentPane,
      },
    }
    onClose.add { callback?.call( save ) }
    
    tabPane.add( BrushTab( BrushTextPane( this ) ) { text = "Aa|" } )
    tabPane.onSelect.fire( Event { it.data = it.widget = tabPane.children[ 0 ] } )
  }
  
  Str save() { ( contentPane.content as BrushPane )?.save ?: saved }
}

@Js
class BrushTab : Tab {
  BrushPane content { private set }
  new make( BrushPane content ) {
    this.content = content
    onMouseDown.add |e| {
      e.data = e.widget
      content.dialog.tabPane.onSelect.fire( e )
    }
  }
}

@Js
abstract class BrushPane : ContentPane {
  BrushDialog dialog
  new make( BrushDialog dialog ) {
    this.dialog = dialog
  }
  abstract Str save()
}