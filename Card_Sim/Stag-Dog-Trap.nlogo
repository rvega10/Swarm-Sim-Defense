__includes ["background_code.nls"]

;;
;; Runtime Procedures
;;
to go

  background_procedures ; for general functions like showing FOV

  ask stags
    [
      ; set whether or not the stag can detect specific types of agents
      set detect_stags? false
      set detect_traps? false
      set detect_dogs? true

      ifelse selected_algorithm_stag = "Manual Control"
      [
        stag_procedure_manual
      ]
      [
       stag_procedure
      ]
    ]

 ask traps
    [
      ; set whether or not the trap can detect specific types of agents
      set detect_traps? false
      set detect_stags? false
      trap_procedure
    ]

  ask dogs
    [
      ; set whether or not the trap can detect specific types of agents
      set detect_traps? false
      set detect_stags? true
      dog_procedure
    ]

  ask centroids
  [
    setxy (mean [xcor] of traps) (mean [ycor] of traps)
    ht
  ]

  measure_results

  if end_flag = 1
  [
    ifelse time-to-first-arrival = 0
     [
       set win-loss-list fput 1 win-loss-list
     ]
     [
       set win-loss-list fput 0 win-loss-list
     ]



    set win-loss-ratio (sum win-loss-list) / length win-loss-list

    ifelse loop_sim?
     [
       set seed-no (seed-no + 1)
       setup
     ]
     [
       stop
     ]

  ]

  tick-advance 1
end
@#$#@#$#@
GRAPHICS-WINDOW
837
66
1397
627
-1
-1
13.463415
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
10.0

SLIDER
191
30
283
63
seed-no
seed-no
1
150
2.0
1
1
NIL
HORIZONTAL

SLIDER
17
290
240
323
vision-distance-traps
vision-distance-traps
0
30
30.0
0.5
1
m
HORIZONTAL

SLIDER
15
327
224
360
vision-cone-traps
vision-cone-traps
0
360
45.0
5
1
deg
HORIZONTAL

SLIDER
14
367
193
400
speed-traps
speed-traps
0
5
5.0
0.5
1
m/s
HORIZONTAL

SLIDER
12
403
238
436
turning-rate-traps
turning-rate-traps
0
360
30.0
5
1
deg/s
HORIZONTAL

BUTTON
22
22
102
62
NIL
setup
NIL
1
T
OBSERVER
NIL
P
NIL
NIL
1

BUTTON
110
22
177
62
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
9
444
112
479
NIL
add_trap
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
8
484
134
519
NIL
remove_trap\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
257
94
377
127
paint_fov?
paint_fov?
1
1
-1000

SWITCH
488
92
609
125
draw_path?
draw_path?
0
1
-1000

BUTTON
609
92
712
125
clear-paths
clear-drawing
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
378
93
478
126
NIL
clear-paint
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
19
250
204
283
number-of-traps
number-of-traps
0
10000
5700.0
100
1
NIL
HORIZONTAL

SLIDER
247
556
420
589
c
c
0
5
0.5
.25
1
NIL
HORIZONTAL

TEXTBOX
257
536
472
562
For Levy Distribution
11
0.0
1

TEXTBOX
266
78
481
104
Turn off to speed up sim\n
11
0.0
1

TEXTBOX
2194
1245
2409
1271
NIL
11
0.0
1

MONITOR
851
12
1036
57
Time of Stag Escaping
time-to-first-arrival
17
1
11

SLIDER
248
596
395
629
max_levy_time
max_levy_time
0
100
100.0
1
1
sec
HORIZONTAL

CHOOSER
16
191
214
236
selected_algorithm_traps
selected_algorithm_traps
"Lie and Wait" "Straight" "Standard Random" "Levy"
0

CHOOSER
251
636
437
681
distribution_for_direction
distribution_for_direction
"uniform" "gaussian" "triangle"
0

TEXTBOX
13
538
228
564
for random walk algorithms parameters
11
0.0
1

SLIDER
36
597
209
630
step_length_fixed
step_length_fixed
0
100
50.0
10
1
NIL
HORIZONTAL

TEXTBOX
26
66
214
89
Traps
11
0.0
1

SLIDER
31
818
250
851
noise-actuating-speed
noise-actuating-speed
0
1
0.0
0.1
1
m/s
HORIZONTAL

SLIDER
29
870
265
903
noise-actuating-turning
noise-actuating-turning
0
30
0.0
5
1
deg/s
HORIZONTAL

SLIDER
29
926
210
959
state-disturbance_xy
state-disturbance_xy
0
1
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
35
978
236
1011
state-disturbance_head
state-disturbance_head
0
50
0.0
5
1
NIL
HORIZONTAL

SLIDER
528
249
705
282
number-of-stags
number-of-stags
0
3
1.0
1
1
NIL
HORIZONTAL

SLIDER
516
286
735
319
vision-distance-stags
vision-distance-stags
0
5000
400.0
1000
1
m
HORIZONTAL

SLIDER
519
325
731
358
vision-cone-stags
vision-cone-stags
0
360
360.0
10
1
deg
HORIZONTAL

SLIDER
516
362
710
395
speed-stags
speed-stags
0
10
7.0
0.5
1
m/s
HORIZONTAL

SLIDER
515
402
726
435
turning-rate-stags
turning-rate-stags
0
180
1.0
10
1
deg/s
HORIZONTAL

CHOOSER
514
190
722
235
selected_algorithm_stag
selected_algorithm_stag
"Auto" "Manual Control" "Better-Auto"
0

MONITOR
1047
13
1217
58
Time of Drugboat Caught
time-of-first-stag-detected
17
1
11

CHOOSER
23
86
244
131
Trap_setup
Trap_setup
"Random - Uniform" "Random - Gaussian" "Random - Inverse-Gaussian" "Barrier" "Random Group" "Perfect Picket" "Imperfect Picket"
2

BUTTON
600
467
683
501
Forward
ask stags [ set inputs (list (speed-stags / meters-per-patch) 90 0)]
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
600
514
680
548
Reverse
ask stags[ set inputs (list (speed-stags / meters-per-patch) 270 0)]
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
610
564
674
598
Stop
ask stags[ set inputs (list 0 0 0)]
NIL
1
T
OBSERVER
NIL
X
NIL
NIL
1

BUTTON
692
514
790
548
Turn Right
ask stags[ set inputs (list (speed-stags / meters-per-patch) 90 turning-rate-stags)]
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
499
518
588
552
Turn Left
ask stags[ set inputs (list (speed-stags / meters-per-patch) 90 (- turning-rate-stags))]
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

SWITCH
299
30
418
63
loop_sim?
loop_sim?
1
1
-1000

TEXTBOX
503
445
881
464
Controls for 'selected_algorithm_stag' = Manual Control
11
0.0
1

SLIDER
35
558
209
591
turning-rate-rw
turning-rate-rw
0
180
180.0
10
1
deg/s
HORIZONTAL

TEXTBOX
45
640
195
658
for spiral algorithm
11
0.0
1

SLIDER
266
199
438
232
number-of-dogs
number-of-dogs
0
5
0.0
1
1
NIL
HORIZONTAL

SWITCH
273
404
425
437
lead_stag?
lead_stag?
1
1
-1000

SLIDER
264
244
466
277
vision-distance-dogs
vision-distance-dogs
0
12000
1100.0
1000
1
m
HORIZONTAL

SLIDER
264
282
456
315
vision-cone-dogs
vision-cone-dogs
0
360
360.0
10
1
deg
HORIZONTAL

SLIDER
265
319
437
352
speed-dogs
speed-dogs
0
10
7.0
.5
1
m/s
HORIZONTAL

SLIDER
265
356
474
389
turning-rate-dogs
turning-rate-dogs
0
360
40.0
10
1
deg/s
HORIZONTAL

SLIDER
431
30
571
63
meters-per-patch
meters-per-patch
100
1000
100.0
100
1
NIL
HORIZONTAL

TEXTBOX
439
10
589
28
Scales Simulation
11
0.0
1

TEXTBOX
1224
29
1374
47
40 x 40 Patches
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

180-deg-fov
true
0
Polygon -7500403 true true 0 150 0 120 15 90 30 60 60 30 90 15 135 0 165 0 210 15 240 30 270 60 285 90 300 120 300 150 0 150

30-deg-fov
true
0
Polygon -7500403 true true 150 150 104 8 110 6 120 4 126 3 141 1 151 0 169 1 180 4 194 7 150 150

45-deg-fov
true
0
Polygon -7500403 true true 105 210
Polygon -7500403 true true 150 150 210 14 180 0 120 0 90 15 150 150

60-deg-fov
true
0
Polygon -7500403 true true 150 150 69 25 77 19 94 11 114 5 126 2 141 0 154 0 167 0 176 2 192 6 207 12 225 20 229 21 150 150

90-deg-fov
true
0
Polygon -7500403 true true 150 150 255 45 240 30 210 15 180 0 120 0 60 30 45 45 150 150

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

ball tennis
false
0
Circle -7500403 true true 30 30 240
Circle -7500403 false true 30 30 240
Polygon -16777216 true false 50 82 54 90 59 107 64 140 64 164 63 189 59 207 54 222 68 236 76 220 81 195 84 163 83 139 78 102 72 83 63 67
Polygon -16777216 true false 250 82 246 90 241 107 236 140 236 164 237 189 241 207 246 222 232 236 224 220 219 195 216 163 217 139 222 102 228 83 237 67
Polygon -1 true false 247 79 243 86 237 106 232 138 232 167 235 199 239 215 244 225 236 234 229 221 224 196 220 163 221 138 227 102 234 83 240 71
Polygon -1 true false 53 79 57 86 63 106 68 138 68 167 65 199 61 215 56 225 64 234 71 221 76 196 80 163 79 138 73 102 66 83 60 71

boat
true
0
Polygon -7500403 true true 150 0 135 15 120 45 120 255 135 285 150 300 165 285 180 255 180 45 165 15 150 0
Polygon -1 true false 150 45
Polygon -1 true false 150 0 135 30 165 30 150 0

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
true
0
Line -7500403 true 135 135 135 30
Circle -7500403 true true 0 0 300

circle 2
true
0
Circle -16777216 true false 0 0 300
Circle -7500403 true true 0 0 300
Polygon -1 true false 150 0 105 135 195 135 150 0

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dog
true
0
Circle -16777216 true false 0 0 300
Circle -7500403 true true 1 2 300
Polygon -1 true false 150 0 105 135 195 135 150 0
Rectangle -1 true false 67 208 232 232
Rectangle -1 true false 140 149 155 299

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

key
false
0
Rectangle -7500403 true true 90 120 285 150
Rectangle -7500403 true true 255 135 285 195
Rectangle -7500403 true true 180 135 210 195
Circle -7500403 true true 0 60 150
Circle -1 true false 30 90 90

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

levy
true
0
Polygon -7500403 true true 150 15 120 0 75 60 60 135 15 180 15 210 120 195 90 255 105 285 120 300 150 270 180 300 195 285 210 255 180 195 285 210 285 180 240 135 225 60 180 0
Polygon -1 true false 120 60 120 165 135 165 135 60
Polygon -1 true false 135 150 180 150 180 165 135 165

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

police
false
0
Circle -7500403 false true 45 45 210
Polygon -7500403 true true 96 225 150 60 206 224 63 120 236 120
Polygon -7500403 true true 120 120 195 120 180 180 180 185 113 183
Polygon -7500403 false true 30 15 0 45 15 60 30 90 30 105 15 165 3 209 3 225 15 255 60 270 75 270 99 256 105 270 120 285 150 300 180 285 195 270 203 256 240 270 255 270 285 255 294 225 294 210 285 165 270 105 270 90 285 60 300 45 270 15 225 30 210 30 150 15 90 30 75 30

ring
true
0
Circle -7500403 true true 0 0 300
Polygon -1 false false 150 0 135 150 165 150 150 0

runner
true
0
Circle -7500403 true true -3 -3 306
Rectangle -7500403 true true 45 45 255 255
Polygon -1 true false 150 0 105 135 195 135 150 0
Rectangle -1 true false 60 60 250 225

sanctuary
true
0
Circle -7500403 false true -1 -1 301

second-hunters
true
0
Circle -16777216 true false 0 0 300
Circle -7500403 true true 0 0 300
Polygon -1 true false 150 0 105 135 195 135 150 0
Polygon -1 false false 75 165 210 225 90 225 210 165 210 225 255 135 60 135 90 225

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 0 0 300 300

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 219 240 248 246 269 228 281 215 267 193 225
Polygon -10899396 true false 225 90 255 75 275 75 290 89 299 108 291 124 270 105 255 105 240 105
Polygon -10899396 true false 75 90 45 75 25 75 10 89 1 108 9 124 30 105 45 105 60 105
Polygon -10899396 true false 132 70 134 49 107 36 108 2 150 -13 192 3 192 37 169 50 172 72
Polygon -10899396 true false 85 219 60 248 54 269 72 281 85 267 107 225
Polygon -7500403 true true 75 30 225 30 270 75 270 195 255 240 180 300 135 300 45 240 30 195 30 75

turtle2
true
0
Polygon -10899396 true false 215 219 240 248 246 269 228 281 215 267 193 225
Polygon -10899396 true false 225 90 255 75 275 75 290 89 299 108 291 124 270 105 255 105 240 105
Polygon -10899396 true false 75 90 45 75 25 75 10 89 1 108 9 124 30 105 45 105 60 105
Polygon -10899396 true false 132 70 134 49 107 36 108 2 150 -13 192 3 192 37 169 50 172 72
Polygon -10899396 true false 85 219 60 248 54 269 72 281 85 267 107 225
Polygon -7500403 true true 75 30 225 30 270 75 270 195 255 240 180 300 135 300 45 240 30 195 30 75

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="scoring_only_traps" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="6000"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>win-loss-ratio</metric>
    <enumeratedValueSet variable="Trap_Setup">
      <value value="&quot;Random - Uniform&quot;"/>
      <value value="&quot;Random - Gaussian&quot;"/>
      <value value="&quot;Random - Inverse-Gaussian&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="number-of-traps" first="100" step="100" last="5000"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="20"/>
  </experiment>
  <experiment name="scoring_only_traps_scale" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="6000"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>win-loss-ratio</metric>
    <enumeratedValueSet variable="Trap_Setup">
      <value value="&quot;Random - Uniform&quot;"/>
      <value value="&quot;Random - Gaussian&quot;"/>
      <value value="&quot;Random - Inverse-Gaussian&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-traps">
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="10"/>
      <value value="18"/>
      <value value="32"/>
      <value value="57"/>
      <value value="100"/>
      <value value="178"/>
      <value value="317"/>
      <value value="563"/>
      <value value="1000"/>
      <value value="1778"/>
      <value value="3162"/>
      <value value="5623"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed-no" first="1" step="1" last="10"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
