using fui
using fwt
using gfx
using webfwt

@Js
@Serializable { simple = true }
abstract class AudioAbstractPlayer : ThemedBorderPane {
  const Str name
  AudioElem elem { private set }
  StyledButton playPauseButton := StyledButton {
    it.border = Border( "1 solid #9A9A9A 15" )
    onAction.add {
      if ( elem.paused ) playAction
      else pauseAction
    }
    Label { text = ">"; it.halign = Halign.center },
  }
  
  new make( |This| f ) : super() {
    f( this )
    elem = AudioObject.cur.getOrAdd( name )
    elem.register( this )
    content = FlowPane {
      playPauseButton,
    }
    if ( elem.paused ) onPause
    else onPlay
  }
  
  virtual Bool isExpired() {
    result := window == null
    if ( result ) {
      echo( "Removing from register" )
      content = ConstraintPane {
        minw = maxw = this.content.size.w
        minh = maxh = this.content.size.h
        Label {
          it.bg = Color.black
          it.fg = Color.yellow
          text = "Disabled Audio Player"
        },
      }
      relayout
    }
    return result
  }
  virtual Void playAction() { elem.play }
  virtual Void pauseAction() { elem.pause }
  
  virtual Void onPlay() {
    playPauseButton.children[ 0 ]->text = "||"
    playPauseButton.relayout
  }
  virtual Void onPause() {
    playPauseButton.children[ 0 ]->text = ">"
    playPauseButton.relayout
  }
}
