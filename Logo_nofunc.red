Red [
    Title: "Logo_Interpreter" 
    needs: 'view
]


stack:
    copy []

push: function [arg][
    insert stack arg
]

pop: function [][
    s: first stack
    remove stack
    return s
]

stack?: function [][return first stack]

; BUG : à la fin de l'exécution, la tortue ecrase la couleur du trait par Black
; BUG : idem pour le baisse

turtle: make object! [
    precision: 1
    pos: 250x250
    ang: 0.0
    color: black
    active: true
    show: true
    aspect: [ couleur red baisse td 90 av 5 tg 110 av 15 tg 140 av 15 tg 110 av 5 tg 90 couleur turtle/color ]
]

background: white

arity-of: function [f [function!]][
    c: 0
    foreach i spec-of :f [either (word? i) [c: c + 1][ if (('local = i) or ('return = i)) [break]]]
    return c
]



langage: make map![
    td: [function [arg1][turtle/ang: (turtle/ang - arg1) % 360 return ""]]
    tg: [function [arg1][turtle/ang: (turtle/ang + arg1) % 360 return ""]]
    av: [function [arg0][
                        arg1: arg0 * turtle/precision
                        p: 0x0
                        p/x: to-integer round (turtle/pos/x + (arg1 * (sin (pi * turtle/ang / 180))))
                        p/y: to-integer round (turtle/pos/y + (arg1 * (cos (pi * turtle/ang / 180))))
                        either (turtle/active) [s: form reduce [" line " (turtle/pos / turtle/precision) (p / turtle/precision)]][s: copy ""]
                        turtle/pos: p
                        return s
    ]]
    repete: [function [arg0 arg1][
        s: copy ""
        loop arg0 [ append s logo arg1 ]
        return s
    ]]
    baisse: [function [][
        turtle/active: true
        return ""
    ]]
    leve: [function [][
        turtle/active: false
        return ""
    ]]
    couleur: [function [arg0][
        turtle/color: arg0
        return form reduce [" pen " turtle/color]
    ]] 
    montre:  [function [][
        turtle/show: true
        return ""
    ]]
    cache: [function [][
        turtle/show: false
        return ""
    ]]
    precision: [function [arg1][
        fac: arg1 / turtle/precision 
        turtle/precision: arg1
        turtle/pos: turtle/pos * fac
        return ""
    ]]
    pour: [function [arg1][
        either select langage  quote arg1 [put langage arg1 []][extend langage make map! [arg1 []]]
        push arg1
        return ""
    ]]
]


logo: function [ code [series!] return: [string!]
    ][
    ret: copy ""
    until [
        instr: first code
        print instr        
        f: do select langage instr
        g: copy [ f ]
        
        loop arity-of :f [ code: next code append/only g first code ]

        append ret do g
        code: next code
        tail? code
    ]
    return ret
]

buf: copy []

view [
    title "Canvas"
    size 800x650
    across
    a: area 200x480 wrap "repete 20 [av 100 td 100] ^/"
    b: base 570x480 background []
    return
    
    panel  [ origin 0x0
        text 45x24 " Instant:"
        imm: field 145x24 on-enter [append buf to-block logo to-block imm/text 
                                    clear b/draw b/draw: copy buf  
                                    if turtle/show [append b/draw to-block logo to-block turtle/aspect] 
                                    append a/text imm/text append a/text "^/"
                                    clear imm/text]
        return
        run: button "Execute" [ append buf to-block logo to-block a/text 
                                clear b/draw b/draw: copy buf  
                                if turtle/show [append b/draw to-block logo to-block turtle/aspect]]
        
        return
        button "None" []
        return
        button "Help" [insert a/text append (mold/only words-of langage) "^/^/"]
    ]
    panel  [ origin 0x0
        below
        prt: button "Print^/turtle" [t/text: mold turtle]
        clean: button "Clear^/Screen" [ turtle/ang: 180.0 turtle/pos: (250x250 * turtle/precision) turtle/show: true
                                        clear buf clear b/draw
                                        b/draw: to-block logo to-block turtle/aspect
                                        t/text: mold turtle]
    ]
    panel  [ origin 0x0
        t: area 500x140 font-size 8
    ]
    
    
    do [turtle/ang: 180.0 turtle/pos: (250x250 * turtle/precision) 
        print "*-*-* Dans la fin de VIEW *-*-*"
        b/draw: to-block logo to-block turtle/aspect
        probe b/draw
        print "*-*-* Dans la fin de VIEW (2) *-*-*"
        t/text: mold turtle]
]


;;; THE END OF MODULE