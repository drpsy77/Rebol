Red [
    Title: "Brainfuck interpretor"
    Author: "Drpsy"
	Version: 1.0.0
    Needs: 'View
	Comments: {
	interpretor of Brainfuck
	}
]

counterstack: []

push: function [ a ][ append counterstack a ]
pop: function [ ] [ take/last counterstack ]
stackoverflow?: function [] [
	either ((length? counterstack) > 30000) [true][false]
]

match: make object! [
	ahead: function [
		str [string!] a [char!] b [char!]
		/local t [integer!] s [string!]
	][
		t: 0
		s: str
		until [
			if s/1 = a [ t: t + 1 ]
			if s/1 = b [ t: t - 1 ]
			s: next s
			t = 0 or tail? s
		]
		either t = 0 [ (index? s) - 1 ][none]
	]
	backward: function [
		str [string!] a [char!] b [char!]
		/local t [integer!] s [string!]
	][
		t: 0
		s: str
		until [
			if s/1 = a [ t: t - 1 ]
			if s/1 = b [ t: t + 1 ]
			t = 0 or either head? s [true][ s: back s false]
		]
		either t = 0 [ (index? s) + 1 ][none]
	]
]

verify: function [ p /local t [integer!] u [integer!] i [integer!] m [integer!] s [string!] ][
	t: 0 u: 0 s: copy p i: 0 m: 0
	do until [
		if s/1 = #"[" [ t: t + 1 i: i + 1 if i > m [m: i] ]
		if s/1 = #"]" [ u: u + 1 i: i - 1  ]
		s: next s
		tail? s
	]
	either t = u [255 ** m * t][none]
]


<<<<<<< Updated upstream
=======
test-infinite: function [ sc [integer!] sl [integer!] si [integer!] cc [integer!] cl [integer!] ci [integer!]][
	either stackoverflow? [true][           ; depassement de la pile interne
		either sl <> cl [false][            ; the length of input has changed ==> not yet an infinite loop
			either ((cc = sc) and (si = ci)) [true][          ; neither the value of cells/1 nor the index of cells have changed since last time
				either si <> ci [false][    ; the length of input doesn't change anymore, the value of cells/1 has changed, but there are still cases of infinite loop
					di: sc - cc
					either odd? di [false][
						either odd? cc [true][false]
					]		
				]
			]
		]
	]
]

>>>>>>> Stashed changes

bf: function [
	prog [string!]
	inin [string!]
][
	size: 30000
	cells: copy []
	out: copy ""
	sprog: prog

	ll: verify sprog
	if (ll = none) [append out "Error in [] balance" break]
	
	append/dup cells 0 size
	
	while [ not tail? sprog ][
	;	prin sprog/1 prin ":" prin cells/1 prin "."
		switch sprog/1 [
			#">" [ either tail? (next cells) [ cells: head cells      ] [ cells:   next cells    ] ]
			#"<" [ either head? cells        [ cells: back tail cells ] [ cells:   back cells    ] ]
			#"+" [ either cells/1 = 255      [ cells/1: 0             ] [ cells/1: cells/1 + 1   ] ch: true ]
			#"-" [ either cells/1 = 0        [ cells/1: 255           ] [ cells/1: cells/1 - 1   ] ch: true ]
			
			#"." [ append out to-string to-char cells/1                             ]
			#"," [ either tail? inin [none] [cells/1: to-integer take inin]         ]

			#"[" [
				/local l: match/ahead sprog #"[" #"]"
				either none? l [
					append out "At(" append out form (index? sprog) append out "): Error in [] balance" break
				][
					either cells/1 = 0 [
						loop (l - (index? sprog)) [sprog: next sprog]
					][
					]
				]
			]
			#"]" [
				/local l: match/backward sprog #"[" #"]"
				either none? l [
					append out "At(" append out form (index? sprog) append out "): Error in [] balance" break
				][
					either cells/1 = 0 [
					][
						loop ((index? sprog) - l + 1 ) [sprog: back sprog]
					]
				]
			]
			
		]
		sprog: next sprog
	]

	cells: head cells
	ret: ["" ""]
	poke ret 1 out
	poke ret 2 mold cells
	ret
]

view layout [
	title "BF interpretor"
	across
	space 1x1
	button 96x100 "Do this :" font[size: 13] [ do [
			tmp: (bf (copy i/text) (copy h/text))
			o/text: tmp/1
			c/text: tmp/2
		]]
	i: area 900x100 wrap {>>+[->,>+<-------------------------------------------[+++++++++++++++++++++++++++++++++++++++++++<]>>]<->>>>>+[->,>+<-------------------------------------------------------------[+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<]>>]<<<<[<+<]+[<+>-<<[>-]>]<<[<+<]>[>]<[[->+>+[>+<->>[<-]<]>>[>]<+[<]+[<+>-<<[>-]>]<<-<]+[>+<->>[<-]<]>>[>]<<-<[<]+[<+>-<<[>-]>]<<-<]+[>+<->>[<-]<]>>[------------------------------------------------>>]>-<<<[<<]++++++++++++++++++++++++++++++++++++++++++++++++[>>]<<<<[[>>->[>]>+>>>>>>>+<<<<<<<<<[<]><<]>+[>]>-[-<<[<]>+[>]>]>>>>>+>>>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<[->-[>]<<]<[-<<<<<<<[<]+>----------<<+>[>]>>>>>>]<[-<<<<<<<[<]+[>]>>>>>]>>>[-]>[-]<<<<<<<<<<[<]><<]>>------------------------------------------------[++++++++++++++++++++++++++++++++++++++++++++++++.[-]]>>[.>>]++++++++++.
	} font[name: "Consolas" size: 13]
	return
	text 100x100 "Input" font[size: 13]
	h: area 900x100 wrap "572+953=" font[name: "Consolas" size: 13]
	return
	text 100x100 "Result" font[size: 13]
	o: area 900x100 wrap "" font[name: "Consolas" size: 13]
	return
	text 100x100 "Cells" font[size: 13]
	c: area 900x100 wrap "" font[name: "Consolas" size: 13]
	on-close [print cells]
]
