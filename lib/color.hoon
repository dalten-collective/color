|%
+$  rgb  [r=@ud g=@ud b=@ud]
+$  hsl  [h=@rd s=@rd l=@rd]
+$  ned  $~(%all $%(%rgb %hsl %hex %all))
+$  get
  $%  [%rgb rgb]
      [%hsl hsl]
      [%hex @ux]
      [%web @t]
      [%all rgb hsl @ux]
  ==
++  color
  |_  $:  =ned
          =rgb
          =hsl
          hex=@ux
      ==
  +*  lo  .
      ra  ~(. rd %n)
  ++  rax  |=([a=@rd b=@rd] ?:((gth:ra a b) a b))       ::  +rax: max @rd
  ++  rin  |=([a=@rd b=@rd] ?:((gth:ra a b) b a))       ::  +rin: min @rd
  ++  rud  |=(r=@rd `@ud`(abs:si (need (toi:ra r))))    ::  +rud: @rd to @ud
  ++  rod                                               ::  +rod: @rd modulo
    |=  [a=@rd b=@rd]
    ^-  @rd
    ?<  =(0 b)
    (sub:ra a (mul:ra b (sun:ra (div (rud a) (rud b)))))
  ::  +fiv: gives % of 255 from rgb values
  ::
  ++  fiv  |=(u=@ud `@rd`(div:ra (sun:ra u) .~255))
  ::  +lo-anod: change mode of output
  ::
  ++  lo-anod  |=(nod=^ned lo(ned nod))
  ::  +lo-cord: get web hexadecimal format
  ::
  ++  lo-cord
    ^-  @t
    %-  crip
    ?:  =(0 (met 3 hex))
      "#000000"
    ?:  =(1 (met 3 hex))
      :(welp "#" ((x-co:co 2) (cut 3 [0 1] hex)) "0000")
    ?:  =(2 (met 3 hex))
      ;:  welp
        "#"
        ((x-co:co 2) (cut 3 [1 1] hex))
        ((x-co:co 2) (cut 3 [0 1] hex))
        "00"
      ==
    ?>  =(3 (met 3 hex))
    ;:  welp
      "#"
      ((x-co:co 2) (cut 3 [2 1] hex))
      ((x-co:co 2) (cut 3 [1 1] hex))
      ((x-co:co 2) (cut 3 [0 1] hex))
    ==
  ::  +lo-sats: set saturation raw
  ::
  ++  lo-sats
    |=  sat=@rd
    =~  lo(hsl hsl(s sat))
        hsl-rgb
        rgb-hex
    ==
  ::  +lo-lumo: set luminocity raw
  ::
  ++  lo-lumo
    |=  lum=@rd
    =~  lo(hsl hsl(l lum))
        hsl-rgb
        rgb-hex
    ==
  ::  +lo-abed: build door sample
  ::
  ++  lo-abed
    |=  [got=get nod=^ned]
    ?+  -.got  !!
      %rgb  rgb-hsl:rgb-hex:lo(rgb +.got, ned nod)
      %hsl  rgb-hex:hsl-rgb:lo(hsl +.got, ned nod)
      %hex  rgb-hsl:hex-rgb:lo(hex +.got, ned nod)
        %web
      =~  lo(hex (scan (trip +.got) ;~(pfix hax ^hex)))
          hex-rgb
          rgb-hsl
      ==
    ==
  ::  +lo-abet: produce output
  ::
  ++  lo-abet
    ^-  get
    ?-  ned
      %all  all+[rgb hsl hex]
      %rgb  rgb+rgb
      %hsl  hsl+hsl
      %hex  hex+hex
    ==
  ::  conversion functions
  ++  hex-hsl  ^+(lo rgb-hsl:hex-rgb)
  ++  hsl-hex  ^+(lo rgb-hex:hsl-rgb)
  ::
  ++  rgb-hex
    ^+  lo
    lo(hex `@ux`(rap 3 `(list @ud)`~[b.rgb g.rgb r.rgb]))
  ::
  ++  hex-rgb
    ^+  lo
    %=  lo
        rgb
      :-  (cut 3 [2 1] hex)
      [(cut 3 [1 1] hex) (cut 3 [0 1] hex)]
    ==
  ::  +hsl-rgb: see https://www.baeldung.com/cs/convert-color-hsl-rgb
  ::
  ++  hsl-rgb
    ^+  lo
    ?:  =(0 s.hsl)
      =+  gray=(rud (mul:ra .~255 l.hsl))
      lo(rgb [gray gray gray])
    =+  h-prime=`@rd`(div:ra h.hsl .~60)
    =/  c=@rd
      =+  lab=(sub:ra (mul:ra .~2 l.hsl) .~1)
      =-  ?:((sig:ra -) - (mul:ra .~-1 -))
      %+  mul:ra  s.hsl
      ?:((sig:ra lab) (sub:ra .~1 lab) (add:ra .~1 lab))
    =/  x=@rd
      =+  lab=(sub:ra (rod h-prime .~2) .~1)
      =-  ?:((sig:ra -) - (mul:ra .~-1 -))
      %+  mul:ra  c
      ?:((sig:ra lab) (sub:ra .~1 lab) (add:ra .~1 lab))
    =+  m=(sub:ra l.hsl (div:ra c .~2))
    ::
    =;  [r=@ud g=@ud b=@ud]
      lo(rgb [r g b])
    =+  ce=(rud (mul:ra .~255 (add:ra m c)))
    =+  ex=(rud (mul:ra .~255 (add:ra m x)))
    =+  oh=(rud (mul:ra .~255 m))
    ?>  (gte:ra .~6 h-prime)
    ?:  (lte:ra .~5 h-prime)  [ce oh ex]
    ?:  (lte:ra .~4 h-prime)  [ex oh ce]
    ?:  (lte:ra .~3 h-prime)  [oh ex ce]
    ?:  (lte:ra .~2 h-prime)  [oh ce ex]
    ?:  (lte:ra .~1 h-prime)  [ex ce oh]
    ?>  (lte:ra .~0 h-prime)  [ce ex oh]
  ::
  ++  rgb-hsl
    ^+  lo
    =+  [r=(fiv r.rgb) g=(fiv g.rgb) b=(fiv b.rgb)]
    ?:  &(=(0 r) =(0 g) =(0 b))  lo(hsl [.~0 .~0 .~0])
    =+  max=(roll `(list @rd)`~[r g b] rax)
    =+  min=(roll `(list @rd)`~[r g b] rin)
    =+  lum=(div:ra (add:ra max min) .~2)
    =;  [sat=@rd hue=@rd]
      lo(hsl [hue sat lum])
    :-  ?.  (gth:ra (div:ra (add:ra min max) .~2) .~5)
          (div:ra (sub:ra max min) (add:ra max min))
        (div:ra (sub:ra max min) (add .~2 (sub:ra max min)))
    ?:  =(min max)  .~0
    ?:  =(max r)
      ::  red = (g - b) / (max - min) * 60
      ?:  (gth:ra g b)
        (mul:ra (div:ra (sub:ra g b) (sub:ra max min)) .~60)
      %+  sub:ra  .~360 
      (mul:ra (div:ra (sub:ra b g) (sub:ra max min)) .~60)
    ?:  =(max g)
      ::  green = [2 + (b - r) / (max - min)] * 60
      ?:  (gth:ra b r)
        %+  add:ra  .~2
        (mul:ra (div:ra (sub:ra b r) (sub:ra max min)) .~60)
      %+  sub:ra  .~360  %+  add:ra  .~2
      (mul:ra (div:ra (sub:ra r b) (sub:ra max min)) .~60)
    ?>  =(max b)
    ::  blue  = [4 + (r - g) / (max - min)] * 60
    ?:  (gth:ra b r)
      %+  add:ra  .~4
      (mul:ra (div:ra (sub:ra b r) (sub:ra max min)) .~60)
    %+  sub:ra  .~360
    %+  add:ra  .~4
    (mul:ra (div:ra (sub:ra r b) (sub:ra max min)) .~60)
  --
--