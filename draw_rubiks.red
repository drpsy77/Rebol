Red [
    Title: "Draw Rubiks" 
    Needs: {
        'view
		%rubiks.red
	}
    
]

print "Début"
#include %rubiks.red

print "Import fichier réussi"

origin: 400x160                

xax: -10x6      yax: 10x6      zax: 0x12

size: 4

col: [
    R red
    G green
    B blue
    W white
    O orange
    Y yellow
]

produit: function [a [block!] b [block!]][
    c: copy [0 0 0]
    repeat i length? a [c/:i: (a/:i * b/:i)]
    return c
]


somme: function [a [block!] b [block!]][
    c: copy [0 0 0]
    repeat i length? a [c/:i: (a/:i + b/:i)]
    return c
]

project: function [ coord [series!] ][
    ret: 0x0
    ret/x: size * ((coord/1 * xax/1) + (coord/2 * yax/1) + (coord/3 * zax/1)) + origin/x
    ret/y: size * ((coord/1 * xax/2) + (coord/2 * yax/2) + (coord/3 * zax/2)) + origin/y
    return ret
]

fact: [  [[0 0 0][0 1 0][0 1 1][0 0 1]]
         [[0 0 0][1 0 0][1 0 1][0 0 1]]
         [[0 0 0][1 0 0][1 1 0][0 1 0]]
]   

;;; cube: [ 2 1 3 6 4 5]

buf: [ line-width 3 pen gray]
drawcube: function [][
    repeat i 3 [
        repeat j 3 [
            pos:   compose [3 (i - 1) (j - 1)]
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/2/l/:j/:i )) 
                                        move  ((project (somme (fact/1/1) pos ) ))
                                        line  ((project (somme (fact/1/1) pos ) ))
                                              ((project (somme (fact/1/2) pos ) ))
                                              ((project (somme (fact/1/3) pos ) ))
                                              ((project (somme (fact/1/4) pos ) ))
                                        ]]
                                        
            pos:   compose[(3 - i) 3 (j - 1)]
            
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/1/l/:j/:i )) 
                                        move  ((project (somme (fact/2/1) pos ) )) 
                                        line  ((project (somme (fact/2/1) pos ) )) 
                                              ((project (somme (fact/2/2) pos ) )) 
                                              ((project (somme (fact/2/3) pos ) )) 
                                              ((project (somme (fact/2/4) pos ) )) 
                                        ]]
            
            pos:   compose [(3  - i) (j - 1) 0]
            
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/3/l/:j/:i )) 
                                        move  ((project (somme (fact/3/1) pos ) ))
                                        line  ((project (somme (fact/3/1) pos ) ))
                                              ((project (somme (fact/3/2) pos ) ))
                                              ((project (somme (fact/3/3) pos ) ))
                                              ((project (somme (fact/3/4) pos ) ))
                                        ]]

            pos:   compose [(i - 1) -6 (j - 1)]
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/6/l/:j/:i )) 
                                        move  ((project (somme (fact/2/1) pos ) ))
                                        line  ((project (somme (fact/2/1) pos ) ))
                                              ((project (somme (fact/2/2) pos ) ))
                                              ((project (somme (fact/2/3) pos ) ))
                                              ((project (somme (fact/2/4) pos ) ))
                                        ]]
                                        
            pos:   compose [-6 (3 - i) (j - 1)]            
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/4/l/:j/:i )) 
                                        move  ((project (somme (fact/1/1) pos ) ))
                                        line  ((project (somme (fact/1/1) pos ) ))
                                              ((project (somme (fact/1/2) pos ) ))
                                              ((project (somme (fact/1/3) pos ) ))
                                              ((project (somme (fact/1/4) pos ) ))
                                        ]]
            pos:   compose [(3 - i) (3 - j) 8]
            
            append buf compose/deep [ shape [ 
                                        fill-pen  ( select col ( faces/5/l/:j/:i )) 
                                        move  ((project (somme (fact/3/1) pos ) ))
                                        line  ((project (somme (fact/3/1) pos ) ))
                                              ((project (somme (fact/3/2) pos ) ))
                                              ((project (somme (fact/3/3) pos ) ))
                                              ((project (somme (fact/3/4) pos ) ))
                                        ]]
        ]  
    ]
]

init-cube

drawcube

view [
;    start-btn: button "Draw" [do-down]
;    return
    text 200x600 font[size: 13] {
Utiliser les flèches pour faire tourner le cube

[Espace] pour faire pivoter la face en bas à droite vers la droite

"i" pour réinitialiser le cube 
}
    canvas: base 800x700 white focus
    draw buf
    on-key  [ probe event/key 
            switch event/key [
            right    [z ]
            left     [z z z]
            up       [x  ]
            down     [x x x ]
            #" "     [r]
            #"i"     [init-cube]
        ]
        clear buf
        append buf copy [line-width 3 pen gray] 
        affiche-cube
        drawcube
    ]
]

