using fui
using fwt
using gfx
using util
using webfwt

@Js
class CalcApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.black
      BorderPane calc := BorderPane {
        EdgePane {
          right = Button {
            it.text = "Click me to add an item"
            //it.onAction.add { Fui.cur.main.addFooterItem(CalcDockItem())}
          }
          
          center = HtmlPane {
            html = "<FORM NAME=\"Calc\">
                    <TABLE BORDER=2>
                    <TR>
                    <TD>
                    <INPUT TYPE=\"text\"   NAME=\"Input\" Size=\"16\">
                    <br>
                    </TD>
                    </TR>
                    <TR>
                    <TD>
                    <INPUT TYPE=\"button\" NAME=\"one\"   VALUE=\"  1  \" OnClick=\"Calc.Input.value += '1'\">
                    <INPUT TYPE=\"button\" NAME=\"two\"   VALUE=\"  2  \" OnCLick=\"Calc.Input.value += '2'\">
                    <INPUT TYPE=\"button\" NAME=\"three\" VALUE=\"  3  \" OnClick=\"Calc.Input.value += '3'\">
                    <INPUT TYPE=\"button\" NAME=\"plus\"  VALUE=\"  +  \" OnClick=\"Calc.Input.value += ' + '\">
                    <br>
                    <INPUT TYPE=\"button\" NAME=\"four\"  VALUE=\"  4  \" OnClick=\"Calc.Input.value += '4'\">
                    <INPUT TYPE=\"button\" NAME=\"five\"  VALUE=\"  5  \" OnCLick=\"Calc.Input.value += '5'\">
                    <INPUT TYPE=\"button\" NAME=\"six\"   VALUE=\"  6  \" OnClick=\"Calc.Input.value += '6'\">
                    <INPUT TYPE=\"button\" NAME=\"minus\" VALUE=\"  -  \" OnClick=\"Calc.Input.value += ' - '\">
                    <br>
                    <INPUT TYPE=\"button\" NAME=\"seven\" VALUE=\"  7  \" OnClick=\"Calc.Input.value += '7'\">
                    <INPUT TYPE=\"button\" NAME=\"eight\" VALUE=\"  8  \" OnCLick=\"Calc.Input.value += '8'\">
                    <INPUT TYPE=\"button\" NAME=\"nine\"  VALUE=\"  9  \" OnClick=\"Calc.Input.value += '9'\">
                    <INPUT TYPE=\"button\" NAME=\"times\" VALUE=\"  x  \" OnClick=\"Calc.Input.value += ' * '\">
                    <br>
                    <INPUT TYPE=\"button\" NAME=\"clear\" VALUE=\"  c  \" OnClick=\"Calc.Input.value = ''\">
                    <INPUT TYPE=\"button\" NAME=\"zero\"  VALUE=\"  0  \" OnClick=\"Calc.Input.value += '0'\">
                    <INPUT TYPE=\"button\" NAME=\"DoIt\"  VALUE=\"  =  \" OnClick=\"Calc.Input.value = eval(Calc.Input.value)\">
                    <INPUT TYPE=\"button\" NAME=\"div\"   VALUE=\"  /  \" OnClick=\"Calc.Input.value += ' / '\">
                    <br>
                    </TD>
                    </TR>
                    </TABLE>
                    </FORM>
                    
                    <p align=\"center\"><font face=\"arial\" size=\"-2\">This free script provided by</font><br>
                    <font face=\"arial, helvetica\" size=\"-2\"><a href=\"http://javascriptkit.com\">JavaScript
                    Kit</a></font></p>"
          }
          },
        }
      BorderPane clock := BorderPane {
        HtmlPane {
        html = "<div class='clock'>
                  <div class='square'> <!-- so the SVG keeps its aspect ratio -->
                    <svg viewBox='0 0 100 100'>
                
                      <!-- first create a group and move it to 50,50 so
                           all co-ords are relative to the center -->
                      <g transform='translate(50,50)'>
                        <circle class='clock-face' r='48'/>
                
                        <!-- markers every minute (major markers every 5 minutes) -->
                        {{#minor:i}}
                          <line class='minor' y1='42' y2='45' transform='rotate( {{
                            360 * i / minor.length
                          }} )'/>
                        {{/minor}}
                
                        {{#major:i}}
                          <line class='major' y1='35' y2='45' transform='rotate( {{
                            360 * i / major.length
                          }} )'/>
                        {{/major}}
                
                        <!-- hour hand -->
                        <line class='hour' y1='2' y2='-20' transform='rotate( {{
                          30 * date.getHours() +
                          date.getMinutes() / 2
                        }} )'/>
                
                        <!-- minute hand -->
                        <line class='minute' y1='4' y2='-30' transform='rotate( {{
                          6 * date.getMinutes() +
                          date.getSeconds() / 10
                        }} )'/>
                
                        <!-- second hand -->
                        <g transform='rotate( {{
                          6 * date.getSeconds()
                        }} )'>
                          <line class='second' y1='10' y2='-38'/>
                          <line class='second-counterweight' y1='10' y2='2'/>
                        </g>
                
                      </g>
                
                    </svg>
                  </div>
                </div>
                
                <div class='left'>
                  <p>
                    Today is {{ days[ date.getDay() ] }}
                    the {{ addSuffix( date.getDate() ) }}
                    of {{ months[ date.getMonth() ] }}.
                
                    The time is:
                  </p>
                
                  <span class='time'>
                    <!-- we use pad() to ensure all numbers have two digits -->
                    <span class='hours'>
                      {{ pad( date.getHours() ) }}
                    </span>:<span class='minutes'>
                      {{ pad( date.getMinutes() ) }}
                    </span>:<span class='seconds'>
                      {{ pad( date.getSeconds() ) }}
                    </span>
                  </span>
                </div>"
        },
      }
      BorderPane timer := BorderPane {
        HtmlPane {
            html = ""
        },
      }
      
      EdgePane {
        it.center = InsetPane.make(2) { 
          ConstraintPane {
            it.maxh = 200
            it.maxw = 200
            it.content = TabPane {
              Tab { text = "Calculator"; calc, },
              Tab { text = "Timer"; timer, },
              Tab { text = "Clock"; clock, },
            }
          },
        }
      },
     }
  }
  
  
  
  override Void onSaveState( State state ) {
  }
  
  Void main() {
    buf := Buf()
    out := buf.out
    out.writeObj(this.content)
    out.close
    buf.flip
    echo( buf.readAllStr.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n"))
  }
  
  override Void onLoadState( State state ) {
  }
}