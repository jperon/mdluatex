# greluatex

Obsolète : ces fonctionnalités sont maintenant intégrées directement dans Gregorio.
Ce dépôt ne reste ici qu'à des fins de tests, en attendant de disparaître.
Saisie directe d'extraits grégoriens dans un document (Lua)LaTeX.


## Installation

### Dépendances

Installez d'abord [gregorio et gregoriotex](https://github.com/gregorio-project/gregorio/), dont dépend cette extension.

### Pour un document isolé

Copiez `greluatex.sty` et `greluatex.lua` dans le dossier contenant le document concerné.

### Pour l'ensemble de votre distribution de LaTeX

Copiez `greluatex.sty` et `greluatex.lua` quelque part dans votre texmf, puis lancez `mktexlsr`.


## Utilisation

Dans le préambule de votre document, incluez le package `greluatex` :

    \usepackage{greluatex}

Dès lors, vous pouvez (ce qui n'est pas recommandé, sauf pour des fragments vraiment courts) saisir directement la musique au sein de votre document, grâce à la commande `compilegabc`. Par exemple :

    \gabcsnippet{(c4) A(f)ve(c) Ma(d)rí(dh'!iv)a.(h.) (::)}

Il ne vous reste plus qu'à compiler le document comme d'habitude, avec `lualatex -shell-escape` :

    lualatex -shell-escape DOCUMENT.TEX

Voyez le document `test.tex` pour un exemple.
