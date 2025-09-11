extensions [palette
            matrix]
;
; Variable
;
breed [ robots robot]
breed [ sobots sobot]
breed [centroids centroid]
breed [tails tail]
breed [discs disc]
breed[ place-holders place-holder]

globals [ tick-delta
          n
          i
          rand-xcor
          rand-ycor
          end_flag
          sim_ran_count
          circliness_list
          circliness
          stable_phase
          stability_val
          old_circliness_avg
          phase
          growth_val
          shrink_val
          V-sum
          avg-speeds
          radius_list
          old_radius
          GM
          AM
          DM
          rank
          LapM
          c-mat
          groups
          group1
          alg-con
          deg
          val
          num-of-groups
          milling_val
          scatter-sum
          momentum-sum
          ang-momentum
          group-rot-sum
          group-rot
          rad_var_comp_sum
          scatter
          outer_radius_size
          rad_var
          scatter_indiv
          rad_var_comp1_sum
          rad_var_comp1_mean
          rad_var_comp1_mean_sub
          rad_var_comp1
          rad_var_comp2
          momentum_indiv
          rot_indiv
          dist-to-closest-sum
          dist-to-closest-avg
          dist-to-closest-std-sum
          rad_var_list
          group-rot_list
          ang-momentum_list
          scatter_list
          outer_radius_size_list
          alg-con_list
          num-of-groups_list
          group-stability_list
          circliness_list_list
          v_avg_list
          dist-to-closest-standard-dev
          diffusion_list
          diffusion_val
          combined_phase
          combined_stability_val
         ]


robots-own [
          velocity
           angular-velocity   ;; angular velocity of heading/yaw
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           speed-w-noise
           turning-w-noise
           mass
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           detection_response_type
           fov-list-robots
           fov-list-sanctuaries
           fov-list-green-robots
           detect_sanctuaries?
           detect_robots?
           detect_drugboats?
           detect_sobots?
           fov-list-drugboats
           stuck_count
           idiosyncratic_val
           detect_step_count
           sleep_timer
           rand-head-distrbuance
           distance_traveled
           energy
           ricky_energy
           fov-list-patches
           sanctuary_detected_flag
           drugboat_caught_flag
;           body_v_x
;           body_v_y
           temp-turning-val
           random_switch-timer
           alternating_procedure_val
           fov-list-robots-same1
           fov-list-robots-same2
           fov-list-robots-other1
           fov-list-robots-other2
           caught-flag
           t_s
           s
           s_old
           omega_val
           omega
           wait_flag
           true_velocity
           V
           dist-to-closest
           my-dist-to-closest-std
           fov-list-sobots
          ]
sobots-own [
          velocity
           angular-velocity   ;; angular velocity of heading/yaw
           inputs             ;; input forces
           closest-turtle     ;; closest target
           impact-x
           impact-y
           impact-angle
           rand-x
           rand-y
           speed-w-noise
           turning-w-noise
           mass
           closest-turtles
           closest-turtle2
           body_direct
           body_direct2
           coll_angle2
           detection_response_type
           fov-list-robots
           fov-list-sanctuaries
           fov-list-green-robots
           detect_sanctuaries?
           detect_robots?
           detect_drugboats?
           detect_sobots?
           fov-list-drugboats
           stuck_count
           idiosyncratic_val
           detect_step_count
           sleep_timer
           rand-head-distrbuance
           distance_traveled
           energy
           ricky_energy
           fov-list-patches
           sanctuary_detected_flag
           drugboat_caught_flag
;           body_v_x
;           body_v_y
           temp-turning-val
           random_switch-timer
           alternating_procedure_val
           fov-list-robots-same1
           fov-list-robots-same2
           fov-list-robots-other1
           fov-list-robots-other2
           caught-flag
           t_s
           s
           s_old
           omega_val
           omega
           wait_flag
           true_velocity
           V
           dist-to-closest
           my-dist-to-closest-std
           fov-list-sobots
          ]

centroids-own
          [
            cc-rad
            ic-rad
          ]

patches-own [
            real-bearing-patch
            closest-robot-dist
          ]

discs-own [
            age
          ]




;;
;; Setup Procedures
;;
to setup
  clear-all
  random-seed seed-no


  set tick-delta 0.025 ; 10 ticks in one second

  let gr (range  -45 45 1)

  set rand-xcor one-of gr
  set rand-ycor one-of gr

  while [rand-ycor < (- rand-xcor )]
    [
      set rand-xcor one-of gr
     set rand-ycor one-of gr
    ]

  initialize_lists

  ask patches
    [
       set pcolor white
    ]




  set n number-of-robots

  while [n > 0]
  [
   make_robot
   set n (n - 1)
  ]

  let n-sobot number-of-sobots

  while [n-sobot > 0]
  [
   make_sobot
   set n-sobot (n-sobot - 1)
  ]




   robot_setup_strict
  sobot_setup_strict

 create-centroids 1
  [ 
    setxy 0 0
    set size 1
    set color violet
    set shape "circle"
    set cc-rad 3
    set ic-rad 1
   ]

  ; adds extra "ghost" turtles that make adding and removing agents during simulation a bit easier
  create-place-holders 20
  [
    setxy max-pxcor max-pycor
    ht
  ]

  set-default-shape discs "ring"

  reset-ticks
end

to initialize_lists

  set circliness_list (list )
  set rad_var_list (list )
  set group-rot_list (list )
  set ang-momentum_list (list )
  set scatter_list (list )
  set radius_list (list )
  set diffusion_list (list)


  set outer_radius_size_list (list )
  set circliness_list_list (list )
  set alg-con_list (list )
  set num-of-groups_list (list )
  set group-stability_list (list )
  set v_avg_list (list )


  set DM matrix:make-constant number-of-robots number-of-robots 0
  set AM matrix:make-constant number-of-robots number-of-robots 0
  set GM matrix:make-constant number-of-robots number-of-robots number-of-robots

end

;;
;; Runtime Procedures
;;
to go

  background_procedures ; for general functions like showing FOV

 ask centroids
   [ 
     resize
     ht 
   ]

 ask robots
    [
        set detect_robots? true
        set detect_sobots? true

         robot_procedure
      ]

   ask sobots
    [
        set detect_robots? true
        set detect_sobots? true

         sobot_procedure
      ]


  classify_behavior


  do-plots


  if end_flag = 1
  [
    ifelse loop_sim?
     [
       set seed-no (seed-no + 1)
       setup
     ]
     [
       stop
     ]

  ]

  if count robots > 1
  [
    find_adj_matrix
  ]

  if combined_stability_val > 3000
  [
    set end_flag  1

  ]


  tick-advance 1
end

to do-plots

  set-current-plot "Circliness"
  set-current-plot-pen "circliness"
  plot circliness

  set-current-plot "Milling Radius"
  set-current-plot-pen "cc-rad"
  plot mean [cc-rad] of centroids
end

to resize
  let minx (min [xcor] of robots) 
  let maxx (max [xcor] of robots)

  let miny (min [ycor] of robots)
  let maxy (max [ycor] of robots)

  let centerx mean [xcor] of robots
  let centery mean [ycor] of robots

  setxy centerx centery

  set cc-rad ([distance myself] of max-one-of robots [distance myself])
  set ic-rad ([distance myself] of min-one-of robots [distance myself])

end



to score_procedure

 background_procedures ; for general functions like showing FOV

 ask centroids
   [
     resize 
     ht 
   ]


 ask robots
    [
      robot_procedure
    ]

  classify_behavior


  do-plots

  if end_flag < num-of-runs  and ticks > 0 and stability_val > 300
  [
    set end_flag end_flag + 1
    set seed-no seed-no + 1

;    if sim_ran_count > (num-of-runs - 1)
;    [
;     stop
;    ]

    pseudo-setup

  ]

  tick-advance 1

end

to pseudo-setup
  ct
  random-seed seed-no

  set end_flag 0

  let gr (range  -25 25 1)

  set rand-xcor one-of gr
  set rand-ycor one-of gr

  clear-drawing


  set n number-of-robots
  while [n > 0]
  [
   make_robot
   set n (n - 1)
  ]

   robot_setup_strict

   create-centroids 1
  [ 
    setxy 0 0
    set size 1
    set color white
    set shape "circle"
    set cc-rad 3
    set ic-rad 1
   ]

  ; adds extra "ghost" turtles that make adding and removing agents during simulation a bit easier
  create-place-holders 20
  [
    setxy max-pxcor max-pycor
    ht
  ]

  set-default-shape discs "ring"

  reset-ticks

end



to robot_procedure
  set_actuating_and_extra_variables ;does the procedure to set the speed and turning rate etc.
  do_sensing ; does the sensing to detect whatever the robot is set to detec


  ifelse length fov-list-sobots > 0 or length fov-list-robots > 0
  [
    set s 1
  ]
  [
    set s 0
  ]


  (ifelse algorithm-robot = "Milling"
    [
  ;; Milling Alg
     ifelse s = 1
     [
       set omega turning-rate1
     ]
     [
      set omega (-1 * turning-rate1)
     ]

     set inputs (list speed-w-noise 90 (- omega))
    ]
    algorithm-robot = "Diffusing"
    [

  ;; Diffusion Alg

     ifelse s = 1
     [
      set inputs (list speed-w-noise 270 0)
     ]
     [
      set inputs (list 0 90 (turning-rate1))
     ]
    ]
    algorithm-robot = "Diffusing2"
    [

  ;; Diffusion Alg 2

     ifelse s = 1
     [
      set inputs (list speed-w-noise 90 (2 * turning-rate1))
     ]
     [
      set inputs (list speed-w-noise 90 (turning-rate1))
     ]
    ]
    algorithm-robot = "Clustering"
    [

  ;; Clustering Alg

     ifelse s = 1
     [
      set inputs (list speed-w-noise 90 0)
     ]
     [
      set inputs (list 0 90 (turning-rate1))
     ]
    ]
    )


 update_agent_state; updates states of agents (i.e. position and heading)

  set s_old s

end

to sobot_procedure
  set_actuating_and_extra_variables ;does the procedure to set the speed and turning rate etc.
  do_sensing ; does the sensing to detect whatever the sobot is set to detec


  ifelse length fov-list-sobots > 0 or length fov-list-robots > 0
  [
    set s 1
  ]
  [
    set s 0
  ]

  (ifelse algorithm-sobot = "Milling"
    [
  ;; Milling Alg
     ifelse s = 1
     [
       set omega turning-rate-sobot
     ]
     [
      set omega (-1 * turning-rate-sobot)
     ]

     set inputs (list speed-w-noise 90 (- omega))
    ]
    algorithm-sobot = "Diffusing"
    [

  ;; Diffusion Alg

     ifelse s = 1
     [
      set inputs (list speed-w-noise 270 0)
     ]
     [
      set inputs (list 0 90 (turning-rate-sobot))
     ]
    ]
    algorithm-sobot = "Diffusing2"
    [

  ;; Diffusion Alg 2

     ifelse s = 1
     [
      set inputs (list speed-w-noise 90 (2 * turning-rate-sobot))
     ]
     [
      set inputs (list speed-w-noise 90 (turning-rate-sobot))
     ]
    ]
    algorithm-sobot = "Clustering"
    [

  ;; Clustering Alg

     ifelse s = 1
     [
      set inputs (list speed-w-noise 90 0)
     ]
     [
      set inputs (list 0 90 (turning-rate-sobot))
     ]
    ]
    )


 update_agent_state; updates states of agents (i.e. position and heading)

  set s_old s

end

to background_procedures
 clear-paint

ifelse paint_fov?
  [
    ask discs
      [
         set age age + 1
         if age = 1 [ die ]
       ]

    ask robots
      [
        (ifelse vision-cone = 360
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 270
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "270-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 180
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "180-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 90
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "90-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 45
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "45-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 60
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "60-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone = 30
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance * 1)
                  set heading ([heading] of myself)
                  set shape "30-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          [
;            paint-patches-in-new-FOV
          ]
          )

      ]

    ask sobots
      [
        (ifelse vision-cone-sobot = 360
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 270
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "270-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 180
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "180-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 90
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "90-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 45
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "45-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 60
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "60-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          vision-cone-sobot = 30
          [
            hatch-discs 1
                [
                  set size 2 * (vision-distance-sobot * 1)
                  set heading ([heading] of myself)
                  set shape "30-deg-fov"
                  palette:set-transparency 50
                ]
          ]
          [
;            paint-patches-in-new-FOV
          ]
          )

      ]
  ]
  [
    ask discs [die]
  ]

  ifelse draw_path?
  [
    ask robots [pd]
  ]
  [
    ask robots [pu]
  ]
end

to find-metrics

  ask robots
  [ ;find_resultant_angle
    set V sqrt (((item 0 velocity + impact-x)^ 2) + ((item 1 velocity + impact-y)^ 2))



    set scatter_indiv ((xcor - mean[xcor] of centroids) ^ 2 + (ycor - mean [ycor] of centroids ) ^ 2)

    set rad_var_comp1 sqrt(scatter_indiv)
    set rad_var_comp1_sum rad_var_comp1_sum + rad_var_comp1
    set rad_var_comp2 (rad_var_comp1 - rad_var_comp1_mean_sub) ^ 2

    set dist-to-closest distance min-one-of other robots [distance myself]

    set my-dist-to-closest-std (dist-to-closest - dist-to-closest-avg)^ 2



    set momentum_indiv  (((item 0 velocity + impact-x) * (ycor - mean [ycor] of centroids)) - ((item 1 velocity + impact-y)* (xcor - mean [xcor] of centroids )))

    set rot_indiv  (((item 0 velocity + impact-x) * ((ycor - mean [ycor] of centroids) / sqrt((xcor - mean [xcor] of centroids) ^ 2 + (ycor - mean [ycor] of centroids) ^ 2))) - ((item 1 velocity + impact-y) * ((xcor - mean [xcor] of centroids) / sqrt((xcor - mean [xcor] of centroids) ^ 2 + (ycor - mean [ycor] of centroids) ^ 2))))



    set V-sum V-sum + V
    set scatter-sum scatter-sum + scatter_indiv
    set momentum-sum momentum-sum + momentum_indiv
    set group-rot-sum group-rot-sum + rot_indiv
    set rad_var_comp_sum rad_var_comp_sum + rad_var_comp2
    set dist-to-closest-sum dist-to-closest-sum + dist-to-closest
    set dist-to-closest-std-sum dist-to-closest-std-sum + my-dist-to-closest-std


   ]



   set avg-speeds (V-sum / number-of-robots)
   set scatter (scatter-sum / (number-of-robots)); * (sqrt(2)* max-pxcor) ^ 2))
   set ang-momentum (momentum-sum / (number-of-robots)); * (sqrt(2)* max-pxcor)))
   set group-rot (group-rot-sum / number-of-robots)
   set circliness (mean[cc-rad] of centroids - mean [ic-rad] of centroids )/ mean [ic-rad] of centroids

   set dist-to-closest-avg (dist-to-closest-sum / number-of-robots)
   set dist-to-closest-standard-dev ( dist-to-closest-std-sum / number-of-robots)


;  set diffusion_val 1 - exp(dist-to-closest-standard-dev / dist-to-closest-avg)
   set diffusion_val dist-to-closest-standard-dev

   set outer_radius_size (mean [cc-rad] of centroids )
   set rad_var_comp1_mean (rad_var_comp1_sum / number-of-robots)
   set rad_var_comp1_mean_sub rad_var_comp1_mean

   set rad_var (rad_var_comp_sum / (number-of-robots)); * (sqrt(2)* max-pxcor) ^ 2))


   set V-sum 0
   set scatter-sum 0
   set momentum-sum 0
   set group-rot-sum 0
   set rad_var_comp_sum 0
   set rad_var_comp1_sum 0
   set dist-to-closest-sum 0
   set dist-to-closest-std-sum 0

  ifelse length diffusion_list > 1000
    [
     set diffusion_list remove-item 0 diffusion_list
     set diffusion_list lput diffusion_val diffusion_list
     ]
    [
      set diffusion_list lput diffusion_val diffusion_list
    ]


   ifelse length v_avg_list > 1000
    [
     set v_avg_list remove-item 0 v_avg_list
     set v_avg_list lput avg-speeds v_avg_list
     ]
    [
      set v_avg_list lput avg-speeds v_avg_list
    ]

   ifelse length scatter_list > 1000
    [
     set scatter_list remove-item 0 scatter_list
     set scatter_list lput scatter scatter_list
     ]
    [
      set scatter_list lput scatter scatter_list
    ]

  ifelse length group-rot_list > 1000
    [
     set group-rot_list remove-item 0 group-rot_list
     set group-rot_list lput group-rot group-rot_list
     ]
    [
      set group-rot_list lput group-rot group-rot_list
    ]

  ifelse length ang-momentum_list > 1000
    [
     set ang-momentum_list remove-item 0 ang-momentum_list
     set ang-momentum_list lput ang-momentum ang-momentum_list
     ]
    [
      set ang-momentum_list lput ang-momentum ang-momentum_list
    ]

  ifelse length rad_var_list > 1000
    [
     set rad_var_list remove-item 0 rad_var_list
     set rad_var_list lput rad_var rad_var_list
     ]
    [
      set rad_var_list lput rad_var rad_var_list
    ]

  ifelse length circliness_list > 300
    [
     set circliness_list remove-item 0 circliness_list
     set circliness_list lput circliness circliness_list
     ]
    [
      set circliness_list lput circliness circliness_list
    ]

  ifelse length alg-con_list > 300
    [
     set alg-con_list remove-item 0 alg-con_list
     set alg-con_list lput alg-con alg-con_list
     ]
    [
      set alg-con_list lput alg-con alg-con_list
    ]



   let current_radius mean[cc-rad] of centroids



  ifelse length radius_list > 300
    [
     set radius_list remove-item 0 radius_list
     set radius_list lput current_radius radius_list
     ]
    [
      set radius_list lput current_radius radius_list
    ]

   ifelse current_radius > (old_radius * 1.05);if the moving average window increases, it is growing
     [
       set growth_val growth_val + 1
     ]
     [
       set growth_val 0
     ]

   ifelse current_radius < (old_radius * 0.95);if the moving average window decreases, it is shrinking
     [
       set shrink_val shrink_val + 1
     ]
     [
       set shrink_val 0
     ]


   if ticks mod 1000 = 0
     [
      set old_radius mean radius_list
      ]

end

to classify_behavior

  find-metrics

  ifelse algorithm-robot = "Milling"
  [
    if ticks > 1000
    [
    (ifelse alg-con <= 0.000001
    [
      set phase "Separated Groups"
      set stability_val (stability_val + 1)

    ]
    avg-speeds < (speed1 * 0.5)
    [
      set phase "Cluster"
      set stability_val (stability_val + 1)
    ]
    growth_val > 500
    [
      set phase "Growing"
      set stability_val 0
    ]
    shrink_val > 500
    [
      set phase "Shrinking"
      set stability_val 0
    ]
      mean circliness_list < 0.04
    [
      set phase "Milling"
      set milling_val 1
      set stability_val (stability_val + 1)
    ]
        mean circliness_list > 0.04 and mean circliness_list < 0.9
    [
      set phase "Ellipsoidal"
      set stability_val (stability_val + 1)
    ]
    [
      set phase "N/A"
      set stability_val 0
    ]
    )
    ]
  ]
  [
   if ticks > 1000
   [
      (ifelse mean diffusion_list < 0.02 and length remove-duplicates diffusion_list < 10
     [
      set phase "Diffused"
      set stability_val (stability_val + 1)
    ]
      length remove-duplicates diffusion_list < 10
      [
      set phase "Not Diffused"
      set stability_val (stability_val + 1)
    ]
     [
      set phase "N/A"
      set stability_val 0;(stability_val + 1)
    ]
        )
   ]
  ]

  let robot_distance_list (list )
  ask robots [set robot_distance_list lput (distance max-one-of other robots [distance myself]) robot_distance_list]

  let sobot_distance_list (list )
  ask sobots [set sobot_distance_list lput (distance max-one-of other sobots [distance myself]) sobot_distance_list]


  ifelse phase = "Milling" and (max robot_distance_list > max sobot_distance_list)
  [
    set combined_phase "Separated"
    set combined_stability_val (combined_stability_val + 1)
  ]
  [
    set combined_phase "N/A"
    set combined_stability_val 0
  ]


end






;
;
;-------------- Nested functions and Setup Procedures below--------------
;
;



to set_actuating_and_extra_variables
  if ticks mod 1 = 0
  [
    set rand-x random-normal 0 state-disturbance_xy
    set rand-y random-normal 0 state-disturbance_xy
    set rand-head-distrbuance random-normal 0 state-disturbance_head
  ]

  if breed = robots
  [
  set speed-w-noise random-normal (speed1 * 1) (noise-actuating-speed)
  set turning-w-noise random-normal (turning-rate1) noise-actuating-turning
  ]
  if breed = sobots
  [
    set speed-w-noise random-normal (speed-sobot * 1) (noise-actuating-speed)
   set turning-w-noise random-normal (turning-rate-sobot) noise-actuating-turning
  ]

end

to do_sensing
if detect_robots?
  [
  find-robots-in-FOV
  ]
if detect_sobots?
  [
  find-sobots-in-FOV
  ]

end

to update_agent_state
  agent_dynamics

  if member? self robots
  [
    set distance_traveled (distance_traveled +  (item 0 inputs * tick-delta))
    set energy (energy +  (((1 * item 0 inputs) ^ 2 + (item 1 inputs * pi / 180) ^ 2) * tick-delta) )
  ]


  if collisions?
  [
   do_collisions
  ]

   set true_velocity (list (( item 0 velocity * 1  ) + (impact-x * 1  ) + (rand-x * 1  )) (( item 1 velocity * 1  ) + (impact-y * 1  ) + (rand-y * 1 )))


  let nxcor xcor + ( item 0 velocity * tick-delta  ) + (impact-x * tick-delta  ) + (rand-x * tick-delta  )
  let nycor ycor + ( item 1 velocity * tick-delta  ) + (impact-y * tick-delta  ) + (rand-y * tick-delta  )


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



to add_robot
  ask place-holder ((count robots))
  [  set breed robots
      st
      setxy 0.3 0
      let sr_patches patches with [(distancexy 0 0 < (number-of-robots * ([size] of robot (0)) / pi)) and pxcor != 0 and pycor != 0]


      move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
      setxy (xcor + .01) (ycor + .01)

      set velocity [ 0 0 ]
      set angular-velocity 0
      set inputs [0 0 0]



      set shape "circle 2"
      set color red
      set size 0.3 ; sets size to 1m

      set mass size
     set color red
    ]

    set number-of-robots (number-of-robots + 1)
end

to remove_robot
ask robot (count robots - 1)
  [
    set breed place-holders
    ht
  ]
  set number-of-robots (number-of-robots - 1)

end

to add_sobot
  ask place-holder ((count sobots) + count robots)
  [  set breed sobots
      st
      setxy 0.3 0
      let sr_patches patches with [(distancexy 0 0 < (number-of-robots * (1) / pi)) and pxcor != 0 and pycor != 0]


      move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
      setxy (xcor + .01) (ycor + .01)

      set velocity [ 0 0 ]
      set angular-velocity 0
      set inputs [0 0 0]



      set shape "circle 2"
      set color blue
      set size 0.3 ; sets size to 1m

      set mass size

    ]

    set number-of-sobots (number-of-sobots + 1)
end

to remove_sobot
ask sobot (count sobots + count robots - 1)
  [
    set breed place-holders
    ht
  ]
  set number-of-sobots (number-of-sobots - 1)

end



to make_robot
  create-robots 1
    [
      set omega_val 1
      set velocity [ 0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 0.3 ;1 meter diameter

      set fov-list-sanctuaries (list )
      set fov-list-robots (list )
      set fov-list-sobots (list )
      set fov-list-drugboats (list )
;      set fov-list-robots-same (list )


      place_robots


;      set shape "circle 2"
      set color red
      set mass size


     set coll_angle2 0
     set detect_sanctuaries? false
     set detect_drugboats? false
     set detect_robots? false

    set detection_response_type "turn-away"

    set random_switch-timer round random-normal 200 50
    ]
end

to make_sobot
  create-sobots 1
    [
      set omega_val 1
      set velocity [ 0 0]
      set angular-velocity 0
      set inputs [0 0 0]
      set size 0.3 ;1 meter diameter

      set fov-list-sanctuaries (list )
      set fov-list-robots (list )
      set fov-list-sobots (list )
      set fov-list-drugboats (list )
;      set fov-list-sobots-same (list )


      place_sobots


;      set shape "circle 2"
      set color blue
      set mass size

     set coll_angle2 0
     set detect_sanctuaries? false
     set detect_drugboats? false
     set detect_sobots? false

    set detection_response_type "turn-away"

    set random_switch-timer round random-normal 200 50
    ]
end



to place_robots; defines region and/or orientation of where the robots should start
  if robot_setup = "Random"
   [

      let tycor one-of (range (min-pycor + 1) (max-pycor - 1) 0.01)
       let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

       setxy txcor tycor
   ]

  if robot_setup = "Center Band"
   [
     let tycor one-of (range (-5) (5) 0.01)
     let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

     setxy txcor tycor
   ]

  if robot_setup = "Barrier"
   [
     let tycor one-of (range (-3) (3) 0.01)
     let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

     setxy txcor tycor

     ifelse  heading mod 2 = 0
       [
         set heading 90       ]
       [
         set heading 270
       ]
   ]


  if robot_setup = "Inverted V"
   [
     let txcor one-of (range (-30) (30) 0.01)
     let selected_xcor txcor
     ifelse selected_xcor > 0
        [setxy selected_xcor (25 - (1.73333 * selected_xcor))]
        [setxy selected_xcor (25 + (1.73333 * selected_xcor))]


     setxy (xcor + random-normal 0 0.5) (ycor + random-normal 0 0.5)

     ifelse  heading mod 2 = 0
       [
         set heading towardsxy 0 30;random-normal 90 10
       ]
       [
         set heading 180 + towardsxy 0 30;random-normal 270 10
       ]
   ]

  if robot_setup = "Circle - Center"
   [
;    let sr_patches patches with [(distancexy 0 0 < (sqrt(number-of-robots) * (1) * (1) ) ) and pxcor != 0 and pycor != 0]
;    move-to one-of sr_patches with [(not any? other turtles in-radius (0.4))]
;     setxy (xcor + 0.01) (ycor + 0.01)
      let tycor one-of (range (-1) (1) 0.01)
       let txcor one-of (range (-1) (1) 0.01)

       setxy txcor tycor
   ]

  if robot_setup = "Donut"
   [
    let sr_patches patches with [(distancexy 0 0 < (10)) and (distancexy 0 0 > (3 / 2)) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)
   ]

  if robot_setup = "Circle - Random"
   [
    let sr_patches patches with [(distancexy rand-xcor rand-ycor < (sqrt(number-of-robots) * ([size] of robot (0)) * (4) ) + 1) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)
   ]


  if robot_setup = "Circle - Center - Facing Out"
   [
    let sr_patches patches with [(distancexy 0 0 < (sqrt(number-of-robots) * ([size] of robot (0)) * (1) ) + 0.35) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)

    set heading 180 + towardsxy 0 0
   ]

  if robot_setup = "Custom - Region" ; design your own setup by defining the region they should start in
   [
    ; use examples above to find a way to set them up however you like
   ]

end


to robot_setup_strict; if you want to more precisely place the robots (i.e. robot 2 needs to be at position x, etc.)



  if robot_setup = "Perfect Circle"
   [

      let irr  (circle1size); / 10)
      let j 0
      let heading_num 360 / (number-of-robots)
      let random-rotation random 90


      while [j < number-of-robots]
      [ask robot (j)
        [
          setxy (irr * -1 * cos(j * heading_num)) (irr * sin(j * heading_num)) 
          set heading 180 + towardsxy 0 0
        ]

        set j j + 1
      ]


   ]

  if robot_setup = "Custom - Precise"; specify exactly where you want each robot to be placed to create shapes and better formations
   [
     ; use examples above to find a way to set them up however you like
   ]
end

to place_sobots; defines region and/or orientation of where the sobots should start
  if sobot_setup = "Random"
   [

      let tycor one-of (range (min-pycor + 1) (max-pycor - 1) 0.01)
       let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

       setxy txcor tycor
   ]

  if sobot_setup = "Center Band"
   [
     let tycor one-of (range (-5) (5) 0.01)
     let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

     setxy txcor tycor
   ]

  if sobot_setup = "Barrier"
   [
     let tycor one-of (range (-3) (3) 0.01)
     let txcor one-of (range (min-pxcor + 1) (max-pxcor - 1) 0.01)

     setxy txcor tycor

     ifelse  heading mod 2 = 0
       [
         set heading 90       ]
       [
         set heading 270
       ]
   ]


  if sobot_setup = "Inverted V"
   [
     let txcor one-of (range (-30) (30) 0.01)
     let selected_xcor txcor
     ifelse selected_xcor > 0
        [setxy selected_xcor (25 - (1.73333 * selected_xcor))]
        [setxy selected_xcor (25 + (1.73333 * selected_xcor))]


     setxy (xcor + random-normal 0 0.5) (ycor + random-normal 0 0.5)

     ifelse  heading mod 2 = 0
       [
         set heading towardsxy 0 30;random-normal 90 10
       ]
       [
         set heading 180 + towardsxy 0 30;random-normal 270 10
       ]
   ]

  if sobot_setup = "Circle - Center"
   [
;    let sr_patches patches with [(distancexy 0 0 < (sqrt(number-of-sobots) * (1) * (1) ) ) and pxcor != 0 and pycor != 0]
;    move-to one-of sr_patches with [(not any? other turtles in-radius (0.4))]
;     setxy (xcor + 0.01) (ycor + 0.01)

      let tycor one-of (range (-1) (1) 0.01)
       let txcor one-of (range (-1) (1) 0.01)

       setxy txcor tycor
   ]

  if sobot_setup = "Donut"
   [
    let sr_patches patches with [(distancexy 0 0 < (10)) and (distancexy 0 0 > (3 / 2)) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)
   ]

  if sobot_setup = "Circle - Random"
   [
    let sr_patches patches with [(distancexy rand-xcor rand-ycor < (sqrt(number-of-sobots) * ([size] of robot (0)) * (4) ) + 1) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)
   ]


  if sobot_setup = "Circle - Center - Facing Out"
   [
    let sr_patches patches with [(distancexy 0 0 < (sqrt(number-of-sobots) * ([size] of robot (0)) * (1) ) + 0.35) and pxcor != 0 and pycor != 0]
    move-to one-of sr_patches with [(not any? other turtles in-radius ([size] of robot (0)))]
     setxy (xcor + 0.01) (ycor + 0.01)

    set heading 180 + towardsxy 0 0
   ]

  if sobot_setup = "Custom - Region" ; design your own setup by defining the region they should start in
   [
    ; use examples above to find a way to set them up however you like
   ]

end


to sobot_setup_strict; if you want to more precisely place the sobots (i.e. sobot 2 needs to be at position x, etc.)



  if sobot_setup = "Perfect Circle"
   [

      let irr  (circle2size); / 10)
      let j number-of-robots
      let heading_num 360 / (number-of-sobots)
      let random-rotation random 90


      while [j < (number-of-sobots + number-of-robots)]
      [ask sobot (j)
        [
          setxy (irr * -1 * cos((j - number-of-robots) * heading_num)) (irr * sin(((j - number-of-robots) * heading_num)) )
          set heading 180 + towardsxy 0 0
        ]

        set j j + 1
      ]


   ]

  if sobot_setup = "Custom - Precise"; specify exactly where you want each sobot to be placed to create shapes and better formations
   [
     ; use examples above to find a way to set them up however you like
   ]
end


to clear-paint
ask patches
    [
        set pcolor white
    ]
end


to agent_dynamics
  ; Reminder, each patch represents 1m, these values below are in terms of patches (i.e. 0.25 patches = 0.025m = 2.5cm)

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
if count other turtles with [breed != discs and breed != centroids] > 0
      [
        let closest-turtle1 (max-one-of place-holders [distance myself])

        if  count robots > 1
        [
          ifelse count robots > 3
          [
            set closest-turtles (min-n-of 2 other turtles with [breed != discs and breed != centroids] [distance myself])

            set closest-turtle1 (min-one-of closest-turtles [distance myself])
            set closest-turtle2 (max-one-of closest-turtles [distance myself])
          ]
          [
            set closest-turtle1 (min-one-of other turtles with [breed != discs and breed != centroids] [distance myself])
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


to find-robots-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0


  if breed = robots
  [
   set vision-dd vision-distance
   set vision-cc vision-cone
  ]
  if breed = sobots
  [
   set vision-dd vision-distance-sobot
   set vision-cc vision-cone-sobot
  ]


  set fov-list-robots (list )
  set i (0)



  while [i < (count robots)]
    [
      if self != turtle ((i )  )
        [
          let sub-heading towards robot (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (robot (i )) < (vision-dd * 1));
           [
             set fov-list-robots fput (robot (i)) fov-list-robots

           ]
        ]
     set i (i + 1)
      ]
end

to find-sobots-in-FOV
  let vision-dd 0
  let vision-cc 0
  let real-bearing 0

  if breed = robots
  [
   set vision-dd vision-distance
   set vision-cc vision-cone
  ]
  if breed = sobots
  [
   set vision-dd vision-distance-sobot
   set vision-cc vision-cone-sobot
  ]



  set fov-list-sobots (list )
  set i (number-of-robots)

  while [i < (count sobots + count robots)]
    [
      if self != turtle ((i )  )
        [
          let sub-heading towards sobot (i ) - heading
          set real-bearing sub-heading

          if sub-heading < 0
            [set real-bearing sub-heading + 360]

          if sub-heading > 180
            [set real-bearing sub-heading - 360]

          if real-bearing > 180
            [set real-bearing real-bearing - 360]


          if (abs(real-bearing) < ((vision-cc / 2))) and (distance-nowrap (sobot (i )) < (vision-dd * 1));
           [
             set fov-list-sobots fput (sobot (i)) fov-list-sobots

           ]
        ]
     set i (i + 1)
      ]
end


to paint-patches-in-new-FOV

  let vision-dd 0
  let vision-cc 0

  set vision-dd vision-distance
  set vision-cc vision-cone



  set fov-list-patches (list )
  set i 0

  set fov-list-patches patches in-cone (vision-dd * 1) (vision-cc) with [(distancexy-nowrap ([xcor] of myself) ([ycor] of myself) <= (vision-dd * 1))  and pcolor != black]


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

    let current-closest-robot-distance distance myself


     if (real-bearing-patch < ((vision-cc / 2)) and real-bearing-patch > ((-1 * (vision-cc / 2))))
     [
      ifelse member? myself robots
      [
        set pcolor orange
;       set pcolor scale-color red current-closest-robot-distance 0 10 ; Adjust range as needed
      ]
      [set pcolor yellow]
     ]
  ]

end


to find_adj_matrix
  set i 0
  let k 0
  let j 0
  let b 0
  let h 0
  let g 0
  let tr 0
  let t1 0
  let t2 0
  let t3 0
  let t4 0
  let t5 0
  let ss 0

  set groups (list )
  set GM matrix:make-constant number-of-robots number-of-robots number-of-robots


  while [i < number-of-robots]
  [
    ask robot (i)
    [
      set j 0
      set n 0
      set deg 0
      while [j < number-of-robots]
      [
        ;set val j
        set val distance (robot (j))


        ifelse val < (1 * vision-distance) and val != 0
        [ matrix:set AM i j 1
          set deg deg + 1]
        [ matrix:set AM i j 0]


        ifelse val < (1.00 * vision-distance); and val != 0
        [
          matrix:set GM i n j
          set n (n + 1)
        ]
        [ matrix:set GM i j number-of-robots]


        set j (j + 1)
      ]


      matrix:set DM i i deg
     ]
    set i (i + 1)
  ]

 set rank matrix:rank AM


 while [k < number-of-robots]
 [
   set b 0
   set group1 (list )
   while [b < number-of-robots]
   [
     let point matrix:get GM k b
     if not member? point group1 and point < number-of-robots
     [
       set group1 fput point group1
       ;]
       set h 0
       while [h < number-of-robots]
       [
         let point1 matrix:get GM point h
         if not member? point1 group1 and point1 < number-of-robots
           [
             set group1 fput point1 group1
             set g 0
             while [g < number-of-robots]
               [
                 let point2 matrix:get GM point1 g
                 if not member? point2 group1 and point2 < number-of-robots
                   [
                     set group1 fput point2 group1
                     set ss 0
                     while [ss < number-of-robots]
                       [
                         let point3 matrix:get GM point2 ss
                         if not member? point3 group1 and point3 < number-of-robots
                           [
                             set group1 fput point3 group1
                             set c-mat 0
                             while [c-mat < number-of-robots]
                               [
                                 let point4 matrix:get GM point3 c-mat
                                 if not member? point4 group1 and point4 < number-of-robots
                                   [
                                     set group1 fput point4 group1
                                     set tr 0
                                     while [tr < number-of-robots]
                                       [
                                         let point5 matrix:get GM point4 tr
                                         if not member? point5 group1 and point5 < number-of-robots
                                           [
                                             set group1 fput point5 group1
                                             set t1 0
                                             while [t1 < number-of-robots]
                                               [
                                                 let point6 matrix:get GM point5 t1
                                                 if not member? point6 group1 and point6 < number-of-robots
                                                   [
                                                     set group1 fput point6 group1
                                                     set t2 0
                                                     while [t2 < number-of-robots]
                                                       [
                                                         let point7 matrix:get GM point6 t2
                                                         if not member? point7 group1 and point7 < number-of-robots
                                                           [
                                                             set group1 fput point7 group1
                                                             set t3 0
                                                             while [t3 < number-of-robots]
                                                               [
                                                                 let point8 matrix:get GM point7 t3
                                                                 if not member? point8 group1 and point8 < number-of-robots
                                                                 [
                                                                   set group1 fput point8 group1
                                                                   set t4 0
                                                                   while [t4 < number-of-robots]
                                                                     [
                                                                       let point9 matrix:get GM point8 t4
                                                                       if not member? point9 group1 and point9 < number-of-robots
                                                                       [
                                                                         set group1 fput point9 group1
                                                                         set t5 0
                                                                         while [t5 < number-of-robots]
                                                                           [
                                                                             let point10 matrix:get GM point9 t5
                                                                             if not member? point10 group1 and point10 < number-of-robots
                                                                             [
                                                                               set group1 fput point10 group1

                                                                              ]

                                                                            set t5 (t5 + 1)
                                                                           ]

                                                                        ]

                                                                      set t4 (t4 + 1)
                                                                     ]

                                                                  ]

                                                                set t3 (t3 + 1)
                                                               ]

                                                            ]

                                                          set t2 (t2 + 1)
                                                       ]
                                                    ]

                                                  set t1 (t1 + 1)
                                               ]
                                           ]

                                          set tr (tr + 1)
                                       ]
                                   ]

                                  set c-mat (c-mat + 1)
                                ]
                           ]

                          set ss (ss + 1)
                       ]
                   ]

                   set g (g + 1)
               ]
           ]

         set h (h + 1)
        ]
      ]
      set b (b + 1)
   ]
   set group1 (sort group1 )
   set groups fput group1 groups
   set k (k + 1)
 ]

set groups remove-duplicates groups

set num-of-groups length groups

set LapM matrix:minus DM AM

ifelse count robots > 1
  [
    set alg-con item 1 sort (matrix:real-eigenvalues LapM)
  ]
  [
    set alg-con 1
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
@#$#@#$#@
GRAPHICS-WINDOW
499
17
904
423
-1
-1
7.8
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
191
30
283
63
seed-no
seed-no
1
150
8.0
1
1
NIL
HORIZONTAL

SLIDER
17
290
192
323
vision-distance
vision-distance
0
100
8.0
0.5
1
m
HORIZONTAL

SLIDER
15
327
187
360
vision-cone
vision-cone
0
360
90.0
5
1
deg
HORIZONTAL

SLIDER
14
367
193
400
speed1
speed1
0
5
1.0
0.5
1
m/s
HORIZONTAL

SLIDER
12
403
192
436
turning-rate1
turning-rate1
0
360
40.0
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
112
21
179
61
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
add_robot
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
remove_robot
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
251
112
371
145
paint_fov?
paint_fov?
0
1
-1000

SWITCH
251
149
372
182
draw_path?
draw_path?
1
1
-1000

BUTTON
372
149
475
182
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
372
109
472
142
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
number-of-robots
number-of-robots
0
30
4.0
1
1
NIL
HORIZONTAL

TEXTBOX
260
96
475
122
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

TEXTBOX
26
66
214
89
Hunters
11
0.0
1

SLIDER
8
565
227
598
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
5
618
241
651
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
5
674
186
707
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
12
725
213
758
state-disturbance_head
state-disturbance_head
0
50
0.0
5
1
NIL
HORIZONTAL

CHOOSER
23
86
221
131
Robot_setup
Robot_setup
"Random" "Inverted V" "Center Band" "Barrier" "Circle - Center" "Circle - Center - Facing Out" "Circle - Random" "Perfect Circle" "Perfect Picket" "Imperfect Picket" "Custom - Region" "Custom - Precise" "Donut"
4

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

BUTTON
214
463
352
496
NIL
score_procedure
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
202
175
235
circle1size
circle1size
0
25
3.0
1
1
m
HORIZONTAL

SLIDER
235
240
408
273
wait_time
wait_time
0
50
0.0
1
1
ticks
HORIZONTAL

SLIDER
212
502
385
535
num-of-runs
num-of-runs
0
100
50.0
1
1
NIL
HORIZONTAL

TEXTBOX
254
213
442
236
40 ticks per second\n
11
0.0
1

PLOT
1299
319
1867
607
Circliness
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
"circliness" 1.0 0 -16777216 true "" ""

MONITOR
993
89
1211
134
Window Avg Circliness
mean circliness_list
17
1
11

MONITOR
997
158
1356
207
Phase of Robots
phase
17
1
12

MONITOR
1228
88
1316
133
NIL
avg-speeds
17
1
11

PLOT
1873
317
2507
606
Milling Radius
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
"cc-rad" 1.0 0 -16777216 true "" ""

TEXTBOX
410
492
625
518
not functional yet\n
11
0.0
1

MONITOR
1330
89
1483
134
Algebraic Connectivity
alg-con
17
1
11

CHOOSER
259
320
397
365
algorithm-robot
algorithm-robot
"Milling" "Diffusing" "Diffusing2" "Clustering"
0

MONITOR
985
356
1197
401
NIL
precision (mean diffusion_list) 6
17
1
11

SLIDER
592
647
765
681
number-of-sobots
number-of-sobots
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
592
684
802
718
vision-distance-sobot
vision-distance-sobot
0
10
2.0
0.1
1
m
HORIZONTAL

SLIDER
592
722
789
756
vision-cone-sobot
vision-cone-sobot
0
360
30.0
5
1
deg
HORIZONTAL

SLIDER
593
762
766
796
speed-sobot
speed-sobot
0
4
1.0
0.1
1
m/s
HORIZONTAL

SLIDER
595
802
809
836
turning-rate-sobot
turning-rate-sobot
0
360
90.0
5
1
deg/s
HORIZONTAL

BUTTON
897
653
995
687
NIL
add_sobot\n
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
898
695
1018
729
NIL
remove_sobot
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
955
783
1094
828
algorithm-sobot
algorithm-sobot
"Milling" "Diffusing" "Diffusing2" "Clustering"
1

CHOOSER
957
833
1176
878
Sobot_setup
Sobot_setup
"Random" "Inverted V" "Center Band" "Barrier" "Circle - Center" "Circle - Center - Facing Out" "Circle - Random" "Perfect Circle" "Perfect Picket" "Imperfect Picket" "Custom - Region" "Custom - Precise" "Donut"
4

SWITCH
600
463
719
497
collisions?
collisions?
1
1
-1000

SLIDER
1323
834
1496
868
circle2size
circle2size
0
20
1.0
1
1
m
HORIZONTAL

MONITOR
998
230
1153
275
Phase of Whole Group
combined_phase
17
1
11

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

270-deg-fov
true
0
Polygon -7500403 true true 0 150 0 120 15 90 30 60 60 30 90 15 135 0 165 0 210 15 240 30 270 60 285 90 300 120 300 150 0 150
Polygon -7500403 true true 150 150 60 255 52 264 25 235 13 211 5 186 0 161 0 151 0 150 150 150
Polygon -7500403 true true 60 180
Polygon -7500403 true true 150 150 240 255 248 264 275 235 287 211 295 186 300 161 300 151 300 150 150 150

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
  <experiment name="Circliness_parameter_sweep" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <exitCondition>end_flag = 1</exitCondition>
    <metric>phase</metric>
    <metric>mean v_avg_list</metric>
    <metric>mean group-rot_list</metric>
    <metric>mean ang-momentum_list</metric>
    <metric>mean scatter_list</metric>
    <metric>mean rad_var_list</metric>
    <metric>mean circliness_list</metric>
    <steppedValueSet variable="vision-cone" first="10" step="3" last="90"/>
    <steppedValueSet variable="number-of-robots" first="3" step="1" last="15"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="10"/>
  </experiment>
  <experiment name="Circliness_parameter_sweep_num_of_agents_forward_speed" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="15000"/>
    <exitCondition>end_flag = 1</exitCondition>
    <metric>phase</metric>
    <metric>mean v_avg_list</metric>
    <metric>mean group-rot_list</metric>
    <metric>mean ang-momentum_list</metric>
    <metric>mean scatter_list</metric>
    <metric>mean rad_var_list</metric>
    <metric>mean circliness_list</metric>
    <steppedValueSet variable="speed1" first="0.25" step="0.25" last="5"/>
    <steppedValueSet variable="number-of-robots" first="3" step="1" last="15"/>
    <steppedValueSet variable="seed-no" first="1" step="1" last="10"/>
  </experiment>
  <experiment name="diffusion_parameter_sweep_num_of_agents_forward_speed (copy)" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="25000"/>
    <exitCondition>end_flag = 1</exitCondition>
    <metric>phase</metric>
    <metric>mean v_avg_list</metric>
    <metric>mean group-rot_list</metric>
    <metric>mean ang-momentum_list</metric>
    <metric>mean scatter_list</metric>
    <metric>mean rad_var_list</metric>
    <metric>mean circliness_list</metric>
    <metric>mean diffusion_list</metric>
    <steppedValueSet variable="speed1" first="0.25" step="0.25" last="5"/>
    <steppedValueSet variable="number-of-robots" first="3" step="1" last="15"/>
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
