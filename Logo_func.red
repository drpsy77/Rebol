Red [
    Title: "Logo_Interpreter" 
    needs: 'view
]


stack: copy []

push: function [arg][
    insert/only stack (either ((series? arg) or (bitset? arg) or (object? arg)) [copy/deep arg][
                        either string? arg [to-block arg][arg]])
    probe stack
]

pop: function [][
    s: first stack
    remove stack
    return s
]

stack?: function [][return first stack]


;-----------------------------------
;    buf : buffer de draw pour pouvoir remettre la tortue à la fin 

buf: copy ""


turtle: make object! [
    precision: 1
    pos: 250x250
    ang: 0.0
    color: black
    active: true
    show: true
    aspect: [ empile couleur red baisse td 90 av 5 tg 110 av 15 tg 140 av 15 tg 110 av 5 tg 90 depile]
    draw: function [s [string!]][if s [either langage/dest [append langage/dest copy s][langage/dest: copy s]]]
]



background: white

arity-of: function [f [function!]][
    c: 0
    foreach i spec-of :f [either (word? i) [c: c + 1][ if (('local = i) or ('return = i)) [break]]]
    return c
]



langage: make map![
    dest: buf
    td: [function [arg1][turtle/ang: (turtle/ang - arg1) % 360 return ""]]
    tg: [function [arg1][turtle/ang: (turtle/ang + arg1) % 360 return ""]]
    av: [function [arg0][
                        arg1: arg0 * turtle/precision
                        p: 0x0
                        p/x: to-integer round (turtle/pos/x + (arg1 * (sin (pi * turtle/ang / 180))))
                        p/y: to-integer round (turtle/pos/y + (arg1 * (cos (pi * turtle/ang / 180))))
                        either (turtle/active) [s: form reduce [" line " (turtle/pos / turtle/precision) (p / turtle/precision)]][s: copy ""]
                        turtle/pos: p
                        turtle/draw s
                        return ""
    ]]
    re: [function [arg0][
                        arg1: arg0 * turtle/precision
                        p: 0x0
                        p/x: to-integer round (turtle/pos/x - (arg1 * (sin (pi * turtle/ang / 180))))
                        p/y: to-integer round (turtle/pos/y - (arg1 * (cos (pi * turtle/ang / 180))))
                        either (turtle/active) [s: form reduce [" line " (turtle/pos / turtle/precision) (p / turtle/precision)]][s: copy ""]
                        turtle/pos: p
                        turtle/draw s
                        return ""
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
        turtle/draw form reduce [" pen " turtle/color]
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
;       arg1 contient un block de 3 éléments : 
;       le nom de la fonction, un block pour les arguments, un block pour le code        
        either not series? arg1 [print "ERR: Pour n'a pas d'argument de type block" return ""][
        either not series? third arg1 [print "ERR: Pour n'a pas d'argument de block de code" return ""][
        either not word? first arg1 [print "ERR: Pour n'a pas pour premier argument un nom de fonction" return ""][
        if not series? second arg1 [print "ERR: Pour : les arguments doivent être entre []" return ""]
            prin "**** DANS POUR / arg1 = " probe arg1 probe first arg1
            bs: copy [return logo ] append/only bs to-block third arg1
            bu: copy [function] append/only bu make block! second arg1 append/only bu bs 
            either select langage first arg1 
                [ put    langage first arg1  bu ]
                [ bt: copy [make map! ] append/only bt to-block first arg1
                  append/only third bt bu
                  prin "bt = " probe bt
                  extend langage do bt]
            probe langage
            return ""
        ]]]
    ]]
    empile: [function [][
        push turtle/color
        push turtle/active
        return ""
    ]]
    depile: [function [][
        turtle/active: pop
        turtle/color: pop
        return ""
    ]]
    si: [function [arg1 arg2 arg3][
        
    
    ]]
;-------------------------    
;  template de fonction a générer à partir d'une déclaration de fonction en LOGO
;  le code LOGO :
;     Pour carre [arg1] [repete 4 [av arg1 td 90]]
;
;-------------------------
    carre: [function [arg1][
        return logo [repete 4 [av arg1 td 90]]
         
    ]]
    eval: [function [arg1 [series!]][
        return do arg1
    ]]
    =: [function [arg1][
        var: pop 
        if block? arg1 [ arg1: logo arg1 pop]
        prin "Pour '=' : haut de la pile = " probe :var prin " | valeur = " probe arg1
        either word? var [
            print "coucou"
            either select langage var
                [
                    probe var probe arg1
                    print put    langage var  arg1 
                    probe langage
                ]
                [ bt: copy [make map!] bu: to-string to-word var append bu " " append bu to-string arg1 bu: to-block bu append/only bt bu
;                  prin "bt = "                   probe bt
                  extend langage do bt]
            return arg1
        ][
            print "probleme"
            return ""
        ]
    ]]
    +: [function [arg1][
        var: pop 
        push ((either word? var [ select langage var][var]) + (either word? arg1 [select langage arg1][arg1]))
        return  stack?
    ]]
    -: [function [arg1][
        var: pop 
        push ((either word? var [ select langage var][var]) - (either word? arg1 [select langage arg1][arg1]))
        return stack?
    ]]
    *: [function [arg1][
        var: pop 
        push ((either word? var [ select langage var][var]) * (either word? arg1 [select langage arg1][arg1]))
        return stack?
    ]]
    /: [function [arg1][
        var: pop 
        push ((either word? var [ select langage var][var]) / (either word? arg1 [select langage arg1][arg1]))
        return stack?
    ]]
    spc: [function [arg1][
        s: copy " "
        loop arg1 [append s " "]
        return s
    ]]
    retour: [function [][
        return "^/"
    ]]
]


logo: function [ code [any-type!] /turt return: [string!] ][
    if string? code [code: to-block code]
    if turt [langage/dest: b/draw]
;    probe code
    ret: copy ""
    until [
        instr: first code
;        probe instr
;   on définit f comme la fonction qui correspond au mot clé fourni par le langage
        either word? instr [
            f: select langage  instr
;   on créée un block avec f suivie de ses arguments
            either f [
                either series? f [
                    f: do f
                    g: copy [ f ]
                    loop arity-of :f [ 
                        code: next code  
                        fc: first code
;                        probe fc print type? fc
                        fd: select langage fc
;                        probe fd
                        append/only g either (number? fc )[fc][ either fd [either number? fd [fd][ 0]][fc]]]
;                    prin "f = " prin instr prin " " probe g 
;   on exécute f avec ses arguments, contenue sous forme de block dans g
                    ret: do g
                ][
;                    prin instr print " empilée"
                    push instr
                ]][
;                    prin instr print " n'est pas dans langage"
                    push instr
                ]
        ][ 
;            prin instr print " n'est pas un mot"
            push instr
        ]
        code: next code
        tail? code
    ]
    if turt [langage/dest: buf]
    return ret
]

view [
    title "Canvas"
    size 850x650
    across
    a: area 250x480 wrap {zz = 10 
zt = 10
zh = 10
rp = 10
lg = [zz * rp * 2]

leve
re 200
td 90
re 200
tg 90

repete rp [
  repete zz [ 
    repete rp [ baisse av zz leve av zz ] 
    td 90 av 1 td 90 av lg td 180 
  ]
  td 90
  av zt
  tg 90
  av zt
]

}
    b: base 570x480 background []
    return
    
    panel  [ origin 0x0
        text 45x24 " Instant:"
        imm: field 195x24 on-enter [
;                                    print " Avant l'exécution" probe turtle
                                    s: logo imm/text 
;                                    print " Après l'exécution" probe turtle
                                    b/draw: copy buf
                                    if turtle/show [logo/turt turtle/aspect ] 
;                                    print " Après la tortue" probe turtle
                                    b/draw: to-block b/draw
                                    append a/text "^/" append a/text imm/text append a/text "^/" append t/text s
                                    clear imm/text ]
        return
        run: button "Execute" [ s: logo a/text 
                                b/draw: copy buf
                                if turtle/show [logo/turt turtle/aspect ]
                                b/draw: to-block b/draw
                                if s [append t/text s]
                                ]
        
        return
        button "None" []
        return
        button "Help" [insert a/text append (mold/only words-of langage) "^/^/"]
    ]
    panel  [ origin 0x0
        below
        prt:   button "Print^/turtle" [ append t/text mold turtle]
        clean: button "Clear^/Screen" [ turtle/ang: 180.0 turtle/pos: (250x250 * turtle/precision) turtle/show: true
                                        b/draw: copy "" clear buf
                                        logo/turt turtle/aspect
                                        b/draw: to-block b/draw]
    ]
    panel  [ origin 0x0
        t: area 500x140 font-size 8
    ]
    
    
    do [turtle/ang: 180.0 turtle/pos: (250x250 * turtle/precision) 
        b/draw: copy ""
        logo/turt turtle/aspect
        b/draw: to-block b/draw
        t/text: ""]
]


;;; THE END OF MODULE