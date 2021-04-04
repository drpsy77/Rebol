Red [
    Title: "Rubik's Cube" 
    Needs: {
        'view
		%SQLite.red
	}

]
;Le cube est orienté de la manière suivante :
;         3
;      2  1  4  6
;         5

color: [  W R G O B Y  ]

n: 3

face: object [
    l: [ [1 2 3] [4 5 6] [7 8 9] ]
    c: [ [1 2 3] [4 5 6] [7 8 9] ]

    g: []
    transpose: does [
        repeat i n [ self/c/:i: copy self/l/:i ]
        self/make-lines
        self/log
    ]
    make-cols:  does [
        repeat i n  [ repeat j n [ poke (pick self/c i) j (pick (pick self/l j) i) ]] 
        self/log
    ]
    make-lines:  does [
        repeat i n  [ repeat j n [ poke (pick self/l i) j (pick (pick self/c j) i) ]] 
        self/log
    ]
    exchange-lc:  function [ a b ][
        g: copy pick self/c a
        poke self/c a copy pick self/l b
        poke self/l b g 
        self/log
    ]
    exchange-ll: function [ a b ][
        g: copy pick self/l a
        poke self/l a copy pick self/l b
        poke self/l b g
        self/make-cols
        self/log
    ]
    exchange-cc: function [ a b ][
        g: copy pick self/c a
        poke self/c a copy pick self/c b
        poke self/c b g
        self/make-lines
        self/log
    ]
    log: function[] [
;    probe self/l probe self/c ""
    ]
    reverse-l: does [repeat i n [reverse pick self/l i] self/make-cols   self/log]
    reverse-c: does [repeat i n [reverse pick self/c i] self/make-lines  self/log]
    turn-right: function [][
        self/transpose
        self/reverse-l
    ]
    turn-left: function [][
        self/transpose
        self/exchange-ll 1 n
    ]
    
    turn-twice: function[][
        self/reverse-c
        self/reverse-l
    ]
    change-color: function [c][
        repeat i n  [ repeat j n [ self/l/:i/:j: c self/c/:i/:j: c ] ] 
    ]
    self/make-cols
]

faces: make map! [
]

init-cube: function [][
    clear faces
    repeat i 6 [
        put faces i copy/deep face
        faces/:i/change-color color/:i
    ]
]
;Le cube est orienté de la manière suivante :
;         3
;      2  1  4  6
;         5
; r et l pour tourner la première face à droite ou à gauche
; m pour tourner le milieu



r: function [][
    faces/1/turn-right
    reverse faces/2/c/3
    tmp:  copy faces/2/c/3
    faces/2/c/3: faces/5/l/1 faces/2/make-lines
    reverse faces/4/c/1
    faces/5/l/1: faces/4/c/1 faces/5/make-cols
    faces/4/c/1: faces/3/l/3 faces/4/make-lines
    faces/3/l/3: tmp         faces/3/make-cols
]


l: function [][ r r r
;    faces/1/turn-right
;    reverse faces/2/c/3
;    tmp:  copy faces/2/c/3
;    faces/2/c/3: faces/5/l/1 faces/2/make-lines
;    reverse faces/4/c/1
;    faces/5/l/1: faces/4/c/1 faces/5/make-cols
;    faces/4/c/1: faces/3/l/3 faces/4/make-lines
;    faces/3/l/3: tmp         faces/3/make-cols
]

m: function [][ ]

y: function [][
    tmp: copy/deep faces/1
    faces/1: faces/5
    faces/6/turn-twice
    faces/5: faces/6
    faces/3/turn-twice
    faces/6: faces/3
    faces/3: tmp
    faces/2/turn-left
    faces/4/turn-right
]


z: function [][
    tmp: copy/deep faces/1
    faces/1: faces/2
    faces/2: faces/6
    faces/6: faces/4
    faces/4: tmp
    faces/3/turn-left
    faces/5/turn-right
]

x: function [][
    tmp: copy/deep faces/2
    tmp/transpose
    tmp/exchange-ll 1 3
    faces/3/transpose
    faces/3/exchange-ll 1 3
    faces/2: faces/3
    faces/4/transpose
    faces/4/exchange-ll 1 3
    faces/3: faces/4
    faces/5/transpose
    faces/5/exchange-ll 1 3
    faces/4: faces/5
    faces/5: tmp
    faces/1/turn-left
    faces/6/turn-right]

affiche-cube: function [][
    print "" print ""
    repeat i n [ prin "           "  print form faces/3/l/:i] print " "
    repeat i n [ prin "   "        prin form faces/2/l/:i prin "   " prin form faces/1/l/:i prin "   " prin form faces/4/l/:i prin "   " print form faces/6/l/:i ] print " "
    repeat i n [ prin "           "  print form faces/5/l/:i]
]






















