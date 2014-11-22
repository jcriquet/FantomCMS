using fui
using fwt
using gfx
using util
using webfwt

@Js
class FirstDemoPageApp : App {
  new make() : super() {
    content = BorderPane {
      it.bg = Color.black
      EdgePane {
        left = InsetPane.make(10) {
          GridPane {
            numCols = 1
            Button { text="Home" },
            
            Button { text="About";  },
            
            Button { text="Contact Us" },
          },
        }
        center = EdgePane {
          it.center = InsetPane.make(10) { 
            BorderPane {
              it.bg = Color.gray
              ScrollPane {
                //it.vbar = false { private set }
                GridPane {
                  numCols = 1
                  Label { text = "Le chien (Canis lupus familiaris) est la sous-espèce domestique de Canis lupus,"},
                  Label { text = "un mammifère de la famille des Canidés (Canidae) qui comprend également le loup gris,"},
                  Label { text = "ancêtre sauvage du chien, et le dingo, chien domestique redevenu sauvage.Le chien est"},
                  Label { text = "la première espèce animale à avoir été domestiquée par l'Homme pour l'usage de la chasse"},
                  Label { text = "dans une société humaine paléolithique qui ne maîtrise alors ni l'agriculture ni l'élevage. "},
                  Label { text = "La lignée du chien se différencie génétiquement de celle du loup gris il y a environ "},
                  Label { text = "100 000 ans1, et les plus anciens restes confirmés de chien domestique sont vieux de 33 "},
                  Label { text = "000 ans2,3 soit plusieurs dizaines de milliers d'années avant toute autre espèce domestique "},
                  Label { text = "connue. Depuis la Préhistoire, le chien a accompagné l'homme durant toute sa phase de "},
                  Label { text = "sédentarisation qui a conduit à l'apparition des premières civilisations agricoles. "},
                  Label { text = "C'est à ce moment qu'il a acquis la capacité de digérer l'amidon4 et que ses fonctions"},
                  Label { text = "d'auxiliaire de l'homme se sont étendues. Ces nouvelles fonctions ont conduit à une "},
                  Label { text = "différenciation poussée de la sous-espèce et à l'apparition progressive d'une "},
                  Label { text = "standardisation sous forme de races canines. Le chien est aujourd'hui utilisé à "},
                  Label { text = "la fois comme animal de travail et comme animal de compagnie. Son instinct de meute, sa "},
                  Label { text = "domestication précoce et les caractéristiques comportementales qui en découlent lui "},
                  Label { text = "valent familièrement le surnom de « meilleur ami de l'Homme ». Cette place particulière "},
                  Label { text = "dans la société humaine a conduit à l'élaboration d'une règlementation spécifique. Ainsi, "},
                  Label { text = "là où les critères de la Fédération cynologique internationale ont une reconnaissance légale,"},
                  Label { text = "l'appellation chien de race est conditionnée à l'enregistrement du chien dans les livres des "},
                  Label { text = "origines de son pays de naissance5,6. Selon le pays, des vaccins peuvent être obligatoires et "},
                  Label { text = "certains types de chien, jugés dangereux, sont soumis à des restrictions. Le chien est "},
                  Label { text = "généralement soumis aux différentes législations sur les carnivores domestiques. C'est "},
                  Label { text = "le cas en Europe où sa circulation est facilitée grâce à l'instauration du passeport "},
                },
              },
            },
          }
        }
     },
  }
    relayout
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