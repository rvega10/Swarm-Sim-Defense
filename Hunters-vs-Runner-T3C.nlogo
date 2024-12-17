__includes ["Additional_Code_T3C.nls"]

;;
;; Runtime Procedures
;;
to go

  background_procedures

  ask runners
    [

      set detect_sanctuaries? true
      set detect_runners? false
      set detect_hunters? true

      ifelse selected_algorithm_runner = "Manual Control"
      [
        runner_procedure_manual
      ]
      [
       runner_procedure
      ]

    ]

 ask hunters
    [
      set detect_sanctuaries? false
      set detect_runners? true
      set detect_hunters? true
      hunter_procedure

      ]

  ask sanctuaries
  [
    ifelse fog?
    [
      ifelse distance min-one-of runners [distance myself] < (vision-distance2 * 0.1 + size * 0.1)
      [
        st
       ]
      [
        ht
       ]
    ]
    [
       st
    ]
  ]

  measure_results

  if end_flag = 1
  [
    ask patches with [distance runner (count sanctuaries) > (vision-distance2 * 0.2)]
    [
      set pcolor red
    ]
    stop
  ]

  tick-advance 1
end

to runner_procedure
  set_actuating_and_extra_variables
  do_sensing



  ifelse length fov-list-sanctuaries > 0
    [
      set detection_response_type "forward"
      detection_response_procedure
      set color green
    ]
    [
      ifelse action_step_count > 0
        [
          detection_response_procedure ; if agent is detected, it stops everything and executes the desired algorithm for one second

          set action_step_count (action_step_count - 1) ;counts down in ticks (10 ticks per second)
          set color red
        ]
        [
         ifelse length fov-list-hunters > 0
           [
             set detection_response_type "turn-away-in-place"
             choose_rand_turn

             set action_step_count (0.5 / tick-delta)
           ]
           [
             ifelse stuck_count > 100
               [
                set detection_response_type "90-in-place"
                choose_rand_turn
                set action_step_count (1 / tick-delta)
                set stuck_count 0
               ]
               [
                go_to_sanctuary
                set color orange
               ]
           ]
       ]
    ]

    ifelse ycor > furthest_ycor
    [
      set furthest_ycor ycor
      set trapped_count 0
    ]
    [
      set trapped_count trapped_count + 1
    ]

 update_agent_state; updates states of agents (i.e. position and heading)
end


to hunter_procedure
  set_actuating_and_extra_variables
  do_sensing

  ifelse can_distinguish?
    [
      ifelse length fov-list-runners > 0
        [
          set detection_response_type "forward"
          detection_response_procedure
          set color green
        ]
        [
        set fov-list-hunters (list )
          ifelse action_step_count > 0
            [
              detection_response_procedure ; if agent is detected, it stops everything and executes the desired algorithm for one second

              set action_step_count (action_step_count - 1) ;counts down
              set color blue
            ]
            [
              ifelse sleep_timer < 0 and length fov-list-hunters > 0
                [
                  ifelse selected_algorithm1 = "Alg A"
                  [
                    set detection_response_type "mill-response"
                  ]
                  [
                    ifelse selected_algorithm1 = "Alg B"
                    [
                      set detection_response_type "diffuse-response"
                    ]
                    [
                      set detection_response_type "180-in-place"
                      choose_rand_turn
                      set sleep_timer 20
                    ]
                  ]
                  set action_step_count (1 / tick-delta)
                ]
                [
                    ifelse stuck_count > 20
                    [
                     set detection_response_type "180-in-place"
                     choose_rand_turn
                     set action_step_count (1 / tick-delta)
                     set stuck_count 0
                    ]
                    [
                      select_alg_procedure1
                      set color violet
                    ]

                    set sleep_timer (sleep_timer - 1)
                ]
           ]
        ]
     ]
     [
       ifelse action_step_count > 0
            [
              detection_response_procedure ; if agent is detected, it stops everything and executes the desired algorithm for one second

              set action_step_count (action_step_count - 1) ;counts down
              set color blue
            ]
            [
             ifelse length fov-list-runners > 0 or length fov-list-hunters > 0
              [
                set detection_response_type "forward"
                detection_response_procedure
                set color green
              ]
              [
                ifelse stuck_count > 20
                  [
                   set detection_response_type "180-in-place"
                   choose_rand_turn
                   set action_step_count (1 / tick-delta)
                   set stuck_count 0
                  ]
                  [
                    select_alg_procedure1
                    set color violet
                  ]
              ]
        ]
     ]

  ifelse fog?
  [
    ifelse distance min-one-of runners [distance myself] < (vision-distance2 * 0.1)
    [
      st
    ]
    [
     ht
    ]
  ]
  [
     st
  ]



 update_agent_state; updates states of agents (i.e. position and heading)

  if distance min-one-of runners [distance myself] < (size / 2 + (mean [size] of runners) / 2)
  [ set runner_caught_flag 1]

end

to runner_procedure_manual
  set_actuating_and_extra_variables
  do_sensing







    ifelse ycor > furthest_ycor
    [
      set furthest_ycor ycor
      set trapped_count 0
    ]
    [
      set trapped_count trapped_count + 1
    ]

    if ycor > 40
    [
      set trapped_count 0
    ]

 update_agent_state_omni; updates states of agents (i.e. position and heading)



end
@#$#@#$#@
GRAPHICS-WINDOW
976
12
1845
882
-1
-1
16.9011
1
10
1
1
1
0
0
0
1
-25
25
-25
25
1
1
1
ticks
10.0

SLIDER
262
185
435
218
number-of-runners
number-of-runners
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
191
30
283
63
seed-no
seed-no
1
50
7.0
1
1
NIL
HORIZONTAL

SLIDER
18
222
190
255
vision-distance
vision-distance
0
40
10.0
1
1
m
HORIZONTAL

SLIDER
16
260
188
293
vision-cone
vision-cone
0
360
360.0
1
1
deg
HORIZONTAL

SLIDER
15
300
194
333
speed1
speed1
0
6
5.0
0.5
1
m/s
HORIZONTAL

SLIDER
13
336
193
369
turning-rate1
turning-rate1
0
360
120.0
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
322
28
425
63
NIL
add_hunter
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
446
31
572
66
NIL
remove_hunter
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
17
509
215
542
noise-actuating-speed
noise-actuating-speed
0
2
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
20
469
216
502
noise-actuating-turning
noise-actuating-turning
0
20
0.0
1
1
NIL
HORIZONTAL

SWITCH
239
409
359
442
paint_fov?
paint_fov?
0
1
-1000

SWITCH
239
446
360
479
draw_path?
draw_path?
0
1
-1000

BUTTON
361
446
464
479
clear-paths
ask tails [die]
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
361
406
461
439
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

SWITCH
492
1320
641
1353
collision_stop?
collision_stop?
0
1
-1000

SLIDER
252
306
425
339
speed2
speed2
0
15
2.0
0.1
1
m/s
HORIZONTAL

SLIDER
251
345
439
378
turning-rate2
turning-rate2
0
180
40.0
5
1
deg/s
HORIZONTAL

SLIDER
20
183
205
216
number-of-hunters
number-of-hunters
0
1000
70.0
10
1
NIL
HORIZONTAL

SWITCH
492
1286
611
1319
collisions?
collisions?
0
1
-1000

SLIDER
464
1164
637
1197
c
c
0
5
0.5
.25
1
NIL
HORIZONTAL

SWITCH
492
1356
655
1389
elastic_collisions?
elastic_collisions?
1
1
-1000

TEXTBOX
474
1144
689
1170
For Levy Distribution
11
0.0
1

TEXTBOX
249
392
464
418
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

SLIDER
265
226
441
259
vision-distance2
vision-distance2
0
200
20.0
1
1
m
HORIZONTAL

SLIDER
260
265
433
298
vision-cone2
vision-cone2
0
360
360.0
1
1
deg
HORIZONTAL

SLIDER
638
920
831
953
number-of-sanctuaries
number-of-sanctuaries
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
637
957
823
990
sanctuary-region-size
sanctuary-region-size
0
10
9.0
1
1
NIL
HORIZONTAL

SWITCH
636
883
868
916
random_sanctuary_position?
random_sanctuary_position?
0
1
-1000

MONITOR
454
130
639
175
Time of Arrival at Sanctuary
time-to-first-arrival
17
1
11

SWITCH
33
578
271
611
random_start_region_hunter?
random_start_region_hunter?
0
1
-1000

SLIDER
464
1204
611
1237
max_levy_time
max_levy_time
0
100
15.0
1
1
sec
HORIZONTAL

CHOOSER
25
126
189
171
selected_algorithm1
selected_algorithm1
"Alg A" "Alg B" "Levy" "VNQ" "Lie and Wait" "Standard Random" "Straight" "Move and Wait" "Move and Wait - Idiosyncratic"
2

CHOOSER
36
1148
222
1193
distribution_for_direction
distribution_for_direction
"uniform" "gaussian" "triangle"
0

CHOOSER
269
132
439
177
selected_algorithm_runner
selected_algorithm_runner
"Auto" "Manual Control"
0

TEXTBOX
36
1124
251
1150
for random walk algorithms
11
0.0
1

SLIDER
96
1288
272
1321
pre_flight_time_average
pre_flight_time_average
0
500
100.0
10
1
NIL
HORIZONTAL

SLIDER
278
1288
458
1321
pre_flight_time_stdev
pre_flight_time_stdev
0
50
30.0
5
1
NIL
HORIZONTAL

SLIDER
96
1328
271
1361
flight_time_average
flight_time_average
0
500
50.0
10
1
NIL
HORIZONTAL

SLIDER
278
1328
451
1361
flight_time_stdev
flight_time_stdev
0
50
10.0
5
1
NIL
HORIZONTAL

SLIDER
96
1372
269
1405
step_time_average
step_time_average
0
100
30.0
10
1
NIL
HORIZONTAL

SLIDER
278
1368
451
1401
step_time_stdev
step_time_stdev
0
50
15.0
5
1
NIL
HORIZONTAL

TEXTBOX
212
1264
512
1300
for VNQ & VQN algorithms 
11
0.0
1

SLIDER
250
1158
423
1191
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
256
1138
471
1164
for standard random walk
11
0.0
1

SWITCH
77
72
355
105
same_parameters_between_species?
same_parameters_between_species?
1
1
-1000

SWITCH
23
737
248
770
random_start_region_runner?
random_start_region_runner?
0
1
-1000

SWITCH
33
656
235
689
start_hunters_together?
start_hunters_together?
1
1
-1000

SWITCH
23
777
226
810
start_runners_together?
start_runners_together?
0
1
-1000

MONITOR
449
80
647
125
Time of First Runner Caught
time-of-first-runner-detected
17
1
11

TEXTBOX
278
113
466
136
Runners
11
0.0
1

TEXTBOX
25
107
213
130
Hunters
11
0.0
1

SWITCH
32
694
270
727
start_hunters_pointing_away?
start_hunters_pointing_away?
0
1
-1000

SLIDER
29
429
201
462
state-disturbance
state-disturbance
0
3
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
260
1526
479
1559
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
258
1576
494
1609
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
258
1632
439
1665
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
264
1686
465
1719
state-disturbance_head
state-disturbance_head
0
50
0.0
5
1
NIL
HORIZONTAL

MONITOR
90
1568
180
1613
Total Energy
total_velocity_squared
17
1
11

SWITCH
647
1003
791
1036
fog?
fog?
1
1
-1000

BUTTON
287
890
370
924
Forward
ask runners[ set inputs (list (speed2 * 0.1) 90 0)]
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
378
892
486
926
Diagonal Right
ask runners[ set inputs (list (0.1 * speed2 * 0.66) 45 0)]
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

BUTTON
172
892
270
926
Diagonal Left
ask runners[ set inputs (list (0.1 * speed2 * 0.66) 135 0)]
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
1

BUTTON
288
938
368
972
Reverse
ask runners[ set inputs (list (0.1 * speed2) 270 0)]
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
385
937
450
971
Right
ask runners[ set inputs (list (0.1 * speed2 * 0.833) 0 0)]
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
208
935
272
969
Left
ask runners[ set inputs (list (0.1 * speed2 * 0.833) 180 0)]
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
99
980
271
1014
Diagonal Left -Reverse
ask runners[ set inputs (list (0.1 * speed2 * 0.66) 225 0)]
NIL
1
T
OBSERVER
NIL
Z
NIL
NIL
1

BUTTON
400
984
585
1018
Diagonal Right - Reverse
ask runners[ set inputs (list (0.1 * speed2 * 0.66) 315 0)]
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
305
985
369
1019
Stop
ask runners[ set inputs (list (0) 90 0)]
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
399
1042
497
1076
Turn Right
ask runners[ set inputs (list (0) 90 10)]
NIL
1
T
OBSERVER
NIL
T
NIL
NIL
1

BUTTON
209
1038
298
1072
Turn Left
ask runners[ set inputs (list 0 90 -10)]
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

CHOOSER
513
194
732
239
Hunter_Setup
Hunter_Setup
"Random" "Inverted V" "Center Band" "Barrier" "Circle - Center" "Circle - Center - Facing Out" "Circle - Random" "Perfect Picket" "Imperfect Picket"
0

BUTTON
534
774
654
808
Follow Runner
follow runner (count sanctuaries)
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

SWITCH
547
302
708
335
can_distinguish?
can_distinguish?
0
1
-1000

SLIDER
663
442
844
475
west-east-wind
west-east-wind
0
10
0.0
0.2
1
m/s
HORIZONTAL

SLIDER
664
480
844
513
north-south-wind
north-south-wind
0
10
0.0
0.2
1
m/s
HORIZONTAL

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

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
true
0
Polygon -7500403 true true 150 0 120 15 105 30 90 105 90 165 90 195 90 240 105 270 105 270 120 285 150 300 180 285 210 270 210 255 210 240 210 210 210 165 210 105 195 30 180 15
Line -1 false 150 60 120 135
Line -1 false 150 60 180 135
Polygon -1 false false 150 60 120 135 180 135 150 60 150 165

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

circle 3
true
0
Circle -16777216 true false 0 0 300
Circle -7500403 true true 0 0 300
Polygon -1 true false 150 0 105 135 195 135 150 0
Rectangle -1 true false 55 171 250 246

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

dot
false
0
Circle -7500403 true true 90 90 120

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

ring
true
0
Circle -7500403 true true 0 0 300
Polygon -1 false false 150 0 135 150 165 150

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
Line -7500403 true 135 135 135 30
Circle -7500403 true true 0 0 300

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
  <experiment name="Comaparing_Algs" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50001"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>time-to-first-arrival</metric>
    <metric>time-of-first-runner-detected</metric>
    <enumeratedValueSet variable="selected_algorithm1">
      <value value="&quot;Lie and Wait&quot;"/>
      <value value="&quot;Straight&quot;"/>
      <value value="&quot;Levy&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="number-of-hunters" first="15" step="15" last="150"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="50"/>
  </experiment>
  <experiment name="Comaparing_Algs_Log_scale" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50001"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>time-to-first-arrival</metric>
    <metric>time-of-first-runner-detected</metric>
    <enumeratedValueSet variable="selected_algorithm1">
      <value value="&quot;Ambush&quot;"/>
      <value value="&quot;Straight&quot;"/>
      <value value="&quot;Levy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-hunters">
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
    </enumeratedValueSet>
    <steppedValueSet variable="seed-no" first="1" step="1" last="40"/>
  </experiment>
  <experiment name="Turbo_Pi" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50001"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>time-to-first-arrival</metric>
    <metric>time-of-first-runner-detected</metric>
    <enumeratedValueSet variable="selected_algorithm1">
      <value value="&quot;Alg A&quot;"/>
      <value value="&quot;Alg B&quot;"/>
      <value value="&quot;Standard Random&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="number-of-hunters" first="5" step="5" last="150"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="40"/>
  </experiment>
  <experiment name="Band_bottom_half" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="25001"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>time-to-first-arrival</metric>
    <metric>time-of-first-runner-detected</metric>
    <enumeratedValueSet variable="selected_algorithm1">
      <value value="&quot;Straight&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-hunters">
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
    </enumeratedValueSet>
    <steppedValueSet variable="seed-no" first="1" step="1" last="50"/>
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
