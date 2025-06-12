extensions [palette
            profiler]
;
; Variable
;
breed [ traps trap]
breed [ stags stag]
breed [ dogs dog]
breed [ old-dogs old-dog]
breed [cues cue]
breed [discs disc]
breed[ place-holders place-holder]
breed[ waypoints waypoint]
breed[ launch-points launch-point]

globals [ tick-delta
          n
          i
          time-of-stag-escape
          time-to-first-see-list
          time-of-stag-caught
          time-of-stag-stuck
          sr_patches
          end_flag
          score
          cue-x-out
          cue-y-out
          win-loss-list
          win-loss-val
          predicted_stag_state_list
          distance-between-stag-old-dog-list

         ]


traps-own [
          velocity
           angular-velocity   ;; angular velocity of heading/yaw
           true_velocity
           V
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           speed-w-noise
           turning-w-noise
           levy_time
           rand_turn
           step_count
           step_time
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           response_type
           fov-list-traps
           fov-list-traps-beacon
           detect_traps?
           detect_stags?
           detect_dogs?
           detect_old-dogs?
           fov-list-stags
           stuck_count
           idiosyncratic_val
           response_duration_count
           rand-head-distrbuance
           distance_traveled
           fov-list-patches
           stag_caught_flag
           temp-turning-val
           random_switch-timer
           alternating_procedure_val
           fov-list-traps-same1
           fov-list-traps-same2
           fov-list-traps-other1
           fov-list-traps-other2
           fov-list-dogs
           fov-list-old-dogs
           energy
           range_status
          ]
dogs-own [
          velocity
           angular-velocity   ;; angular velocity of heading/yaw
           true_velocity
           V
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           speed-w-noise
           turning-w-noise
           levy_time
           rand_turn
           step_count
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           response_type
           fov-list-traps
           detect_traps?
           detect_stags?
           detect_dogs?
           detect_old-dogs?
           fov-list-stags
           stuck_count
           idiosyncratic_val
           response_duration_count
           rand-head-distrbuance
           distance_traveled
           fov-list-patches
           stag_caught_flag
           temp-turning-val
           random_switch-timer
           alternating_procedure_val
           fov-list-traps-same1
           fov-list-traps-same2
           fov-list-traps-other1
           fov-list-traps-other2
           fov-list-dogs
           fov-list-old-dogs
           measured_stag_x-position_list
           measured_stag_y-position_list
           measured_stag_time_list
           predicted_stag_heading
           predicted_stag_speed
           predicted_stag_ang-velocity
           old_predicted_stag_heading
           predicted_stag_speed_list
           predicted_stag_ang-velocity_list
           viable_cues
           my_target
           energy
           range_status
          ]

old-dogs-own [
          velocity
           angular-velocity   ;; angular velocity of heading/yaw
           true_velocity
           V
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           speed-w-noise
           turning-w-noise
           levy_time
           rand_turn
           step_count
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           response_type
           fov-list-traps
           detect_traps?
           detect_stags?
           detect_dogs?
           detect_old-dogs?
           fov-list-stags
           stuck_count
           idiosyncratic_val
           response_duration_count
           rand-head-distrbuance
           distance_traveled
           fov-list-patches
           stag_caught_flag
           temp-turning-val
           random_switch-timer
           alternating_procedure_val
           fov-list-traps-same1
           fov-list-traps-same2
           fov-list-traps-other1
           fov-list-traps-other2
           fov-list-dogs
           fov-list-old-dogs
           measured_stag_x-position_list
           measured_stag_y-position_list
           measured_stag_time_list
           predicted_stag_heading
           predicted_stag_speed
           predicted_stag_ang-velocity
           old_predicted_stag_heading
           predicted_stag_speed_list
           predicted_stag_ang-velocity_list
           viable_cues
           my_target
           energy
           range_status
          ]


stags-own [
           velocity
           angular-velocity   ;; angular velocity of heading/yaw
           true_velocity
           V
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           rand-head-distrbuance
           speed-w-noise
           turning-w-noise
           levy_time
           rand_turn
           step_count
           step_time
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           response_type
           stag_caught_flag
           fov-list-stags
           fov-list-traps
           detect_stags?
           detect_dogs?
           detect_traps?
           detect_old-dogs?
           stuck_count
           idiosyncratic_val
           furthest_ycor
           response_duration_count
           fov-list-patches
           fov-list-dogs
           fov-list-old-dogs
           distance_traveled
           stag_target
           adversary_set
           adversary_set_warning
           adversary_set_minor_warning
           adversary_set_danger
           adversary_total_list
           body_width

          ]

patches-own [
            real-bearing-patch
            closest-trap-dist
          ]

discs-own [
            age
            my_turtle
            place
          ]

cues-own [
            age
            passed_flag
            dist-to-stag
            time-from-stag
          ]



;;
;; Initialization Procedures
;;

to setup
  clear-all
  random-seed seed-no

  set tick-delta 0.1 ; 10 ticks in one second

  set distance-between-stag-old-dog-list (list )

  ask patches ;set background color
    [
        ifelse abs(pycor) = max-pycor or abs(pxcor) = max-pxcor
        [
          set pcolor red
        ]
        [
          ifelse pycor = (min-pycor + 1 )
          [set pcolor green]
          [set pcolor white]
        ]


    ]

  ; create the set number of agents according to sliders in interface tab
  repeat number-of-stags [make_stag]
  repeat number-of-dogs [make_dog]
  repeat number-of-old-dogs [make_old-dog]

  create-launch-points 1 ; initalize launch point before deploying traps
  [
    setxy 0 (min-pycor + 15)
    set shape "circle"
    set size 1
    set color orange
  ]


  repeat number-of-traps [make_trap]


  ; specify what each type of agent can detect
  ask stags
  [
    ; set whether or not the stag can detect specific types of agents
    set detect_stags? false
    set detect_traps? false
    set detect_dogs? true
    set detect_old-dogs? true
  ]

  ask dogs
  [
    ; set whether or not the dog can detect specific types of agents
    set detect_traps? false
    set detect_stags? true
  ]

  ask old-dogs
  [
    ; set whether or not the old-dog can detect specific types of agents
    set detect_traps? false
    set detect_stags? true
  ]


  ask traps
  [
    ; set whether or not the trap can detect specific types of agents
    set detect_traps? false
    set detect_stags? false
  ]



  ; position traps and dogs according to selection in drop down choosers in interface tab
  trap_setup_strict
  dog_setup_strict
  old-dog_setup_strict


;  ask trap 1
;  [
;    setxy 0 0
;    set size 1
;    set heading 90
;  ]

  ask dogs ; calculate energy after setup
  [
   calculate_initial_energy
  ]

  ask old-dogs ; calculate energy after setup
  [
   calculate_initial_energy
  ]

  ask traps ; calculate energy after setup
  [
   calculate_initial_energy
  ]

  ; adds extra "ghost" turtles that make adding and removing agents during simulation  easier
  create-place-holders 25
  [
    setxy max-pxcor max-pycor
    ht
  ]

  ; adds extra turtles to show predicted path of stag if "lead_stag?" is on
  create-cues (80 * number-of-stags)
  [
    setxy max-pxcor max-pycor
    set shape "boat"
    set size 90 / meters-per-patch ; 90 meter length
    set color yellow
    set cue-x-out "N/A"
    set cue-y-out "N/A"

    set passed_flag 0

    ht
  ]


  if beacon_sensors?
  [
    ask traps
    [
     make_initial_beacon_sensing_display
    ]
  ]

  if auto_set? and count waypoints = 0
  [
    set_waypoint
  ]

  set-default-shape discs "ring"

  reset-ticks
end


;;
;; Runtime Procedures
;;
to go

  background_procedures ; for general functions like showing FOV and paths

  ask stags
    [
      ifelse selected_algorithm_stag = "Manual Control"
      [
        stag_procedure_manual
      ]
      [
;       stag_procedure
        smart_stag_procedure
;        smart_stag_procedure_P_control
      ]

      if distance min-one-of cues [distance myself] < (10 / meters-per-patch)
      [
        ask min-one-of cues [distance myself]
        [
          set passed_flag 1
        ]
      ]

     if distance min-one-of cues with [passed_flag = 0] [distance myself] > ([distancexy item 0 stag_target item 1 stag_target] of stag 0 / count cues)
       [
         predict_reachability_set2
       ]
    ]

 ask traps
    [
      trap_procedure
    ]

  ask dogs
    [
      dog_procedure
    ]

  ask old-dogs
    [
      old-dog_procedure
    ]

  ask launch-points
  [
  ht
  ]


  if dynamic_waypoint?
  [
    update_waypoint
  ]



  ask cues  with [passed_flag = 1]
  [
    ht
  ]

  measure_results

  if end_flag = 1 ; if any of the end conditions are met (stag escapes, stag is caught) it halts the simulation
  [
    ifelse time-of-stag-escape = 0
     [
       set win-loss-val 1
     ]
     [
       set win-loss-val 0
     ]
    stop
  ]

;  do-plots

  tick-advance 1
end


to background_procedures
 clear-paint

ifelse paint_fov?
  [
;    ask discs ; removes older discs to keep FOV display current
;      [
;         set age age + 1
;         if age = 1 [ die ]
;      ]

    ask traps
      [
        ifelse beacon_sensors?
        [beacon_sensing_display]
        [display_FOV]
      ]

    ask stags
      [
        display_FOV
      ]

    ask dogs
      [
        display_FOV
      ]

    ask old-dogs
      [
        display_FOV
      ]
  ]
  [
    ask discs [ht]
;    ask discs [die]
  ]

  ifelse draw_path?
  [
    ask stags [pd]
    ask traps [pd]
    ask dogs [pd]
    ask old-dogs [pd]
  ]
  [
    ask stags [pu]
    ask traps [pu]
    ask dogs [pu]
    ask old-dogs [pu]
  ]
end

to display_FOV ;procedure that uses fake agents to display FOV rather than painting patches (if the fov is certain values)

  let vision-dd 0
  let vision-cc 0

  (ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
  member? self stags
    [
      set vision-dd vision-distance-stags
      set vision-cc vision-cone-stags
    ]
  member? self dogs
    [
      set vision-dd vision-distance-dogs
      set vision-cc vision-cone-dogs
    ]
  member? self old-dogs
    [
      ifelse old-dog-algorithm = "Intercept"
      [
        set vision-dd vision-distance-dogs
        set vision-cc vision-cone-dogs
      ]
      [
        set vision-dd 0
        set vision-cc vision-cone-dogs
      ]
    ]

  )

  if count discs with [my_turtle = [who] of myself] = 0
  [
    (ifelse vision-cc = 360
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      vision-cc = 180
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          set shape "180-deg-fov"
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      vision-cc = 90
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          set shape "90-deg-fov"
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      vision-cc = 45
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          set shape "45-deg-fov"
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      vision-cc = 60
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          set shape "60-deg-fov"
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      vision-cc = 30
      [
        hatch-discs 1
        [
          set size 2 * (vision-dd / meters-per-patch)
          set heading ([heading] of myself)
          set shape "30-deg-fov"
          palette:set-transparency 70
          set my_turtle  [who] of myself
        ]
      ]
      [
        paint-patches-in-FOV
      ]
    )
  ]

  ask discs with [my_turtle = [who] of myself]
  [
    setxy ([xcor] of myself) ([ycor] of myself)
   set heading ([heading] of myself)
    st
  ]

end

to measure_results

    if time-of-stag-escape = 0
    [
      if count stags with [pycor <= ((min-pycor + 1) + (size / meters-per-patch) / 2)] > 0
      [set time-of-stag-escape ticks]
    ]

    if time-of-stag-caught = 0
    [
      if count traps with [stag_caught_flag = 1] > 0 or count dogs with [stag_caught_flag = 1] > 0 or count old-dogs with [stag_caught_flag = 1] > 0
      [set time-of-stag-caught ticks]
    ]

    if time-of-stag-stuck = 0
    [
      if [stuck_count] of stag 0 > 1000
      [set time-of-stag-caught ticks]
    ]


    if (time-of-stag-escape > 0) or  (time-of-stag-caught > 0) or (time-of-stag-stuck > 0)
     [set end_flag 1]

end



to stag_procedure
  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
   set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect

  ifelse response_duration_count > 0 ; if value is positive, it performs whatever the response is (i.e. if set to 'turn-away" it will make sure it turns in place for a full second even if it detects something else)
    [
      response_procedure ; if agent is detected, it stops everything and executes the desired algorithm for one second

      set response_duration_count (response_duration_count - 1) ;counts down
      set color red
    ]
    [
     ifelse length fov-list-traps > 0  or length fov-list-dogs > 0 or length fov-list-old-dogs > 0; if one or more traps/dogs are detected, it reacts according to whatever the selected algorithm is (default is to turn away)
       [
         set response_type "turn-away"
         set response_duration_count 1;
       ]
       [

;          ifelse ticks mod 1200 = 0 ; every 1200 ticks (120 seconds) the stag is "affected" by wind, changing its heading slightly
;            [
;              if random 100 < 50 ; if random value is less than 10 then the stag turns in a random direction for a short period of time (i.e. the stag turns randomly with a chance of 10 %)
;              [
;               choose_rand_turn
;               set response_type "Random Turn"
;               set response_duration_count (60 / tick-delta) ;perform response type for 10 second
;              ]
;            ]
;            [
            ;if nothing is detected, stag goes "to goal" which in this case means it goes to the Southern Edge
             go_to_south_goal
             set color red
;            ]



       ]
   ]



 update_agent_state; updates states of agents (i.e. position and heading)

end

to smart_stag_procedure

  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
   set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect


  set adversary_total_list (list )

  let vision-dd vision-distance-stags
  let vision-cc vision-cone-stags
  let nearest_hostile (max-one-of place-holders [distance myself])


  set adversary_total_list (sentence fov-list-dogs fov-list-old-dogs fov-list-traps)

  set adversary_set turtle-set map [b -> b] adversary_total_list

  let  danger_angle (2 * asin (2 * body_width / vision-dd)) ; calculation of how much the opening-angle should be to maintain a "safe margin" of 3 times the body width

  set adversary_set_danger adversary_set in-cone vision-dd danger_angle

  set adversary_set_warning adversary_set in-cone vision-dd 30

  set adversary_set_minor_warning adversary_set in-cone vision-dd 60

  (ifelse count adversary_set_danger > 0
  [
    set nearest_hostile min-one-of adversary_set_danger [distance myself]
    let nearest_hostile_bearing towards nearest_hostile - heading

    ifelse nearest_hostile_bearing < -180
      [
        set nearest_hostile_bearing nearest_hostile_bearing + 360
       ]
      [
        ifelse nearest_hostile_bearing > 180
        [set nearest_hostile_bearing nearest_hostile_bearing - 360]
        [set nearest_hostile_bearing nearest_hostile_bearing]
      ]

    ifelse (nearest_hostile_bearing) > 0
      [set inputs (list (speed-w-noise) 90(- turning-w-noise))]
      [set inputs (list (speed-w-noise) 90( turning-w-noise))]
  ]
  count adversary_set_warning > 0
  [
    set nearest_hostile min-one-of adversary_set_warning  [distance myself]
    let nearest_hostile_bearing towards nearest_hostile - heading

    ifelse nearest_hostile_bearing < -180
      [
        set nearest_hostile_bearing nearest_hostile_bearing + 360
       ]
      [
        ifelse nearest_hostile_bearing > 180
        [set nearest_hostile_bearing nearest_hostile_bearing - 360]
        [set nearest_hostile_bearing nearest_hostile_bearing]
      ]

    ifelse (nearest_hostile_bearing) > 0
      [set inputs (list (speed-w-noise) 90(- turning-w-noise * .75))]
      [set inputs (list (speed-w-noise) 90( turning-w-noise * .75))]
  ]
    count adversary_set_minor_warning > 0
  [
    set nearest_hostile min-one-of adversary_set_minor_warning  [distance myself]
    let nearest_hostile_bearing towards nearest_hostile - heading

    ifelse nearest_hostile_bearing < -180
      [
        set nearest_hostile_bearing nearest_hostile_bearing + 360
       ]
      [
        ifelse nearest_hostile_bearing > 180
        [set nearest_hostile_bearing nearest_hostile_bearing - 360]
        [set nearest_hostile_bearing nearest_hostile_bearing]
      ]

    ifelse (nearest_hostile_bearing) > 0
      [set inputs (list (speed-w-noise) 90(- turning-w-noise * .5))]
      [set inputs (list (speed-w-noise) 90( turning-w-noise * .5))]
  ]
  [
  go_to_south_goal
  ]
  )

  update_agent_state; updates states of agents (i.e. position and heading)





end


to smart_stag_procedure_P_control

  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
   set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect


  set adversary_total_list (list )

  let vision-dd vision-distance-stags
  let vision-cc vision-cone-stags
  let nearest_hostile (max-one-of place-holders [distance myself])


  set adversary_total_list (sentence fov-list-dogs fov-list-old-dogs fov-list-traps)

  set adversary_set turtle-set map [b -> b] adversary_total_list

  ifelse count adversary_set > 0
  [
    set nearest_hostile min-one-of adversary_set [distance myself]
    let nearest_hostile_bearing towards nearest_hostile - heading

    ifelse nearest_hostile_bearing < -180
      [
        set nearest_hostile_bearing nearest_hostile_bearing + 360
       ]
      [
        ifelse nearest_hostile_bearing > 180
        [set nearest_hostile_bearing nearest_hostile_bearing - 360]
        [set nearest_hostile_bearing nearest_hostile_bearing]
      ]

    ifelse (nearest_hostile_bearing) > 0
      [set inputs (list (speed-w-noise) 90(- turning-w-noise))]
      [set inputs (list (speed-w-noise) 90( turning-w-noise))]

    let reaction-turning-rate ((-1) * turning-w-noise * sign(nearest_hostile_bearing) * (1 - abs(nearest_hostile_bearing)/ (vision-cc)))

    set inputs (list (speed-w-noise) 90( reaction-turning-rate))

  ]

  [
  go_to_south_goal
  ]


  update_agent_state; updates states of agents (i.e. position and heading)


end

to stag_procedure_manual ; buttons control what the inputs of the stag is, this is here to make the stag actually use those inputs to move
  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
  set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect

  update_agent_state; updates states of agents (i.e. position and heading)

end


to trap_procedure
  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
  set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect




 ifelse constant_travel_range?
 [
   ifelse distance_traveled < 2000
   [ set range_status "not-empty"]
   [ set range_status "empty"]

 ]
 [
   ifelse energy > 0
   [ set range_status "not-empty"]
   [ set range_status "empty"]
 ]

ifelse range_status = "not-empty"
 [
 ifelse pcolor = red ; if the trap is outside of the environment (ie in the red zone) it starts trying to get back into the white area
   [
     get_back_in_bounds
   ]
   [
     select_alg_procedure ; this is chosen in interface tab and is what the traps do when not out of bounds
   ]
  ]
  [
    set inputs (list 0 90 0) ; stop moving
  ]




 update_agent_state; updates states of agents (i.e. position and heading)

 check_if_touching_stag

 if beacon_sensors?
  [update_beacon_sensor_location]

 calculate_remaining_energy

end

to calculate_remaining_energy
  let transit_distance 0
  let R_0 (1 / 36000) * tick-delta ; allows for 10 hours of loiter
  let R_1 (1 / 3600) * tick-delta ; allows for 1 hour of transit
  let R_2 (1 / 600 ) * tick-delta ; allows for 1/6 hours (10 min) of chase full speed

  let transit_speed (1.1 / meters-per-patch ) * tick-delta
  let chase_speed 5.5 / meters-per-patch * tick-delta

  if breed = traps
  [
    set transit_speed (1.1 / meters-per-patch ) * tick-delta
    set chase_speed 3.3 / meters-per-patch * tick-delta
  ]


  let energy_consumption_rate 0

  ifelse (item 0 inputs) * tick-delta = 0
    [
      set energy_consumption_rate R_0

    ]
    [
      set energy_consumption_rate (R_1 + ((R_2 - R_1)/(chase_speed - transit_speed)) * ((speed-w-noise * tick-delta) - transit_speed))
    ]

  let energy_used energy_consumption_rate


  set energy energy - energy_used


end

to calculate_initial_energy

  let transit_speed (1.1 / meters-per-patch ) * tick-delta

  if breed = traps
  [
    set transit_speed (1.1 / meters-per-patch ) * tick-delta
  ]


  let transit_distance (distance min-one-of launch-points [distance myself]) * meters-per-patch ; finds the distance from launch point and converts to meters

  let transit_energy_consumption transit_distance /  (1.1 * 3600)

  set energy energy - transit_energy_consumption



end


to dog_procedure
  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
  set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect

;  ifelse energy > 0
;   [ set range_status "not-empty"]
;   [ set range_status "empty"]

   ifelse range_status = "not-empty"
   [
     (ifelse dog-algorithm = "Intercept"
         [ intercept-updated]
       dog-algorithm = "Follow Waypoints"
         [follow_waypoints]
       dog-algorithm = "Follow Waypoints - Horizontally"
         [follow_waypoints_horizontally]
       dog-algorithm = "Decoy"
         [decoy]
      )
    ]
    [
    set inputs (list 0 90 0) ; stop moving
  ]

 update_agent_state; updates states of agents (i.e. position and heading)

 check_if_touching_stag

 calculate_remaining_energy

end

to old-dog_procedure
  ; setting the actuating and sensing variables every time step allows these values to be updated during the sim rather than only at the beginnning
  set_actuating_variables ;does the procedure to set the speed,turning rate, and state-disturbance
  do_sensing ; does the sensing to detect whatever the stag is set to detect


 ifelse constant_travel_range?
 [
   ifelse distance_traveled < 5000
   [ set range_status "not-empty"]
   [ set range_status "empty"]

 ]
 [
   ifelse energy > 0
   [ set range_status "not-empty"]
   [ set range_status "empty"]
 ]

   ifelse range_status = "not-empty"
   [
     (ifelse old-dog-algorithm = "Intercept"
       [ intercept-updated]
      old-dog-algorithm = "Follow Waypoints"
       [follow_waypoints]
      old-dog-algorithm = "Follow Waypoints - Horizontally"
       [follow_waypoints_horizontally]
      old-dog-algorithm = "Decoy"
       [decoy]
      )
    ]
    [
    set inputs (list 0 90 0) ; stop moving
    ]


 update_agent_state; updates states of agents (i.e. position and heading)

 check_if_touching_stag

 calculate_remaining_energy

end

to check_if_touching_stag ; checks to see if the agent is touching the ellipsoidal body of the stag
  let bearing_to_stag 0

  let my_x xcor
  let my_y ycor
  let my_size size

  let stag_x [xcor] of stag 0
  let stag_y [ycor] of stag 0
  let stag_heading [heading] of stag 0 ; 0 deg is pointing North
  set stag_heading (90 - stag_heading) ; updates heading to be in traditional cartestion coordiantes (0 deg is pointing East)
  let stag_major_axis_length [size] of stag 0  ; major axis is the length of stag which is 90m
  let stag_minor_axis_length ([size] of stag 0) / 6 ; minor axis is width of stag which is 15m or 16.6% if length

  let x_diff (my_x - stag_x)
  let y_diff (my_y - stag_y)

  if  not (x_diff = 0 and y_diff = 0)
  [set bearing_to_stag atan y_diff x_diff]

  let my_x_to_stag_frame ((x_diff * cos(stag_heading)) + (y_diff * sin (stag_heading)))
  let my_y_to_stag_frame ((-1 * x_diff * sin(stag_heading)) + (y_diff * cos (stag_heading)))

  let ellipse_eq ((my_x_to_stag_frame ^ 2) / (((stag_major_axis_length + my_size)/ 2)^ 2)) + ((my_y_to_stag_frame ^ 2) / (((stag_minor_axis_length + my_size)/ 2)^ 2))

  ifelse ellipse_eq <= 1
  [ set stag_caught_flag 1]
  [ set stag_caught_flag 0]

end



to intercept

  if length fov-list-stags > 0
  [
    ifelse length measured_stag_x-position_list > 100
      [
       set measured_stag_x-position_list remove-item 0 measured_stag_x-position_list
        set measured_stag_x-position_list lput ([xcor] of stag 0) measured_stag_x-position_list
       ]
      [
        set measured_stag_x-position_list lput ([xcor] of stag 0) measured_stag_x-position_list
      ]

    ifelse length measured_stag_y-position_list > 100
      [
       set measured_stag_y-position_list remove-item 0 measured_stag_y-position_list
        set measured_stag_y-position_list lput ([ycor] of stag 0) measured_stag_y-position_list
       ]
      [
        set measured_stag_y-position_list lput ([ycor] of stag 0) measured_stag_y-position_list
      ]

    ifelse length measured_stag_time_list > 100
      [
       set measured_stag_time_list remove-item 0 measured_stag_time_list
        set measured_stag_time_list lput (ticks) measured_stag_time_list
       ]
      [
        set measured_stag_time_list lput (ticks) measured_stag_time_list
      ]
  ]

  ifelse length measured_stag_x-position_list > 3
  [
    let delta-x (last measured_stag_x-position_list - item (length measured_stag_x-position_list - 2) measured_stag_x-position_list) / (last measured_stag_time_list - item (length measured_stag_time_list - 2) measured_stag_time_list)
    let delta-y (last measured_stag_y-position_list - item (length measured_stag_y-position_list - 2) measured_stag_y-position_list) / (last measured_stag_time_list - item (length measured_stag_time_list - 2) measured_stag_time_list)


    set predicted_stag_speed sqrt (delta-x ^ 2 + delta-y ^ 2)
    if not (delta-x = 0 and delta-y = 0)
      [set predicted_stag_heading atan delta-x delta-y]

    set predicted_stag_ang-velocity ((predicted_stag_heading - old_predicted_stag_heading) / (last measured_stag_time_list - item (length measured_stag_time_list - 2) measured_stag_time_list))

    set old_predicted_stag_heading predicted_stag_heading


  ]
  [
    set predicted_stag_speed 0
    set predicted_stag_heading 0
  ]

  ifelse length predicted_stag_speed_list > 100
    [
     set predicted_stag_speed_list remove-item 0 predicted_stag_speed_list
      set predicted_stag_speed_list lput predicted_stag_speed predicted_stag_speed_list
     ]
    [
      set predicted_stag_speed_list lput predicted_stag_speed predicted_stag_speed_list
    ]

  ifelse length predicted_stag_ang-velocity_list > 100
    [
     set predicted_stag_ang-velocity_list remove-item 0 predicted_stag_ang-velocity_list
      set predicted_stag_ang-velocity_list lput predicted_stag_ang-velocity predicted_stag_ang-velocity_list
     ]
    [
      set predicted_stag_ang-velocity_list lput predicted_stag_ang-velocity predicted_stag_ang-velocity_list
    ]


  if length measured_stag_x-position_list > 3
  [place-cues]

  let target_bearing (0) - heading



  ifelse lead_stag?
  [
;    let target-cue (max-one-of (cues with [[ycor] of self < [ycor] of stag 0]) [distance stag 0] )
    let target-cue min-one-of cues [abs(distance stag 0 - distance myself)]
    ask target-cue
    [set color blue]
    ifelse distance min-one-of stags [distance myself] < (0.5 * predicted_stag_speed * meters-per-patch)
    [
      set target_bearing (towards min-one-of stags [distance myself]) - heading
    ]
    [
      ifelse length measured_stag_x-position_list <= 3
      [
        set target_bearing (0) - heading
      ]
      [
        set target_bearing (towards target-cue ) - heading

      ]
    ]
  ]
  [
    set target_bearing (towards min-one-of stags [distance myself]) - heading
  ]

  ifelse length measured_stag_x-position_list > 3
      [
        ifelse target_bearing < -180
          [
            set target_bearing target_bearing + 360
           ]
          [
            ifelse target_bearing > 180
            [set target_bearing target_bearing - 360]
            [set target_bearing target_bearing]
          ]

        (ifelse ((target_bearing) > -1 and target_bearing < 1)
          [set inputs (list (speed-w-noise) 90 0)]
          (target_bearing) > 1
          [set inputs (list (speed-w-noise) 90 turning-w-noise)]
          (target_bearing) < -1
          [set inputs (list (speed-w-noise) 90 (- turning-w-noise))])
      ]
      [
        set inputs (list (0) 90 (0))
      ]

end

to intercept-updated

  let target_bearing (0) - heading

  let my_speed speed-w-noise * tick-delta

  set my_target min-one-of stags [distance myself]



  ifelse lead_stag?
  [
    set viable_cues cues with [ time-from-stag  > distance myself / my_speed]
    ask viable_cues
    [
      set color blue
    ]

    ifelse count viable_cues > 0
    [
;      set my_target min-one-of viable_cues [who]
;      set my_target max-one-of viable_cues [time-from-stag - (distance myself / my_speed) ]
;      set my_target min-one-of viable_cues [abs((distance myself / my_speed) - time-from-stag)]
       set my_target min-one-of viable_cues [distance myself]
    ]
    [
       set my_target min-one-of cues [distance myself]
    ]

    ask my_target
    [
      set color green
    ]

  ]
  [

      set my_target min-one-of stags [distance myself]
  ]

  set target_bearing towards my_target - heading


  ifelse target_bearing < -180
   [
     set target_bearing target_bearing + 360
    ]
   [
     ifelse target_bearing > 180
     [set target_bearing target_bearing - 360]
     [set target_bearing target_bearing]
   ]

 (ifelse ((target_bearing) > -1 and target_bearing < 1)
   [set inputs (list (speed-w-noise) 90 0)]
   (target_bearing) > 1
   [set inputs (list (speed-w-noise) 90 turning-w-noise)]
   (target_bearing) < -1
   [set inputs (list (speed-w-noise) 90 (- turning-w-noise))])


  if distance my_target < (3 / meters-per-patch)
  [
    set inputs (list 0 90 0)
  ]

end


to place-cues

  set i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

  let max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

  let current-x last measured_stag_x-position_list
  let current-y last measured_stag_y-position_list
  let current-heading predicted_stag_heading

  let predicted_speed mean predicted_stag_speed_list
  let predicted_ang-velocity mean predicted_stag_ang-velocity_list

  while [i < (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count cues + count waypoints)]
    [
      ask cue i
      [
        set color yellow
        st
        let cue-x 0
        let cue-y 0
        let cue-heading 0

        ifelse abs predicted_ang-velocity < 0.0001
        [
         set cue-heading current-heading + (predicted_ang-velocity * meters-per-patch * (i - max_i + 1))
         set cue-x current-x + (predicted_speed * sin(cue-heading) * meters-per-patch * (i - max_i + 1)) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
         set cue-y current-y + (predicted_speed * cos(cue-heading)* meters-per-patch * (i - max_i + 1))

        ]
        [

        let x_c current-x + (predicted_speed / (predicted_ang-velocity * pi / 180)) * cos(current-heading)
        let y_c current-y - (predicted_speed / (predicted_ang-velocity * pi / 180)) * sin(current-heading)


        set cue-heading current-heading + (predicted_ang-velocity * meters-per-patch * (i - max_i + 1))
        set cue-x x_c + ((predicted_speed / (predicted_ang-velocity * pi / 180)) * sin(cue-heading - 90)) ;* 100 * (i - (count stags + count traps + count dogs + count old-dogs) + 1)) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
        set cue-y y_c + ((predicted_speed / (predicted_ang-velocity * pi / 180)) * cos(cue-heading - 90) );* 100 * (i - (count stags + count traps + count dogs + count old-dogs) + 1))
        ]



        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading
      ]
      set i (i + 1)
    ]
  set cue-x-out "N/A"
  set cue-y-out "N/A"


end


to find_stag_reachable_set
  let distance-remaining [distancexy item 0 stag_target item 1 stag_target] of stag 0

  let number-of-predictions 5
  let p 0

  let prediction-spacing distance-remaining / number-of-predictions

  let prediction-spacing_time (prediction-spacing / (speed-stags / meters-per-patch * tick-delta))



  set i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

  let max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

  let current-x [xcor] of stag 0
  let current-y [ycor] of stag 0
  let current-heading [heading] of stag 0

  let max_speed speed-stags * tick-delta / meters-per-patch
;  let current_ang-velocity [turning-w-noise] of stag 0

  let max-ang-velocity turning-rate-stags * tick-delta


  while [i < (max_i + (count cues)/ 3)] ; positions the cues if the stag goes only straight
    [
      ask cue i
      [
        set color red
        st
        let cue-heading current-heading
        let cue-x current-x
        let cue-y current-y
        let tt 0

        while [ tt < prediction-spacing_time ]
        [
          set cue-heading cue-heading + ((max-ang-velocity)  * (i - max_i + 1) * 1)
          set cue-x cue-x + (max_speed * sin(cue-heading) * (i - max_i + 1) * 1) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
          set cue-y cue-y + (max_speed * cos(cue-heading) * (i - max_i + 1) * 1)



          set tt tt + 1
        ]



        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading

        ifelse i - max_i > 0
        [
        create-link-with cue (i - 1)
        ]
        [
          create-link-with stag 0
        ]
      ]
      set i (i + 1)
    ]
  set cue-x-out "N/A"
  set cue-y-out "N/A"

  set max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints + (count cues / 3))

  while [i < (max_i + count cues / 3)] ; positions the cues if the stag goes only straight
    [
      ask cue i
      [
        set color red
        st
        let cue-heading current-heading
        let cue-x current-x
        let cue-y current-y
        let tt 0

        while [ tt < prediction-spacing_time ]
        [
          set cue-heading cue-heading + ((- max-ang-velocity)  * (i - max_i + 1) * 1)
          set cue-x cue-x + (max_speed * sin(cue-heading) * (i - max_i + 1) * 1) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
          set cue-y cue-y + (max_speed * cos(cue-heading) * (i - max_i + 1) * 1)



          set tt tt + 1
        ]

        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading

        ifelse i - max_i > 0
        [
        create-link-with cue (i - 1)
        ]
        [
          create-link-with stag 0
        ]
      ]
      set i (i + 1)
    ]
  set cue-x-out "N/A"
  set cue-y-out "N/A"

  set max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints + (2 * count cues / 3))


  while [i < (max_i + (count cues / 3))] ; positions the cues if the stag goes only straight
    [
      ask cue i
      [
        set color red
        st
        let cue-heading current-heading
        let cue-x current-x
        let cue-y current-y
        let tt 0

        while [ tt < prediction-spacing_time ]
        [
          set cue-heading cue-heading + ((0)  * (i - max_i + 1) * 1)
          set cue-x cue-x + (max_speed * sin(cue-heading) * (i - max_i + 1) * 1) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
          set cue-y cue-y + (max_speed * cos(cue-heading) * (i - max_i + 1) * 1)



          set tt tt + 1
        ]

        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading

        ifelse i - max_i > 0
        [
        create-link-with cue (i - 1)
        ]
        [
          create-link-with stag 0
        ]
      ]
      set i (i + 1)
    ]
  set cue-x-out "N/A"
  set cue-y-out "N/A"


ask cues with [(who - (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)) mod 5 = 4]
  [
    set color blue

    create-links-with other cues with [(who - (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)) mod 5 = 4]

  ]



end

to predict_reachability_set
  let distance-remaining [distancexy item 0 stag_target item 1 stag_target] of stag 0

  let number-of-predictions (count cues)

  let prediction-spacing distance-remaining / number-of-predictions

  let prediction-spacing_time (prediction-spacing / (speed-stags / meters-per-patch * tick-delta))


  let current-x [xcor] of stag 0
  let current-y [ycor] of stag 0
  let current-heading [heading] of stag 0

  let predicted_x 0
  let predicted_y 0
  let predicted_heading 0

  let max_speed speed-stags * tick-delta / meters-per-patch
  let max-ang-velocity turning-rate-stags * tick-delta



  set i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

  let max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)


;  while [ tt < prediction-spacing_time ]
;  [
;    set predicted_heading predicted_heading + ((0)  * (i - max_i + 1) * 1)
;    set predicted_x predicted_x + (max_speed * sin(cue-heading) * (i - max_i + 1) * 1) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
;    set predicted_y predicted_y + (max_speed * cos(cue-heading) * (i - max_i + 1) * 1)
;
;    set tt tt + 1
;  ]





  while [i < (max_i + (count cues ))] ; positions the cues if the stag goes only straight
    [
      ask cue i
      [
        set color red
        palette:set-transparency ((i - max_i) * (100 / count cues))
        st

        let cue-heading current-heading
        let cue-x current-x
        let cue-y current-y

        if who != (max_i)
        [
         set cue-heading [heading] of cue (i - 1)
         set cue-x [xcor] of cue (i - 1)
         set cue-y [ycor] of cue (i - 1)

        ]

        let tt 0
        let cue-heading-offset 0
        let cue-turning-input 0
        set passed_flag 0

        while [ tt < prediction-spacing_time ]
        [


          set cue-heading cue-heading + (cue-turning-input  * (i - max_i + 1))
          set cue-x cue-x + (max_speed * sin(cue-heading) * (i - max_i + 1)) ;; i think the error is coming from this part becuase i am already calculateing future heading but then still multipling counter?
          set cue-y cue-y + (max_speed * cos(cue-heading) * (i - max_i + 1))

          set cue-heading-offset 180 - cue-heading

          ifelse cue-heading-offset < -180
          [
            set cue-heading-offset cue-heading-offset + 360
          ]
          [
            ifelse cue-heading-offset > 180
            [set cue-heading-offset cue-heading-offset - 360]
            [set cue-heading-offset cue-heading-offset]
          ]

          (ifelse ((cue-heading-offset) > -1 and cue-heading-offset < 1)
          [set cue-turning-input 0]
          (cue-heading-offset) > 1
          [set cue-turning-input max-ang-velocity]
          (cue-heading-offset) < -1
          [set cue-turning-input (- max-ang-velocity)])


          set tt tt + 1
        ]

        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading
;        print cue-heading

;        ifelse i - max_i > 0
;        [
;        create-link-with cue (i - 1)
;        ]
;        [
;          create-link-with stag 0
;        ]
      ]
      set i (i + 1)
    ]
  set cue-x-out "N/A"
  set cue-y-out "N/A"



end


to predict_reachability_set2
  let distance-remaining [distancexy item 0 stag_target item 1 stag_target] of stag 0

  let number-of-predictions 1;(count cues)

  let prediction-spacing distance-remaining / number-of-predictions

  let prediction-spacing_time (prediction-spacing / (speed-stags / meters-per-patch * tick-delta))

  set prediction-spacing_time  (prediction-spacing_time  - (prediction-spacing_time mod count cues))

  let current-x [xcor] of stag 0
  let current-y [ycor] of stag 0
  let current-heading [heading] of stag 0

  let predicted_x current-x
  let predicted_y current-y
  let predicted_heading current-heading
  let predicted_heading-offset 0
  let predicted-turning-input 0


  let max_speed speed-stags * tick-delta / meters-per-patch
  let max-ang-velocity turning-rate-stags * tick-delta

  let tt 0

  set predicted_stag_state_list (list )




  while [ tt < prediction-spacing_time ]
          [


            set predicted_heading predicted_heading + (predicted-turning-input )
            set predicted_x predicted_x + (max_speed * sin(predicted_heading) )
            set predicted_y predicted_y + (max_speed * cos(predicted_heading) )

            set predicted_heading-offset 180 - predicted_heading

            ifelse predicted_heading-offset < -180
            [
              set predicted_heading-offset predicted_heading-offset + 360
            ]
            [
              ifelse predicted_heading-offset > 180
              [set predicted_heading-offset predicted_heading-offset - 360]
              [set predicted_heading-offset predicted_heading-offset]
            ]

            (ifelse ((predicted_heading-offset) > -1 and predicted_heading-offset < 1)
            [set predicted-turning-input 0]
            (predicted_heading-offset) > 1
            [set predicted-turning-input max-ang-velocity]
            (predicted_heading-offset) < -1
            [set predicted-turning-input (- max-ang-velocity)])

            if tt mod (prediction-spacing_time / count cues) = 0
            [
              set predicted_stag_state_list lput (list predicted_x predicted_y predicted_heading)predicted_stag_state_list
            ]


            set tt tt + 1
          ]

   set i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

   let max_i (count stags + count launch-points + count traps + count dogs + count old-dogs + count place-holders + count waypoints)

   while [i < (max_i + (count cues ))]
    [
      ask cue i
      [
        set color red
        palette:set-transparency ( 100 * ((i - max_i) / count cues))
        st
        set passed_flag 0

        let cue_state_info item ( i - max_i) predicted_stag_state_list


        let cue-x (item 0 cue_state_info)
        let cue-y (item 1 cue_state_info)
        let cue-heading (item 2 cue_state_info)


        if cue-x > max-pxcor
         [
           set cue-x max-pxcor
           ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]

         ]

        if cue-x < min-pxcor
        [
          set cue-x min-pxcor
          ifelse cue-y-out = "N/A"
            [
              set cue-y-out cue-y
              set cue-y cue-y-out
            ]
            [set cue-y cue-y-out]
        ]

        if cue-y > max-pycor
         [
           set cue-y max-pycor
           ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
         ]

        if cue-y < min-pycor
        [
          set cue-y min-pycor
          ifelse cue-x-out = "N/A"
            [
              set cue-x-out cue-x
              set cue-x cue-x-out
            ]
            [set cue-x cue-x-out]
        ]

        setxy cue-x cue-y
        set heading cue-heading


        set dist-to-stag distance stag 0
        set time-from-stag (dist-to-stag / max_speed)


      ]
      set i i + 1

    ]
    set cue-x-out "N/A"
  set cue-y-out "N/A"


end




to select_alg_procedure

  if selected_algorithm_traps = "Standard Random"
  [standard_random_walk]

  if selected_algorithm_traps = "Levy"
  [real_levy]

  if selected_algorithm_traps = "Lie and Wait"
  [lie-and-wait]

  if selected_algorithm_traps = "Straight"
  [straight]

  if selected_algorithm_traps = "Follow Waypoints"
  [follow_waypoints]

  if selected_algorithm_traps = "Follow Waypoints - Horizontally"
  [follow_waypoints_horizontally]

end

; stag algorithm - - - - - - - - - - -
to go_to_south_goal ; stag attempts to drive its heading towards the south end of the environment

   ifelse shifting_stag_target?
   [
     if ticks mod 600 = 0 ; every 3000 ticks (300 seconds) the stag's target is moved slightly at random to mix up approach
     [set stag_target (list (xcor + (one-of (range (-1) (2) 1)) * (150 / meters-per-patch)) min-pycor) ]
   ]
   [
     set stag_target (list xcor min-pycor)
   ]

;   set stag_target (list xcor min-pycor)

   let stag_target_x item 0 stag_target
   let stag_target_y item 1 stag_target


   let target_bearing towardsxy stag_target_x stag_target_y - heading

      ifelse target_bearing < -180
        [
          set target_bearing target_bearing + 360
         ]
        [
          ifelse target_bearing > 180
          [set target_bearing target_bearing - 360]
          [set target_bearing target_bearing]
        ]

      (ifelse ((target_bearing) > -1 and target_bearing < 1)
        [set inputs (list (speed-w-noise) 90 0)]
        (target_bearing) > 1
        [set inputs (list (speed-w-noise) 90 turning-w-noise)]
        (target_bearing) < -1
        [set inputs (list (speed-w-noise) 90 (- turning-w-noise))])

end

to get_back_in_bounds ; dogs and traps attempts return to environment if they are in the outside zone (red)

   let target_bearing 0

   ifelse abs(abs(xcor) - max-pxcor) < abs(abs(ycor) - max-pycor)
   [
     ifelse xcor < 0
     [
       set target_bearing 90 - heading
     ]
     [
       set target_bearing 270 - heading
     ]
   ]
   [
     ifelse ycor < 0
     [
       set target_bearing 0 - heading
     ]
     [
       set target_bearing 180 - heading
     ]
   ]

      ifelse target_bearing < -180
        [
          set target_bearing target_bearing + 360
         ]
        [
          ifelse target_bearing > 180
          [set target_bearing target_bearing - 360]
          [set target_bearing target_bearing]
        ]

      (ifelse ((target_bearing) > -1 and target_bearing < 1)
        [set inputs (list (speed-w-noise) 90 0)]
        (target_bearing) > 1
        [set inputs (list (speed-w-noise) 90 turning-w-noise)]
        (target_bearing) < -1
        [set inputs (list (speed-w-noise) 90 (- turning-w-noise))])

end


; trap algorithms --------------

to straight ; go straight forwards
  set inputs (list speed-w-noise 90 0)
end

to lie-and-wait ; stay in place
      set inputs (list 0 90 0)
end

to standard_random_walk ;

  ifelse step_count < (step_length_fixed + idiosyncratic_val) ; while step count is less than the set step_length, it should either be turning in place or going straight
  [

    ifelse step_count < (1 / tick-delta) ; for the first 10 ticks of the "step", turn in place at a rate of rand_turn
     [
       set inputs (list (0) 90 rand_turn)
     ]
     [
      set inputs (list speed-w-noise 90 0) ; if nothing is detected, goes straight forward at a speed of speed-w-noise

     ]

    set step_count step_count + 1 ;counts up
  ]
  [
     choose_rand_turn ; at the end of the step, choose random turning rate
     set step_count 0 ; reset turning rate to zero
  ]

end


to real_levy  ;; classic levy that chooses direction at beginning of step and moves straight in that line. Step lengths are chosen from levy distribution

  ifelse step_count < step_time; while step count is less than the the randomly chosen step_length, it should either be turning in place or going straight
  [

    ifelse step_count < (1 / tick-delta) ; for the first 10 ticks of the "step", turn in place at a rate of rand_turn
     [
       set color blue
        set inputs (list (0) 90 rand_turn)
     ]
     [
       set color red
       set inputs (list speed-w-noise 90 0) ; if nothing is detected, goes straight forward at a speed of speed-w-noise
     ]

    set step_count step_count + 1 ;increment step count
  ]
  [
      ; at the end of the step, choose a new step length from levy distribution and choose random turning rate
       set step_time round (100 * (1 / (random-gamma 0.5 (c / 2  ))))
       while [step_time > round (max_levy_time / tick-delta)]
         [set step_time round (100 * (1 / (random-gamma 0.5 (c / 2 ))))]

       choose_rand_turn
       set step_count 0
  ]
end

to follow_waypoints

  if count waypoints > 0
  [
   let target (min-one-of waypoints [distance myself] )
   let target_y [ycor] of target
   let target_x [xcor] of target




   let target_bearing (towards target) - heading

   let target_dist distance target

   ifelse target_dist > 7 / meters-per-patch ; if the waypoint is within 7 meters (less than half of the stag width), the traps should stop
   [
     ifelse target_bearing < -180
     [
       set target_bearing target_bearing + 360
      ]
     [
       ifelse target_bearing > 180
       [set target_bearing target_bearing - 360]
       [set target_bearing target_bearing]
     ]


    ifelse (target_bearing) > 0
      [set inputs (list (speed-w-noise) 90 turning-w-noise)]
      [set inputs (list (speed-w-noise) 90 (- turning-w-noise))]
   ]
   [
     set inputs (list 0 90 0)
   ]


  ]

end

to follow_waypoints_horizontally

  if count waypoints > 0
  [
   let target (min-one-of waypoints [distance myself] )
   let target_y [ycor] of target
   let target_x [xcor] of target

   if target_y > ycor
   [
     set target_y ycor
   ]



   let target_bearing (towardsxy (target_x) (ycor)) - heading

   let target_dist distancexy (target_x) (ycor)

   ifelse target_dist > 3 / meters-per-patch ; if the waypoint is within 7 meters (less than half of the stag width), the traps should stop
   [
     ifelse target_bearing < -180
     [
       set target_bearing target_bearing + 360
      ]
     [
       ifelse target_bearing > 180
       [set target_bearing target_bearing - 360]
       [set target_bearing target_bearing]
     ]


    ifelse (target_bearing) > 0
      [set inputs (list (speed-w-noise) 90 turning-w-noise)]
      [set inputs (list (speed-w-noise) 90 (- turning-w-noise))]
   ]
   [
     set inputs (list 0 90 0)
   ]


  ]

end

to decoy
  set inputs (list 0 90 0)
end
to set_waypoint

  ask place-holder ((count stags + count launch-points + count traps + count dogs + count old-dogs + count waypoints))
  [  set breed waypoints
      st
      setxy ([xcor] of stag 0) 0




      set shape "x"
      set color orange
      set size 100 / meters-per-patch ; sets size to 10m
    ]

end

to update_waypoint
  if ticks mod (update_time / tick-delta) = 0
  [
    ask waypoints
    [
     setxy ([xcor] of stag 0) (([ycor] of stag 0 + min-pycor) / 2)
    ]
  ]
end
;
;
;-------------- Nested functions and Setup Procedures below--------------
;
;

to response_procedure
  let target (max-one-of place-holders [distance myself]);
  let hostile (max-one-of place-holders [distance myself])


   set target one-of stags

  if response_type = "turn-away"
    [
      if breed = stags
      [

        let total_list sentence fov-list-dogs fov-list-old-dogs

        if length total_list > 0
        [
          set hostile min-one-of turtle-set map [b -> b] total_list [distance myself]
        ]

      ]
      let hostile_bearing towards hostile - heading

      ifelse hostile_bearing < -180
        [
          set hostile_bearing hostile_bearing + 360
         ]
        [
          ifelse hostile_bearing > 180
          [set hostile_bearing hostile_bearing - 360]
          [set hostile_bearing hostile_bearing]
        ]

      ifelse (hostile_bearing) > 0
        [set inputs (list (speed-w-noise) 90(- turning-w-noise))]
        [set inputs (list (speed-w-noise) 90( turning-w-noise))]
     ]



    if response_type = "180-in-place"
    [
      set inputs (list (0) 90 180)
    ]

    if response_type = "stop"
      [
        set inputs (list (0) 90 0)
      ]

    if response_type = "Random Turn"
      [
        set inputs (list (speed-w-noise) 90 rand_turn)
      ]


    if response_type = "towards-target"
    [
      let target_bearing towards target - heading

      ifelse target_bearing < -180
        [
          set target_bearing target_bearing + 360
         ]
        [
          ifelse target_bearing > 180
          [set target_bearing target_bearing - 360]
          [set target_bearing target_bearing]
        ]


      ifelse (target_bearing) > 0
        [set inputs (list (speed-w-noise) 90 turning-w-noise)]
        [set inputs (list (speed-w-noise) 90 (- turning-w-noise))]
     ]

end

to choose_rand_turn
  let turning-rate-val 0
  if member? self traps
    [
      set turning-rate-val turning-rate-rw
    ]

  if member? self stags
    [
      set turning-rate-val turning-rate-stags
    ]

  if distribution_for_direction = "uniform"
  [set rand_turn (- turning-rate-val) + (random (2 * turning-rate-val + 1)) ]

  if distribution_for_direction = "gaussian"
  [ set rand_turn round (random-normal 0 (turning-rate-val / 3))]

  if distribution_for_direction = "triangle"
  [set rand_turn (random turning-rate-val) - (random turning-rate-val) ]
end


to set_actuating_variables
  if ticks mod 1 = 0
  [
    set rand-x random-normal 0 (state-disturbance_xy / meters-per-patch)
    set rand-y random-normal 0 (state-disturbance_xy / meters-per-patch)
    set rand-head-distrbuance random-normal 0 state-disturbance_head
  ]

  (ifelse member? self traps
  [
     set turning-w-noise random-normal (turning-rate-traps) noise-actuating-turning
     set speed-w-noise random-normal (speed-traps / meters-per-patch) (noise-actuating-speed)

  ]
  member? self stags
  [

    set speed-w-noise random-normal (speed-stags / meters-per-patch) (noise-actuating-speed)
    set turning-w-noise random-normal (turning-rate-stags) noise-actuating-turning

  ]
  member? self dogs
  [

    set speed-w-noise random-normal (speed-dogs / meters-per-patch) (noise-actuating-speed)
    set turning-w-noise random-normal (turning-rate-dogs) noise-actuating-turning

  ]
  member? self old-dogs
  [

    set speed-w-noise random-normal (speed-old-dogs / meters-per-patch) (noise-actuating-speed)
    set turning-w-noise random-normal (turning-rate-dogs) noise-actuating-turning

  ]
  )
end

to do_sensing

  ifelse detect_stags?
    [find-stags-in-FOV]
    [set fov-list-stags (list)]

  ifelse detect_traps?
    [find-traps-in-FOV ]
    [set fov-list-traps (list)]

  ifelse detect_dogs?
    [find-dogs-in-FOV ]
    [set fov-list-dogs (list)]

  ifelse detect_old-dogs?
    [find-old-dogs-in-FOV ]
    [set fov-list-old-dogs (list)]

end

to update_agent_state
  agent_dynamics


   set distance_traveled (distance_traveled + (item 0 inputs) * meters-per-patch * tick-delta)


   if breed != stags
   [
     do_collisions ;; temporarly removed collisions between defense to speed up sims
   ]

  let nxcor xcor + ( item 0 velocity * tick-delta  ) + (impact-x * tick-delta  ) + (rand-x * tick-delta  )
  let nycor ycor + ( item 1 velocity * tick-delta  ) + (impact-y * tick-delta  ) + (rand-y * tick-delta  )


  set true_velocity (list (( item 0 velocity) + (impact-x) + (rand-x )) (( item 1 velocity ) + (impact-y) + (rand-y )))
  set V sqrt ((item 0 true_velocity * item 0 true_velocity) + (item 1 true_velocity * item 1 true_velocity))

  ;; makes sure agents don't go through edge (if the calculated next position is more than the boundary, it just forces the agent to stay in place)
  if nxcor > max-pxcor or nxcor < min-pxcor
   [
     set nxcor xcor
     set nycor ycor
     set stuck_count stuck_count + 1
   ]

  if nycor > max-pycor or nycor < min-pycor
    [ set nycor ycor
      set nxcor xcor
      set stuck_count stuck_count + 1]

  setxy nxcor nycor

  let nheading heading + (angular-velocity * tick-delta  ) + (impact-angle * tick-delta ) + (rand-head-distrbuance * tick-delta)
  set heading nheading
end



to add_trap
  ask place-holder ((count stags + count launch-points + count traps + count dogs + count old-dogs))
  [  set breed traps
      st
      setxy 0.3 0

      place_traps

      set velocity [ 0 0 ]
      set angular-velocity 0
      set inputs [0 0 0]
      set fov-list-traps (list )
      set fov-list-traps-beacon (list )
      set fov-list-stags (list )

      set detect_stags? false
      set detect_traps? false
      set detect_dogs? false

      set response_type "turn-away"

    set random_switch-timer round random-normal 200 50



      set shape "circle 2"
      set color red
      set size 1 / meters-per-patch ; sets size to 1m
      set energy 1



     set levy_time 200
     set color red
    ]

    set number-of-traps (number-of-traps + 1)
end

to remove_trap
ask trap (count stags + count dogs + count old-dogs + count launch-points + count traps - 1)
  [
    set breed place-holders
    ht
  ]
  set number-of-traps (number-of-traps - 1)

end


to make_trap
  create-traps 1
    [
      set velocity [ 0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 1 / meters-per-patch ;1 meter diameter

      set fov-list-traps (list )
      set fov-list-traps-beacon (list )
      set fov-list-stags (list )
;      set fov-list-traps-same (list )


      place_traps


      set shape "circle 2"
      set color green


      set levy_time round (100 * (1 / (random-gamma 0.5 (c / 2  ))))
      while [levy_time > (max_levy_time / tick-delta)]
      [set levy_time round (100 * (1 / (random-gamma 0.5 (.5))))]
      choose_rand_turn
      set idiosyncratic_val round (random-normal 0 10)
      set energy 1

      set range_status "not-empty"

     set coll_angle2 0
     set detect_stags? false
     set detect_traps? false
     set detect_dogs? false
     set detect_old-dogs? false

    set response_type "turn-away"

    set random_switch-timer round random-normal 200 50

    ]
end

to make_dog
  create-dogs 1
    [
      set velocity [ 0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 2 / meters-per-patch;2 meter diameter


      set fov-list-traps (list )
      set fov-list-stags (list )
      set measured_stag_x-position_list (list )
      set measured_stag_y-position_list (list )
      set measured_stag_time_list (list )
      set predicted_stag_ang-velocity_list (list )
      set predicted_stag_speed_list (list )
;      set fov-list-traps-same (list )


      let txcor one-of (range (min-pxcor) (max-pxcor) 0.01)
      let tycor one-of (range (min-pycor) (0) 0.01)
      setxy txcor tycor


      set shape "dog"

      set energy 1
      set range_status "not-empty"


      set levy_time round (100 * (1 / (random-gamma 0.5 (c / 2  ))))
      while [levy_time > (max_levy_time / tick-delta)]
      [set levy_time round (100 * (1 / (random-gamma 0.5 (.5))))]
      choose_rand_turn
      set idiosyncratic_val round (random-normal 0 10)

      set color blue

     set coll_angle2 0
     set detect_stags? false
     set detect_traps? false
     set detect_dogs? false
     set detect_old-dogs? false

    set response_type "turn-away"

    set random_switch-timer round random-normal 200 50
    ]
end

to make_old-dog
  create-old-dogs 1
    [
      set velocity [ 0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 2 / meters-per-patch;2 meter diameter


      set fov-list-traps (list )
      set fov-list-stags (list )
      set measured_stag_x-position_list (list )
      set measured_stag_y-position_list (list )
      set measured_stag_time_list (list )
      set predicted_stag_ang-velocity_list (list )
      set predicted_stag_speed_list (list )
;      set fov-list-traps-same (list )


      let txcor one-of (range (min-pxcor) (max-pxcor) 0.01)
      let tycor one-of (range (min-pycor) (0) 0.01)
      setxy txcor tycor


      set shape "dog"
      set color violet

      set energy 1
      set range_status "not-empty"


      set levy_time round (100 * (1 / (random-gamma 0.5 (c / 2  ))))
      while [levy_time > (max_levy_time / tick-delta)]
      [set levy_time round (100 * (1 / (random-gamma 0.5 (.5))))]
      choose_rand_turn
      set idiosyncratic_val round (random-normal 0 10)


     set coll_angle2 0
     set detect_stags? false
     set detect_traps? false
     set detect_dogs? false
     set detect_old-dogs? false

    set response_type "turn-away"

    set random_switch-timer round random-normal 200 50
    ]
end

to make_stag
  create-stags 1
    [
      set velocity [0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 90 / meters-per-patch; 90m diameter
      set body_width 15 ; for calculations later on (doesn't actually affect the visual size of stag)

      set fov-list-traps (list )
      set fov-list-stags (list )
      set fov-list-dogs (list)
      set adversary_total_list (list )

      set furthest_ycor min-pycor

    let rand_x random-normal 0 6.5

    if rand_x > max-pxcor
    [set rand_x (max-pxcor - 0.15)]

    if rand_x < min-pxcor
    [set rand_x (min-pxcor + 0.15)]

    setxy (rand_x) ((max-pycor - 1)- (90 / meters-per-patch) / 2)

;    setxy start_stag_x ((max-pycor - 1)- (90 / meters-per-patch) / 2)

     set heading 180

      set shape "boat"


     set levy_time round (100 * (1 / (random-gamma 0.5 (c / 2  ))))
     while [levy_time > (max_levy_time / tick-delta)]
     [set levy_time round (100 * (1 / (random-gamma 0.5 (.5  ))))]
     choose_rand_turn
     set idiosyncratic_val round (random-normal 0 10)

     set color red
     set coll_angle2 0

      set detect_stags? false
      set detect_traps? false
      set detect_dogs? false
      set detect_old-dogs? false

      set response_type "turn-away"

      set stag_target (list xcor min-pycor)
    ]
end

to place_traps; defines region and/or orientation of where the traps should start
    if trap_setup = "Random - Uniform"
   [
      let tycor one-of (range (min-pycor + 1) (0) 0.01)
      let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)
      setxy txcor tycor
   ]

  if trap_setup = "Random - Gaussian"
   [
      let txcor random-normal 0 6.5
      let tycor random-normal -10 3.25

      while [txcor > (max-pxcor - 1) or txcor < (min-pxcor + 1)]
      [set txcor random-normal 0 6.5]

      while [tycor > 0 or tycor < (min-pycor + 1)]
      [set tycor random-normal -10 3.25]

      setxy txcor tycor
   ]

  if trap_setup = "Random - Inverse-Gaussian"
   [

      let txcor abs random-normal 0 6.5
      let sign3 one-of [-1 1]
      set txcor ( sign3 * (20 - txcor) )

      let tycor abs (random-normal -10 3.25 )
      let sign1 one-of [-1 1]
      set tycor -10 + ( sign1 * (10 - tycor) )

      if txcor > (max-pxcor - 1)
      [set txcor (max-pxcor - .1)]

      if txcor < (min-pxcor + 1)
      [set txcor (min-pxcor + .1) ]

      if tycor > 0
      [set tycor 0]

      if tycor < (min-pxcor + 1)
      [set tycor (min-pycor + .1) ]


      setxy txcor tycor
   ]

  if trap_setup = "Random - Gaussian near Launch Point"
   [
      let txcor random-normal ([xcor] of min-one-of launch-points [distance myself]) 6.5
      let tycor random-normal ([ycor] of min-one-of launch-points [distance myself]) 3.25

;      while [txcor > (max-pxcor - 1) or txcor < (min-pxcor + 1)]
;      [set txcor random-normal 0 6.5]
;
;      while [tycor > 0 or tycor < (min-pycor + 1)]
;      [set tycor random-normal -10 3.25]
;
;      while [distance min-one-of launch-points [distance myself] > (3000 / meters-per-patch)]
;      [
;        set txcor random-normal ([xcor] of min-one-of launch-points [distance myself]) 6.5
;        set tycor random-normal ([ycor] of min-one-of launch-points [distance myself]) 3.25
;      ]

      setxy txcor tycor
   ]



  if trap_setup = "Center Band"
   [
     let tycor one-of (range (-10) (0) 0.01)
     let txcor one-of (range (min-pxcor) (max-pxcor) 0.01)

     setxy txcor tycor
   ]

  if trap_setup = "Barrier"
   [
     let tycor one-of (range (-6) (0) 0.01)
     let txcor one-of (range (min-pxcor) (max-pxcor) 0.01)

     setxy txcor tycor

     ifelse  heading mod 2 = 0
       [
         set heading 90       ]
       [
         set heading 270
       ]
   ]


end


to trap_setup_strict; if you want to more precisely place the traps (i.e. trap 2 needs to be at position x, etc.)
  if trap_setup = "Imperfect Picket"
   [
     let j number-of-stags
     let jc number-of-stags

     while [j < number-of-stags + number-of-traps + number-of-dogs]
     [ask trap (j )
       [
         setxy ((j - jc) * (((max-pxcor - min-pxcor) / number-of-traps)) - (max-pxcor - min-pxcor) / 2) (0)

        if xcor > min-pxcor and xcor < max-pxcor
        [
          setxy (xcor + random-normal 0 0.5) (ycor + random-normal 0 0.5)
          set heading (0 + random-normal 0 10)
        ]

         setxy xcor (ycor + 0.01)
       ]
       set j j + 1
     ]
   ]

  if trap_setup = "Perfect Picket"
   [
     let j (count stags + count dogs + count old-dogs + count launch-points)
     let jc (count stags + count dogs + count old-dogs + count launch-points)

    let setup_range (max-pxcor - 1)  - (min-pxcor + 1)

     while [j < jc + number-of-traps]
     [ask trap (j )
       [
;         setxy ((j - jc) * (((max-pxcor - min-pxcor) / number-of-traps)) - (max-pxcor - min-pxcor) / 2) (0)
          setxy ((j - jc) * 1 * (setup_range / number-of-traps) + ((min-pxcor + 1) + setup_range / (number-of-traps * 2))) ([ycor] of min-one-of launch-points [distance myself])

        set heading 0

         setxy xcor (ycor + 0.01)
       ]

       set j j + 1
     ]
   ]

end

to dog_setup_strict; if you want to more precisely place the dogs (i.e. dog 2 needs to be at position x, etc.)

  let j number-of-stags
  let jc number-of-stags

  let setup_range (max-pxcor - 1)  - (min-pxcor + 1)

  while [j < number-of-stags  + number-of-dogs]
     [ask dog (j )
       [
;         setxy ((j - jc) * (((max-pxcor - min-pxcor) / number-of-dogs)) - (max-pxcor - min-pxcor) / 4) (-1)
          setxy ((j - jc) * 1 * (setup_range / number-of-dogs) + ((min-pxcor + 1) + setup_range / (number-of-dogs * 2))) (-1)

        set heading 0

         setxy xcor (ycor + 0.01)
       ]

       set j j + 1
     ]


end

to old-dog_setup_strict; if you want to more precisely place the dogs (i.e. dog 2 needs to be at position x, etc.)

  let j number-of-stags + number-of-dogs
  let jc number-of-stags + number-of-dogs
  let setup_range (max-pxcor - 1)  - (min-pxcor + 1)

  while [j < number-of-stags  + number-of-dogs + number-of-old-dogs]
     [ask old-dog (j )
       [
         setxy ((j - jc) * -1 * (setup_range / number-of-old-dogs) + ((max-pxcor - 1) - setup_range / (number-of-old-dogs * 2))) (-1)

        set heading 0

         setxy xcor (ycor + 0.01)
       ]

       set j j + 1
     ]


end

to do-plots
  set-current-plot "Distance from Old-Dog to Stag"
  set-current-plot-pen "default"

  set distance-between-stag-old-dog-list lput ([distance stag 0 ] of old-dog count stags ) distance-between-stag-old-dog-list

  plot [distance stag 0 ] of old-dog 1


end


to clear-paint
ask patches
    [
        ifelse abs(pycor) = max-pycor or abs(pxcor) = max-pxcor
        [
          set pcolor red
        ]
        [
          ifelse pycor = (min-pycor + 1 )
          [set pcolor green]
          [set pcolor white]
        ]
    ]
end


to agent_dynamics
  ; Reminder, each patch represents 0.1m, these values below are in terms of patches (i.e. 0.25 patches = 0.025m = 2.5cm)

  let body_v_x (item 0 inputs) * sin (item 1 inputs) ; forward speed
  let body_v_y (item 0 inputs) * -1 * cos( item 1 inputs) ; transversal speed
  let theta_dot (item 2 inputs) ; turning rate
  ; above is altered due to netlogo's definition of 0 deg (or 0 rad). heading of 0 is pointing straight north rather than east.
  ; and heading of 90 deg is east rather than north (i.e. increasing angle means going clockwise rather than counter-clockwise)

  let resultant_v sqrt(body_v_x ^ 2 + body_v_y ^ 2)

  ifelse body_v_x = 0 and body_v_y = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
  [set body_direct heading]
  [set body_direct atan body_v_y body_v_x]

                                                          ; In traditional coordinates
  let v_x resultant_v * sin(- body_direct + heading)   ; set v_x resultant_v * cos(- body_direct + heading)
  let v_y resultant_v * cos(- body_direct + heading )  ; set v_y resultant_v * sin(- body_direct + heading )
   ; above is altered due to netlogo's definition of 0 deg (or 0 rad). heading of 0 is pointing straight north rather than east.
  ; and heading of 90 deg is east rather than north (i.e. increasing angle means going clockwise rather than counter-clockwise)


  set velocity (list (v_x) (v_y) 0)
  set angular-velocity (theta_dot)
end



to do_collisions
if count other turtles with [breed != discs and  breed != cues and  breed != waypoints and breed != stags and breed != launch-points] > 0
      [
        let closest-turtle1 (max-one-of place-holders [distance myself])

        if  count traps > 1
        [
          ifelse count traps > 3
          [
            set closest-turtles (min-n-of 2 other turtles with [breed != discs and breed != cues and  breed != waypoints and breed != stags and breed != launch-points] [distance myself])

            set closest-turtle1 (min-one-of closest-turtles [distance myself])
            set closest-turtle2 (max-one-of closest-turtles [distance myself])
          ]
          [
            set closest-turtle1 (min-one-of other turtles with [breed != discs and breed != cues and  breed != waypoints and breed != stags and breed != launch-points] [distance myself])
          ]
        ]


        set closest-turtle closest-turtle1

        ifelse (distance closest-turtle ) < (size + ([size] of closest-turtle)) / 2
           [
              let xdiff item 0 target-diff
              let ydiff item 1 target-diff

              if closest-turtle2 != 0
              [
                let xdiff2 item 0 target-diff2
                let ydiff2 item 1 target-diff2
                set coll_angle2 (rel-bearing2 - (body_direct2))
                ifelse coll_angle2 < -180
                  [
                    set coll_angle2 coll_angle2 + 360
                   ]
                  [
                    ifelse coll_angle2 > 180
                    [set coll_angle2 coll_angle2 - 360]
                    [set coll_angle2 coll_angle2]
                  ]
              ]
              set body_direct2 (360 - body_direct)
              let coll_angle (body_direct2 - rel-bearing); - (90 - heading)); - (body_direct2))
;              let coll_angle (heading + body_direct2) - (rel-bearing)


              if body_direct2 > 180
              [
                set body_direct2 (body_direct2 - 360)
              ]

              ifelse coll_angle < -180
              [
                set coll_angle coll_angle + 360
               ]
              [
                ifelse coll_angle > 180
                [set coll_angle coll_angle - 360]
                [set coll_angle coll_angle]
              ]


              ifelse abs(coll_angle) < 90
              [
                set impact-x  (-1 * item 0 velocity)
                set impact-y  (-1 * item 1 velocity)

                set stuck_count stuck_count + 1
              ]
              [
               set impact-x 0
               set impact-y 0
               set impact-angle 0
              ]

              if closest-turtle2 != 0
              [
                if (distance closest-turtle2 ) < (size + ([size] of closest-turtle)) / 2
                [
                   if abs(coll_angle2) < 90
                   [
                     set impact-x  (-1 * item 0 velocity)
                     set impact-y  (-1 * item 1 velocity)
                   ]
                ]
              ]

                ]
          [
            set impact-angle 0
            set impact-x 0
            set impact-y 0
          ]
      ]
end

to find-stags-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  (ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    member? self stags
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]
    member? self dogs
    [
      set vision-dd vision-distance-dogs
    set vision-cc vision-cone-dogs
    ]
    member? self old-dogs
    [
      set vision-dd vision-distance-dogs
    set vision-cc vision-cone-dogs
    ]

    )
  set fov-list-stags (list )
  set i 0

  while [i < (count stags)]
    [
      if self != stag ((i )  )
        [
          let sub-heading towards stag (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]

          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (stag (i )) < (vision-dd / meters-per-patch));
           [
             set fov-list-stags fput (stag (i)) fov-list-stags
           ]
          ]
     set i (i + 1)
    ]

end

to find-dogs-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]

  set fov-list-dogs (list )
  set i (count stags)



  while [i < (count stags + count dogs )]
    [


      if self != dog ((i )  )
        [
          let sub-heading towards dog (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (dog (i )) < (vision-dd / meters-per-patch));
           [
             set fov-list-dogs fput (dog (i)) fov-list-dogs
           ]
        ]

     set i (i + 1)
      ]
end

to find-old-dogs-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]

  set fov-list-old-dogs (list )
  set i (count stags + count dogs)



  while [i < (count stags + count dogs + count old-dogs )]
    [


      if self != old-dog ((i )  )
        [
          let sub-heading towards old-dog (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (old-dog (i )) < (vision-dd / meters-per-patch));
           [
             set fov-list-old-dogs fput (old-dog (i)) fov-list-old-dogs
           ]
        ]

     set i (i + 1)
      ]
end

to find-traps-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]

  set fov-list-traps (list )
  set i (count stags + count dogs + count old-dogs + count launch-points)



  while [i < (count stags + count dogs + count old-dogs + count launch-points + count traps)]
    [


      if self != trap ((i )  )
        [
          let sub-heading towards trap (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (trap (i )) < (vision-dd / meters-per-patch));
           [
             set fov-list-traps fput (trap (i)) fov-list-traps
           ]
        ]

     set i (i + 1)
      ]
end


to beacon_sensing
   let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]

  set fov-list-traps-beacon (list )
  set i (count stags + count dogs + count old-dogs)



  while [i < (count stags + count dogs + count old-dogs + count launch-points + count traps)]
    [


      if self != trap ((i )  )
        [
          let sub-heading towards trap (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (trap (i )) < (vision-dd / meters-per-patch));
           [
             set fov-list-traps-beacon fput (trap (i)) fov-list-traps-beacon
           ]
        ]

     set i (i + 1)
      ]

end

to beacon_sensing_display

  let vision-dd 0
  let vision-cc 0

  (ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
  member? self stags
    [
      set vision-dd vision-distance-stags
      set vision-cc vision-cone-stags
    ]
  member? self dogs
    [
      set vision-dd vision-distance-dogs
      set vision-cc vision-cone-dogs
    ]
  member? self old-dogs
    [
      ifelse old-dog-algorithm = "Intercept"
      [
        set vision-dd vision-distance-dogs
        set vision-cc vision-cone-dogs
      ]
      [
        set vision-dd 0
        set vision-cc vision-cone-dogs
      ]
    ]

  )

    let number-of-beacon-sensors 12


  hatch-discs number-of-beacon-sensors
  [
    (ifelse vision-cc = 360
          [
             set size 2 * (vision-dd / meters-per-patch)
           ]

         vision-cc = 180
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "180-deg-fov"
             palette:set-transparency 50
         ]
         vision-cc = 90
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "90-deg-fov"
             palette:set-transparency 50
         ]
         vision-cc = 45
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "45-deg-fov"
             palette:set-transparency 50
         ]
         vision-cc = 60
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "60-deg-fov"
             palette:set-transparency 50
         ]
         vision-cc = 30
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "30-deg-fov"
             palette:set-transparency 50
         ])
  ]

    let irr  [size] of self
    let j [who] of max-one-of turtles [who]
    let jc [who] of max-one-of turtles [who]
    let heading_num 360 / (number-of-beacon-sensors)


    while [j > jc - number-of-beacon-sensors]
    [
     ask disc (j)
      [
        setxy (((irr * -1 * cos((j - jc) * heading_num + [heading] of myself)) + [xcor] of self)) ((irr * sin((j - jc) * heading_num - [heading] of myself) + [ycor] of self))
        set heading 180 + towards myself + [heading] of myself
      ]
      set j j - 1
    ]




end


to make_initial_beacon_sensing_display

  let vision-dd 0
  let vision-cc 0

  (ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
  member? self stags
    [
      set vision-dd vision-distance-stags
      set vision-cc vision-cone-stags
    ]
  member? self dogs
    [
      set vision-dd vision-distance-dogs
      set vision-cc vision-cone-dogs
    ]
  member? self old-dogs
    [
      ifelse old-dog-algorithm = "Intercept"
      [
        set vision-dd vision-distance-dogs
        set vision-cc vision-cone-dogs
      ]
      [
        set vision-dd 0
        set vision-cc vision-cone-dogs
      ]
    ]

  )

    let number-of-beacon-sensors 12


  hatch-discs number-of-beacon-sensors
  [
    (ifelse vision-cc = 360
          [
             set size 2 * (vision-dd / meters-per-patch)
           ]

         vision-cc = 180
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "180-deg-fov"
             palette:set-transparency 70
         ]
         vision-cc = 90
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "90-deg-fov"
             palette:set-transparency 70
         ]
         vision-cc = 45
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "45-deg-fov"
             palette:set-transparency 70
         ]
         vision-cc = 60
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "60-deg-fov"
             palette:set-transparency 70
         ]
         vision-cc = 30
         [
             set size 2 * (vision-dd / meters-per-patch)
             set shape "30-deg-fov"
             palette:set-transparency 70
         ])

    set my_turtle [who] of myself
  ]

    let irr  [size] of self
    let j [who] of max-one-of turtles [who] - number-of-beacon-sensors + 1
    let jc [who] of max-one-of turtles [who] - number-of-beacon-sensors + 1
    let jcc [who] of max-one-of turtles [who]
    let heading_num 360 / (number-of-beacon-sensors)


    while [j <= jcc]
    [
     ask disc (j)
      [
        set place (j - jc)
        setxy (((irr  * sin(place * heading_num + [heading] of myself)) + [xcor] of self)) ((irr * 1 * cos(place * heading_num +[heading] of myself) + [ycor] of self))
        set heading 180 + towards myself

        if place = 0
        [
         palette:set-transparency 10
        ]
      ]
      set j j + 1
    ]



end

to update_beacon_sensor_location
  let number-of-beacon-sensors 12
  let irr  [size] of self
  let heading_num 360 / (number-of-beacon-sensors)

  ask discs with [my_turtle = [who] of myself]
  [
    setxy (((irr  * sin(place * heading_num + [heading] of myself)) + [xcor] of myself)) ((irr * 1 * cos(place * heading_num +[heading] of myself) + [ycor] of myself))
    set heading 180 + towards myself
  ]


end



to paint-patches-in-FOV

  let vision-dd 0
  let vision-cc 0
  ifelse member? self traps
    [
      set vision-dd vision-distance-traps
      set vision-cc vision-cone-traps
    ]
    [
      set vision-dd vision-distance-stags
    set vision-cc vision-cone-stags
    ]



  set fov-list-patches (list )
  set i 0

  set fov-list-patches patches in-cone (vision-dd / meters-per-patch) (vision-cc) with [(distancexy-nowrap ([xcor] of myself) ([ycor] of myself) <= (vision-dd / meters-per-patch))  and pcolor != black]


  ask fov-list-patches
  [
      ifelse towards myself  > 180
      [
        let sub-heading (towards myself - 180) - [heading] of myself
        set real-bearing-patch sub-heading
        if sub-heading < 0
          [set real-bearing-patch sub-heading + 360]

        if sub-heading > 180
          [set real-bearing-patch sub-heading - 360]

        if real-bearing-patch > 180
          [set real-bearing-patch real-bearing-patch - 360]
      ]
      [
        let sub-heading (towards myself + 180) - [heading] of myself
        set real-bearing-patch sub-heading

        if sub-heading < 0
          [set real-bearing-patch sub-heading + 360]

        if sub-heading > 180
          [set real-bearing-patch sub-heading - 360]

        if real-bearing-patch > 180
          [set real-bearing-patch real-bearing-patch - 360]
      ]

    let current-closest-trap-distance distance myself


     if (real-bearing-patch < ((vision-cc / 2)) and real-bearing-patch > ((-1 * (vision-cc / 2))))
     [
      ifelse member? myself traps
      [
        set pcolor orange
;       set pcolor scale-color red current-closest-trap-distance 0 10 ; Adjust range as needed
      ]
      [set pcolor yellow]
     ]
  ]

end




to-report target-diff  ;; robot reporter
     report
    (   map
        [ [a q] -> a - q]
        (list
          [xcor] of closest-turtle
          [ycor] of closest-turtle)
        (list
          xcor
          ycor))

end

to-report target-diff2  ;; robot reporter
     report
    (   map
        [ [a q] -> a - q]
        (list
          [xcor] of closest-turtle2
          [ycor] of closest-turtle2)
        (list
          xcor
          ycor))
end


to-report rel-bearing
  let xdiff item 0 target-diff
  let ydiff item 1 target-diff
  let angle 0

  let cart-heading (90 - heading)

  ifelse cart-heading < 0
    [set cart-heading cart-heading + 360]
    [set cart-heading cart-heading]

  ifelse cart-heading > 180
    [set cart-heading cart-heading - 360]
    [set cart-heading cart-heading]

  set angle (atan ydiff xdiff)


  let bearing cart-heading - angle
  if bearing < -180
    [set bearing bearing + 360]
  report( bearing )
end

to-report rel-bearing2
  let xdiff2 item 0 target-diff2
  let ydiff2 item 1 target-diff2
  let angle2 0

  let cart-heading2 (90 - heading)

  ifelse cart-heading2 < 0
    [set cart-heading2 cart-heading2 + 360]
    [set cart-heading2 cart-heading2]

  ifelse cart-heading2 > 180
    [set cart-heading2 cart-heading2 - 360]
    [set cart-heading2 cart-heading2]

  if xdiff2 != 0 and ydiff2 != 0
    [set angle2 (atan ydiff2 xdiff2)]


  let bearing2 cart-heading2 - angle2
  if bearing2 < -180
    [set bearing2 bearing2 + 360]
  report( bearing2 )
end

to-report sign [x]
  if x > 0 [ report 1 ]
  if x < 0 [ report -1 ]
  report 0
end
@#$#@#$#@
GRAPHICS-WINDOW
914
70
1407
564
-1
-1
11.3
1
10
1
1
1
0
0
0
1
-21
21
-21
21
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
30.0
1
1
NIL
HORIZONTAL

SLIDER
13
315
236
348
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
11
352
220
385
vision-cone-traps
vision-cone-traps
0
360
30.0
5
1
deg
HORIZONTAL

SLIDER
17
240
196
273
speed-traps
speed-traps
0
10
3.3
1.1
1
m/s
HORIZONTAL

SLIDER
15
276
241
309
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
18
202
203
235
number-of-traps
number-of-traps
0
40
2.0
1
1
NIL
HORIZONTAL

SLIDER
244
668
417
701
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
254
648
469
674
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
943
11
1128
56
Time of Stag Escaping
time-of-stag-escape
17
1
11

SLIDER
245
708
392
741
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
21
148
264
193
selected_algorithm_traps
selected_algorithm_traps
"Lie and Wait" "Straight" "Standard Random" "Levy" "Follow Waypoints" "Follow Waypoints - Horizontally"
5

CHOOSER
248
748
434
793
distribution_for_direction
distribution_for_direction
"uniform" "gaussian" "triangle"
0

TEXTBOX
10
650
225
676
for random walk algorithms parameters
11
0.0
1

SLIDER
33
709
206
742
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
529
202
706
235
number-of-stags
number-of-stags
0
15
1.0
1
1
NIL
HORIZONTAL

SLIDER
521
343
740
376
vision-distance-stags
vision-distance-stags
0
4000
4000.0
100
1
m
HORIZONTAL

SLIDER
520
382
732
415
vision-cone-stags
vision-cone-stags
0
360
90.0
10
1
deg
HORIZONTAL

SLIDER
524
243
718
276
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
523
283
734
316
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
517
150
725
195
selected_algorithm_stag
selected_algorithm_stag
"Auto" "Manual Control" "Better-Auto"
1

MONITOR
1139
12
1309
57
Time of Stag Caught
time-of-stag-caught
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
"Random - Uniform" "Random - Gaussian" "Random - Inverse-Gaussian" "Barrier" "Random Group" "Perfect Picket" "Imperfect Picket" "Random - Gaussian near Launch Point"
5

BUTTON
575
614
658
648
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
575
661
655
695
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
585
711
649
745
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
667
661
765
695
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
474
665
563
699
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
478
592
856
611
Controls for 'selected_algorithm_stag' = Manual Control
11
0.0
1

SLIDER
32
670
206
703
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
42
752
192
770
for spiral algorithm
11
0.0
1

SLIDER
273
203
445
236
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
285
448
437
481
lead_stag?
lead_stag?
0
1
-1000

SLIDER
272
367
482
400
vision-distance-dogs
vision-distance-dogs
0
5000
5000.0
100
1
m
HORIZONTAL

SLIDER
272
409
464
442
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
273
242
445
275
speed-dogs
speed-dogs
0
10
5.5
.5
1
m/s
HORIZONTAL

SLIDER
273
279
482
312
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
10
1000
250.0
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
1316
28
1466
46
40 x 40 Patches
11
0.0
1

SWITCH
276
332
454
365
dog_local_sensing?
dog_local_sensing?
1
1
-1000

BUTTON
599
25
709
58
Set Waypoint
set_waypoint
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
714
26
830
59
auto_set?
auto_set?
0
1
-1000

SWITCH
735
79
888
112
dynamic_waypoint?
dynamic_waypoint?
0
1
-1000

SLIDER
759
126
893
159
update_time
update_time
5
300
20.0
5
1
sec
HORIZONTAL

SWITCH
732
205
896
238
shifting_stag_target?
shifting_stag_target?
0
1
-1000

SLIDER
741
708
919
741
number-of-old-dogs
number-of-old-dogs
0
30
3.0
1
1
NIL
HORIZONTAL

SLIDER
746
754
933
787
speed-old-dogs
speed-old-dogs
0
10
3.0
0.1
1
m/s
HORIZONTAL

CHOOSER
716
793
959
838
old-dog-algorithm
old-dog-algorithm
"Decoy" "Intercept" "Follow Waypoints" "Follow Waypoints - Horizontally"
1

TEXTBOX
785
240
858
285
adds a bit of disturbance to stag
11
0.0
1

SWITCH
327
156
491
189
beacon_sensors?
beacon_sensors?
1
1
-1000

SWITCH
622
444
802
477
constant_travel_range?
constant_travel_range?
0
1
-1000

SLIDER
579
550
751
583
start_stag_x
start_stag_x
-20
20
-4.0
0.1
1
NIL
HORIZONTAL

PLOT
1049
585
1249
735
Distance from Old-Dog to Stag
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

CHOOSER
289
493
491
538
dog-algorithm
dog-algorithm
"Decoy" "Intercept" "Follow Waypoints" "Follow Waypoints - Horizontally"
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
    <metric>win-loss-val</metric>
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
    <metric>win-loss-val</metric>
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
  <experiment name="scoring_only_traps_waypoints" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="14500"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>win-loss-val</metric>
    <enumeratedValueSet variable="selected_algorithm_traps">
      <value value="&quot;Follow Waypoints&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="speed-traps" first="3" step="1" last="5"/>
    <enumeratedValueSet variable="Trap_Setup">
      <value value="&quot;Random - Uniform&quot;"/>
      <value value="&quot;Random - Gaussian&quot;"/>
      <value value="&quot;Random - Inverse-Gaussian&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="number-of-traps" first="5" step="5" last="40"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="10"/>
  </experiment>
  <experiment name="scoring_traps-and-old-dogs_waypoints" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="14500"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>win-loss-val</metric>
    <enumeratedValueSet variable="old-dog-algorithm">
      <value value="&quot;Decoy&quot;"/>
      <value value="&quot;Follow Waypoints - Horizontally&quot;"/>
      <value value="&quot;Intercept&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="number-of-old-dogs" first="0" step="1" last="5"/>
    <steppedValueSet variable="number-of-traps" first="5" step="5" last="40"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="25"/>
  </experiment>
  <experiment name="old-dog-capture-region" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="14500"/>
    <exitCondition>end_flag &gt; 0</exitCondition>
    <metric>win-loss-val</metric>
    <steppedValueSet variable="number-of-old-dogs" first="1" step="1" last="5"/>
    <steppedValueSet variable="start_stag_x" first="-20" step="0.5" last="20"/>
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
