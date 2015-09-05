# mdluatex

Saisie directe d'extraits markdown dans un document (Lua)LaTeX.


## Installation

### Dépendances

Installez d'abord [gregorio et gregoriotex](https://github.com/gregorio-project/gregorio/), dont dépend cette extension.

### Pour un document isolé

Copiez `mdluatex.sty` et `mdluatex.lua` dans le dossier contenant le document concerné.

### Pour l'ensemble de votre distribution de LaTeX

Copiez `mdluatex.sty` et `mdluatex.lua` quelque part dans votre texmf, puis lancez `mktexlsr`.


## Utilisation

Dans le préambule de votre document, incluez le package `greluatex` :

    \usepackage{mdluatex}

Dès lors, vous pouvez inclure du markdown directement dans votre document :

    \begin{markdown}
    #Titre

    ## Sous-titre

    Texte de votre paragraphe.
    \end{markdown}

Il ne vous reste plus qu'à compiler le document comme d'habitude, avec `lualatex -shell-escape` :

    lualatex -shell-escape DOCUMENT.TEX

Voyez le document `test.tex` pour un exemple.
