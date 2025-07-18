breed [ dogs dog ]
breed [rudders rudder]
breed [sleds sled]
breed [attachment-points attachment-point]

globals [
          tick-delta


]
dogs-own [
  velocity           ;; vector with x y and z components it is determined by the previous velocity
                     ;; and the current acceleration at each step
  acceleration       ;; vector with x y and z components, determined by the six urges
  angular-velocity   ;; angular velocity of heading/yaw
  angular-acceleration
  inputs             ;; input forces
  thrust             ;; thrust
  angular-thrust     ;;
  forces             ;; force
  drag-x
  drag-y
  drag-heading
  a-x
  a-y
  nearest-neighbor-touching-flag
  impact-x
  impact-y
  impact-heading
  mass
  Ig
  tether-accel-x
  tether-accel-y
  tether-accel-angular
  angular-acceleration-no-tether
  a-x-no-tether
  a-y-no-tether
  len
  width
  Ftow
  rot-drag-coef
  k-d
  k-d-lateral

]

sleds-own[
  velocity           ;; vector with x y and z components it is determined by the previous velocity
                     ;; and the current acceleration at each step
  acceleration       ;; vector with x y and z components, determined by the six urges
  angular-velocity   ;; angular velocity of heading/yaw
  angular-acceleration
  inputs             ;; input forces
  thrust             ;; thrust
  angular-thrust     ;;
  forces             ;; force
  drag-x
  drag-y
  drag-heading
  a-x
  a-y
  nearest-neighbor-touching-flag
  impact-x
  impact-y
  impact-heading
  mass
  Ig
  tether-accel-x
  tether-accel-y
  tether-accel-angular
  angular-acceleration-no-tether
  a-x-no-tether
  a-y-no-tether
  len
  width
  rot-drag-coef
  k-d
  k-d-lateral
]
rudders-own[
  attached-to-ID
  old-x
  old-y
  vx
  vy
]

attachment-points-own[
  attached-to-ID
  old-x
  old-y
  vx
  vy
  my-side
  tether-accel-x-sum
  tether-accel-y-sum
  tether-accel-ang-sum
]
links-own [
    old-link-color
    change-flag
]

;;
;; Setup Procedures
;;
to setup
  clear-all
  random-seed seed-no

  set tick-delta 0.1 ; 10 ticks in one second

  create-sleds 1 ; create-"blank" makes however many agents of that species and then it asks them all to do whatever is in the brackets after
  [
    make_sled
  ]

  create-dogs number-of-dogs
    [
      make_dog
    ]

  ;; color floor
  ask patches
      [ set pcolor white]

  reset-ticks

end



to make_dog ;; procedure to create dog and define its variables

  set size 2 / meters-per-patch ; sets length to two meters
  set width size * (0.3); sets width to 0.5 m
  set len size ; makes new variable equal to size to simplify code later
  set velocity [0 0]
  set acceleration [ 0 0 ]
  set angular-velocity 0
  set angular-acceleration 0
  set inputs (list 0 0); inputs are forward thrust and angle of thrust
  set heading 0 ; 0 is pointing north and 90 is pointing east such that the angle increases as you go around clockwise
  set mass 5 ; mass in kg
  set Ig 0.1 ; moment of inertia

  set rot-drag-coef 0.05 ; value for rotational drag (need to find true val)
  set k-d 4.52 ; friction coefficient (need to find real coef)
  set k-d-lateral 45 ; lateral friction coefficient (need to find real coef)


  set color blue
  set shape "boat"

  ; position dogs in formation
  let setup-range 8
  let increment setup-range / number-of-dogs
  let initial-post (setup-range - increment) / 2
  let pos who - (3) ; one sled and its two attachment-points
  let orientation "horizontal"

  ifelse orientation = "horizontal"
  [
;    setxy ( (pos * 1.8 - 0.9) ) -26
    setxy ( (pos * increment - initial-post) ) -26
    set heading 0
  ]
  [
    setxy 1 ( - (pos * 1.5 - 0.75) )
    set heading 90
  ]

  make_rudder
  (ifelse Dog-Connection-Point = "Center"
     [make_center_attachment_point]
   Dog-Connection-Point = "Rear"
    [make_rear_attachment_point]
  )

end



to make_sled ;; procedure to create sled and define its variables

  set size 5 / meters-per-patch ; sets length to 5 meters
  set width size * (0.3); sets width to 1.25 meters
  set len size ; same as size to simplift code later
  set velocity [0 0]
  set acceleration [ 0 0 ]
  set angular-velocity 0
  set angular-acceleration 0
  set inputs (list 0 0) ; inputs are forward thrust and angle of thrust (sled is currently is not self-actuated)
  set heading 0 ; 0 is pointing north and 90 is pointing east such that the angle increases as you go around clockwise
  set mass 50 ; mass in kg
  set Ig 0.1 ; moment of inertia

  set rot-drag-coef 0.5 ; value for rotational drag (need to find true val)
  set k-d 4.52 * 2 ; friction coefficient (need to find real coef)
  set k-d-lateral 45 * 4 ; lateral friction coefficient (need to find real coef)


  set color green
  set shape "boat"

   setxy 0 -30

  make_upper_right_attachment_point
  make_upper_left_attachment_point

end



to make_rudder
hatch-rudders 1 ; makes the rudder at the rear
 [
   set size 0.5 / meters-per-patch
   set color black
   set shape "rudder"

   ; at this point, we are asking the dogs to each make a rudder and then ask the rudders to set their variables

   ; "myself" here then represents the dogs, "self" would instead be the rudders
   setxy ([xcor] of myself - ([size] of myself / 2) * sin([heading] of myself)) ([ycor] of myself - ([size] of myself / 2) * cos([heading] of myself))
   set heading (- ([item 1 inputs] of myself) + [heading] of myself + 180)
   set attached-to-ID [who] of myself
 ]

end



to make_center_attachment_point
  hatch-attachment-points 1 ; center attachment point
  [
    set size 0.5 / meters-per-patch
    set color black
    set shape "attachment-point"


    let cx [xcor] of myself
    let cy [ycor] of myself

    setxy cx cy
    set color blue

    set attached-to-ID [who] of myself
    set my-side "center"

    ifelse (attached-to-ID - 3) / number-of-dogs >= 0.5
    [
      create-link-with attachment-point (1) ;  connect to sled's right side if ID is upper half of dog ID's
    ]
    [
      create-link-with attachment-point (2) ;  connect to sled's left side if ID is lower half of dog ID's
    ]
   ]
end

to make_rear_attachment_point
  hatch-attachment-points 1 ; center attachment point
  [
    set size 0.5 / meters-per-patch
    set color white
    set shape "attachment-point"

    let D [len] of myself * 0.5
    let B 0

    let Ang2 (- [heading] of myself) +   (90 + atan  (B) (D) )

    let cx ([xcor] of myself - D  * cos(Ang2))
    let cy ([ycor] of myself - D  * sin(Ang2))

    setxy cx cy
    set color blue

    set attached-to-ID [who] of myself
    set my-side "rear"

    ifelse (attached-to-ID - 3) / number-of-dogs >= 0.5
    [
      create-link-with attachment-point (1) ;  connect to sled's right side if ID is upper half of dog ID's
    ]
    [
      create-link-with attachment-point (2) ;  connect to sled's left side if ID is lower half of dog ID's
    ]


   ]
end



to make_upper_left_attachment_point
  hatch-attachment-points 1 ; makes attachment point on front left
 [
   set size 0.5 / meters-per-patch
   set color black
   set shape "attachment-point"
   let D [len] of myself * 0.3
   let B [width] of myself * 0.6

   let D_GC2 sqrt((B) ^ 2 + (D) ^ 2)
   let Ang2 (- [heading] of myself) +   (90 + atan  (B) (D) )

   let cx ([xcor] of myself + D_GC2  * cos(Ang2))
   let cy ([ycor] of myself + D_GC2  * sin(Ang2))

   setxy cx cy
   set color blue

   set attached-to-ID [who] of myself
   set my-side "left"
  ]

end



to make_upper_right_attachment_point
 hatch-attachment-points 1 ; makes attachment point at front right
 [
   set size 0.5 / meters-per-patch
   set color black
   set shape "attachment-point"
   let D [len] of myself * 0.3
   let B [width] of myself * 0.6

   let D_GC1 sqrt((B) ^ 2 + (D) ^ 2)
   let Ang1 (- [heading] of myself) + (atan (D) (B) )

   let cx ([xcor] of myself + D_GC1  * cos(Ang1))
   let cy ([ycor] of myself + D_GC1  * sin(Ang1))

   setxy cx cy
   set heading ([heading] of myself )
   set attached-to-ID [who] of myself
   set my-side "right"
  ]

end

;;
;; Runtime Procedures
;;
to go
  clear_paint ; resests patch colors to white

   ifelse show_path?
     [
       ask sleds [pd] ; pd = pen down command
       ask dogs [pd]
     ]
     [
       ask sleds [pu] ; pu = pen up command
       ask dogs [pu]
       clear-drawing
     ]


  ask links ; display when "rope" is taut (red), or has slack (black)
  [
   ifelse link-length > rope-length / meters-per-patch
     [set color red]
     [set color black]
  ]


  ask sleds
  [
    sled_dynamics
    do_collisions
    update_state
    carry_attachment_points ; command to move attachment-points with the sled
  ]


  ask dogs
  [
    dog_dynamics
    do_collisions
    update_state
    carry_rudder ; procedure to move rudder with dog
    carry_attachment_points ; command to move attachment-point with the dog

    ifelse color = blue ; only blue dogs are controlled by keys
      [
        set inputs (list drive_motor motor-angle)
      ]
      [
        set inputs (list drive_motor 0)
      ]
  ]

  ask attachment-point 2
  [
    calculate-tether-acceleration
  ]

  tick-advance 1
end



to carry_rudder
  ask rudders with [attached-to-ID = [who] of myself]
  [
    set old-x xcor
    set old-y ycor

    setxy ([xcor] of myself - ([size] of myself / 2) * sin([heading] of myself)) ([ycor] of myself - ([size] of myself / 2) * cos([heading] of myself))
    set heading (-([item 1 inputs] of myself) + [heading] of myself + 180)
  ]

end

to carry_attachment_points ; updates the positions of the attachment points
  ask attachment-points with [attached-to-ID = [who] of myself] ; attached-to-ID is a variable for who the attachment point is connected to, "who" is the ID of the turtle
  [
    let cx 0
    let cy 0

    (ifelse my-side = "right"
    [
      let D [len] of myself * 0.3
      let B [width] of myself * 0.6

      let D_GC1 sqrt((B) ^ 2 + (D) ^ 2)
      let Ang1 (- [heading] of myself) + (atan (D) (B) )

      let cx1 ([ycor] of myself + D_GC1  * sin(Ang1))
      let cy1 ([xcor] of myself + D_GC1  * cos(Ang1))

      set cx cy1
      set cy cx1
    ]
    my-side = "left"
    [
      let D [len] of myself * 0.3
      let B [width] of myself * 0.6

      let D_GC2 sqrt((B) ^ 2 + (D) ^ 2)
      let Ang2 (- [heading] of myself) +   (90 + atan  (B) (D) )


      let cx1 ([ycor] of myself + D_GC2  * sin(Ang2))
      let cy1 ([xcor] of myself + D_GC2  * cos(Ang2))

      set cx cy1
      set cy cx1
    ]
    my-side = "rear"
    [
      let D [len] of myself * 0.5
      let B 0

      let D_GC2 sqrt((B) ^ 2 + (D) ^ 2)
      let Ang2 (- [heading] of myself) +   (90 + atan  (B) (D) )


      let cx1 ([ycor] of myself - D_GC2  * sin(Ang2))
      let cy1 ([xcor] of myself - D_GC2  * cos(Ang2))

      set cx cy1
      set cy cx1
    ]
    my-side = "center"
    [
      set cx [xcor] of myself
      set cy [ycor] of myself
    ]
    )

    setxy cx cy
    set heading ([heading] of myself )

    set vx cx - old-x
    set vy cy - old-y

    set old-x cx
    set old-y cy
  ]

end



to angle_motor_right ; procedure for when "D" key is pressed
    set motor-angle motor-angle + 1
end

to angle_motor_left ; procedure for when "A" key is pressed
    set motor-angle motor-angle - 1
end

to increase_thrust ; procedure for when "W" key is pressed
    set drive_motor drive_motor + 1
end

to decrease_thrust ; procedure for when "D" key is pressed
    set drive_motor drive_motor - 1
end



;to sled_dynamics
;
;  calculate_acceleration_without_tether
;
;  ;;; tether tow calculations
;  let D len * 0.3 ; vertical position of attachment point (along length of agent)
;  let B width * 0.6 ; horizontal  position of attachment point (along length of agent)
;
;  let c1 attachment-point count sleds ; right attachment point
;  let c2 attachment-point (count sleds + 1) ; left attachment point
;
;
;  ifelse [count my-links] of c1 + [count my-links] of c2 > 0 ; only calculate tether force if both attachment points are linked to something
;  [
;
;     let tug1 dog [attached-to-ID] of ([one-of link-neighbors] of c1) ; dog tied to right attachment-points
;     let tug2 dog [attached-to-ID] of ([one-of link-neighbors] of c2) ; dog tied to left attachment-points
;
;     ; set point of attachment of tugs (in case it isn't at the dogs center)
;     let c_tug1 one-of attachment-points with [attached-to-ID = [who] of tug1]
;     let c_tug2 one-of attachment-points with [attached-to-ID = [who] of tug2]
;
;     ; initialize angle variables
;     let w1 0
;     let w2 0
;
;     ifelse (- [xcor] of c1 + [xcor] of c_tug1) = 0 and (- [ycor] of c1 + [ycor] of c_tug1) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
;       [set w1 0]
;       [set w1 (atan (- [xcor] of c1 + [xcor] of c_tug1) (- [ycor] of c1 + [ycor] of c_tug1)) - heading]
;
;     ifelse (- [xcor] of c2 + [xcor] of tug2) = 0 and (- [ycor] of c2 + [ycor] of c_tug2) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
;       [set w2 0]
;       [set w2 (atan (-[xcor] of c2 + [xcor] of c_tug2) (-[ycor] of c2 + [ycor] of c_tug2))  - heading]
;
;     ; wrap angle to be within [-180, 180)
;     set w1 angle_wrap w1
;     set w2 angle_wrap w2
;
;
;
;
;     let Dgp1 (D - (B * 0.5)*(tan(w1)))* sin(w1) ; arm of force on c1 to the center of gravity
;     let Dgp2 (D - (B * 0.5)*(tan(w2)))* sin(w2) ; arm of force on c2 to the center of gravity
;
;    ;initialize tow forces locally
;     let Ftow1 0
;     let Ftow2 0
;
;     ifelse [distance c_tug1] of c1 > (rope-length / meters-per-patch)  ; only enact force if the rope is "taut"
;     [
;       set Ftow1 [Ftow] of tug1
;     ]
;     [
;       set Ftow1 0
;     ]
;
;     ifelse [distance c_tug2] of c2 > (rope-length / meters-per-patch) ; only enact force if the rope is "taut"
;     [
;       set Ftow2 [Ftow] of tug2
;     ]
;     [
;       set Ftow2 0
;     ]
;
;     ; calculate acceleration components from tether in body frame
;     let tether-accel-x1 (Ftow1 * cos(w1) + Ftow2 * cos(w2)) / mass
;     let tether-accel-y1 (Ftow1 * sin(w1) + Ftow2 * sin(w2)) / mass
;
;     set tether-accel-angular (((Ftow1 * Dgp1) + (Ftow2 * Dgp2))) * 180 / pi ; find torque in degrees
;
;     ifelse tether-accel-angular < 0 ; bound the torque value
;       [set tether-accel-angular max(list tether-accel-angular -50)]
;       [set tether-accel-angular min (list tether-accel-angular 50)]
;
;
;     ; calculate acceleration components from tether in world frame
;     set tether-accel-x ((tether-accel-x1 * sin(heading)) - (tether-accel-y1 * cos(heading)))
;     set tether-accel-y ((tether-accel-x1 * cos(heading)) + (tether-accel-y1 * sin(heading)))
;
;
;  ]
;  [
;    set tether-accel-angular 0
;    set tether-accel-x 0
;    set tether-accel-y 0
;  ]
;
;  ; combine accelerations
;  set a-x a-x-no-tether  + tether-accel-x
;  set a-y a-y-no-tether  + tether-accel-y
;
;  set acceleration (list a-x a-y)
;  set angular-acceleration angular-acceleration-no-tether + tether-accel-angular
;
;  ; update velocities
;  set velocity (list (item 0 velocity + (a-x * tick-delta)) (item 1 velocity + (a-y * tick-delta)) )
;  set angular-velocity (angular-velocity + (angular-acceleration * tick-delta) + impact-heading)
;
;end

to sled_dynamics

  calculate_acceleration_without_tether

  ;;; tether tow calculations
  let D len * 0.3 ; vertical position of attachment point (along length of agent)
  let B width * 0.6 ; horizontal  position of attachment point (along length of agent)

  let c1 attachment-point count sleds ; right attachment point
  let c2 attachment-point (count sleds + 1) ; left attachment point

  ask c1
  [
    calculate-tether-acceleration
  ]

  ask c2
  [
    calculate-tether-acceleration
  ]

  ; above has the attachment points try to calculate the forces from the tethers, the goal will be to then take the variables for acceleration components saved to the attachment-point
  ; next should be to pull the values from the attach-points and then combine them to get the true acceleration components for the sled and the dog later as well, then
  ; all the tether calculation could be done in one procedure rather than for each agent dynamics, also this will allow multiple tethers connected to one point


  ifelse [count my-links] of c1 + [count my-links] of c2 > 0 ; only calculate tether force if both attachment points are linked to something
  [

     let tug1 dog [attached-to-ID] of ([one-of link-neighbors] of c1) ; dog tied to right attachment-points
     let tug2 dog [attached-to-ID] of ([one-of link-neighbors] of c2) ; dog tied to left attachment-points

     ; set point of attachment of tugs (in case it isn't at the dogs center)
     let c_tug1 one-of attachment-points with [attached-to-ID = [who] of tug1]
     let c_tug2 one-of attachment-points with [attached-to-ID = [who] of tug2]

     ; initialize angle variables
     let w1 0
     let w2 0

     ifelse (- [xcor] of c1 + [xcor] of c_tug1) = 0 and (- [ycor] of c1 + [ycor] of c_tug1) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
       [set w1 0]
       [set w1 (atan (- [xcor] of c1 + [xcor] of c_tug1) (- [ycor] of c1 + [ycor] of c_tug1)) - heading]

     ifelse (- [xcor] of c2 + [xcor] of tug2) = 0 and (- [ycor] of c2 + [ycor] of c_tug2) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
       [set w2 0]
       [set w2 (atan (-[xcor] of c2 + [xcor] of c_tug2) (-[ycor] of c2 + [ycor] of c_tug2))  - heading]

     ; wrap angle to be within [-180, 180)
     set w1 angle_wrap w1
     set w2 angle_wrap w2




     let Dgp1 (D - (B * 0.5)*(tan(w1)))* sin(w1) ; arm of force on c1 to the center of gravity
     let Dgp2 (D - (B * 0.5)*(tan(w2)))* sin(w2) ; arm of force on c2 to the center of gravity

    ;initialize tow forces locally
     let Ftow1 0
     let Ftow2 0

     ifelse [distance c_tug1] of c1 > (rope-length / meters-per-patch)  ; only enact force if the rope is "taut"
     [
       set Ftow1 [Ftow] of tug1
     ]
     [
       set Ftow1 0
     ]

   ifelse [distance c_tug2] of c2 > (rope-length / meters-per-patch) ; only enact force if the rope is "taut"
     [
       set Ftow2 [Ftow] of tug2
     ]
     [
       set Ftow2 0
     ]

     ; calculate acceleration components from tether in body frame
     let tether-accel-x1 (Ftow1 * cos(w1) + Ftow2 * cos(w2)) / mass
     let tether-accel-y1 (Ftow1 * sin(w1) + Ftow2 * sin(w2)) / mass

     set tether-accel-angular (((Ftow1 * Dgp1) + (Ftow2 * Dgp2))) * 180 / pi ; find torque in degrees

     ifelse tether-accel-angular < 0 ; bound the torque value
       [set tether-accel-angular max(list tether-accel-angular -50)]
       [set tether-accel-angular min (list tether-accel-angular 50)]


     ; calculate acceleration components from tether in world frame
     set tether-accel-x ((tether-accel-x1 * sin(heading)) - (tether-accel-y1 * cos(heading)))
     set tether-accel-y ((tether-accel-x1 * cos(heading)) + (tether-accel-y1 * sin(heading)))


  ]
  [
    set tether-accel-angular 0
    set tether-accel-x 0
    set tether-accel-y 0
  ]

  ; combine accelerations
  set a-x a-x-no-tether  + tether-accel-x
  set a-y a-y-no-tether  + tether-accel-y

  set acceleration (list a-x a-y)
  set angular-acceleration angular-acceleration-no-tether + tether-accel-angular

  ; update velocities
  set velocity (list (item 0 velocity + (a-x * tick-delta)) (item 1 velocity + (a-y * tick-delta)) )
  set angular-velocity (angular-velocity + (angular-acceleration * tick-delta) + impact-heading)

end

to calculate-tether-acceleration ; each attatchment point calculate the net force and direction

 ;;; tether tow calculations
   let D [len] of turtle attached-to-ID * 0.3 ; vertical position of attachment point (along length of agent)
   let B [width] of turtle attached-to-ID * 0.6 ; horizontal  position of attachment point (along length of agent)

   let linked-with-set link-neighbors
   let linked-with-list (list)

   let i 0
   while [i < count turtles]
   [
     if member? turtle i  linked-with-set
     [set linked-with-list fput (turtle i) linked-with-list]
     set i (i + 1)
   ]

   let linked-with-main-bodies-list (list )

   let tether-accel-x-list (list )
   let tether-accel-y-list (list )

   foreach linked-with-list [ j ->

     set linked-with-main-bodies-list fput (turtle [attached-to-ID] of j) linked-with-main-bodies-list
     let w1 0

    ifelse ( [xcor] of j - xcor) = 0 and ( [ycor] of j - ycor) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
      [set w1 0]
      [set w1 (- (90 - [heading] of turtle attached-to-ID) + (90 - atan ( [xcor] of j - xcor) ( [ycor] of j - ycor) ) )]

     set w1 angle_wrap w1

     let Dgp1 (D - (B * 0.5)*(tan(w1)))* sin(w1) ; arm of force on c1 to the center of gravity

     let Ftow1 0

     let K rope-stiffness
     let damp-coef 0.1 * sqrt(4 * [mass] of turtle attached-to-ID * K)


     let Ftow1_x (K * abs(xcor - [xcor] of j)) + (damp-coef * abs(vx - [vx] of j ))
     let Ftow1_y (K * abs(ycor - [ycor] of j)) + (damp-coef * abs(vy - [vy] of j ))

     let Ftow_mag 0


     ifelse distance j > (rope-length / meters-per-patch) ; only sets the tether force if rope is 'taut'
     [
       set Ftow_mag sqrt((Ftow1_x) ^ 2 + (Ftow1_y) ^ 2)
     ]
     [
       set Ftow_mag 0
     ]

     ; calculate acceleration components from tether in body frame
     let tether-accel-x1-body (Ftow_mag * cos(w1) * 1 ) / [mass] of turtle attached-to-ID
     let tether-accel-y1-body (Ftow_mag * sin(w1) * 1) / [mass] of turtle attached-to-ID

      ; calculate acceleration components from tether in world frame
      let tether-accel-x1 ((tether-accel-x1-body * sin([heading] of turtle attached-to-ID)) - (tether-accel-y1-body * cos([heading] of turtle attached-to-ID)))
      let tether-accel-y1 ((tether-accel-x1-body * cos([heading] of turtle attached-to-ID)) + (tether-accel-y1-body * sin([heading] of turtle attached-to-ID)))

      set tether-accel-x-list lput tether-accel-x1 tether-accel-x-list
      set tether-accel-y-list lput tether-accel-y1 tether-accel-y-list

   ]

   set tether-accel-x-sum sum tether-accel-x-list
   set tether-accel-y-sum sum tether-accel-y-list

;   print tether-accel-y-sum

   ; i think the reason that this accel-y isn't matching the previous calc accel-y is because it is combining the values (maybe need to average them)




;   ; set point of attachment of tugs (in case it isn't at the dogs center)
;   let c_tug1 one-of attachment-points with [attached-to-ID = [who] of tug1]
;   let c_tug2 one-of attachment-points with [attached-to-ID = [who] of tug2]
;
;   ; initialize angle variables
;   let w1 0
;   let w2 0
;
;   ifelse (- [xcor] of c1 + [xcor] of c_tug1) = 0 and (- [ycor] of c1 + [ycor] of c_tug1) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
;     [set w1 0]
;     [set w1 (atan (- [xcor] of c1 + [xcor] of c_tug1) (- [ycor] of c1 + [ycor] of c_tug1)) - heading]
;
;   ifelse (- [xcor] of c2 + [xcor] of tug2) = 0 and (- [ycor] of c2 + [ycor] of c_tug2) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
;     [set w2 0]
;     [set w2 (atan (-[xcor] of c2 + [xcor] of c_tug2) (-[ycor] of c2 + [ycor] of c_tug2))  - heading]
;
;   ; wrap angle to be within [-180, 180)
;   set w1 angle_wrap w1
;   set w2 angle_wrap w2
;
;
;
;
;   let Dgp1 (D - (B * 0.5)*(tan(w1)))* sin(w1) ; arm of force on c1 to the center of gravity
;   let Dgp2 (D - (B * 0.5)*(tan(w2)))* sin(w2) ; arm of force on c2 to the center of gravity
;
;  ;initialize tow forces locally
;   let Ftow1 0
;   let Ftow2 0
;
;   ifelse [distance c_tug1] of c1 > (rope-length / meters-per-patch)  ; only enact force if the rope is "taut"
;   [
;     set Ftow1 [Ftow] of tug1
;   ]
;   [
;     set Ftow1 0
;   ]
;
;   ifelse [distance c_tug2] of c2 > (rope-length / meters-per-patch) ; only enact force if the rope is "taut"
;   [
;     set Ftow2 [Ftow] of tug2
;   ]
;   [
;     set Ftow2 0
;   ]
;
;   ; calculate acceleration components from tether in body frame
;   let tether-accel-x1 (Ftow1 * cos(w1) + Ftow2 * cos(w2)) / mass
;   let tether-accel-y1 (Ftow1 * sin(w1) + Ftow2 * sin(w2)) / mass
;
;   set tether-accel-angular (((Ftow1 * Dgp1) + (Ftow2 * Dgp2))) * 180 / pi ; find torque in degrees
;
;   ifelse tether-accel-angular < 0 ; bound the torque value
;     [set tether-accel-angular max(list tether-accel-angular -50)]
;     [set tether-accel-angular min (list tether-accel-angular 50)]
;
;
;   ; calculate acceleration components from tether in world frame
;   set tether-accel-x ((tether-accel-x1 * sin(heading)) - (tether-accel-y1 * cos(heading)))
;   set tether-accel-y ((tether-accel-x1 * cos(heading)) + (tether-accel-y1 * sin(heading)))


end




to dog_dynamics

  calculate_acceleration_without_tether

  let v_x item 0 velocity ; x component of velocity
  let v_y item 1 velocity ; y component of velocity

  ;;; tether tow calculations
  let D len * 0.3
  let B width * 0.6

  let c1 one-of attachment-points with [attached-to-ID = [who] of myself] ; set c1 as the attachment point of the dog


  ifelse [count links] of c1 > 0
  [
    let connected-point ([one-of link-neighbors] of c1) ; the attachment-point that my point is tied to

    ; initialize angle variable
    let w1 0

    ifelse ( [xcor] of connected-point - [xcor] of c1) = 0 and ( [ycor] of connected-point - [ycor] of c1) = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
      [set w1 0]
      [set w1 (- (90 - heading) + (90 - atan ( [xcor] of connected-point - [xcor] of c1) ( [ycor] of connected-point - [ycor] of c1) ) )]

    ; wrap angle to be within [-180, 180)
    set w1 angle_wrap (w1)

    ;initialize variable
    let Dgp1 0

    (ifelse [my-side] of c1 = "center"
    [
      set Dgp1 0
    ]
    [my-side] of c1 = "rear"
    [
      set Dgp1 (D )* sin(w1)
    ]
    )


    let K rope-stiffness
    let damp-coef 0.1 * sqrt(4 * mass * K)


    let Ftow1_x (K * abs([xcor] of c1 - [xcor] of connected-point)) + (damp-coef * abs([vx] of c1 - [vx] of connected-point ))
    let Ftow1_y (K * abs([ycor] of c1 - [ycor] of connected-point)) + (damp-coef * abs([vy] of c1 - [vy] of connected-point ))


    ifelse [distance connected-point] of c1 > (rope-length / meters-per-patch) ; only sets the tether force if rope is 'taut'
    [
      set Ftow sqrt((Ftow1_x) ^ 2 + (Ftow1_y) ^ 2)
    ]
    [
      set Ftow 0
    ]

    ; calculate acceleration components from tether in body frame
    let tether-accel-x1 (Ftow * cos(w1) * 1 ) / mass
    let tether-accel-y1 (Ftow * sin(w1) * 1) / mass

     ; calculate acceleration components from tether in world frame
     set tether-accel-x ((tether-accel-x1 * sin(heading)) - (tether-accel-y1 * cos(heading)))
     set tether-accel-y ((tether-accel-x1 * cos(heading)) + (tether-accel-y1 * sin(heading)))

    set tether-accel-angular (Ftow * Dgp1) * 180 / pi

  ]
  [
    set tether-accel-angular 0
    set tether-accel-x 0
    set tether-accel-y 0
  ]


  ; combine accelerations
  set a-x a-x-no-tether  + tether-accel-x
  set a-y a-y-no-tether  + tether-accel-y

  set acceleration (list a-x a-y)
  set angular-acceleration angular-acceleration-no-tether + tether-accel-angular


  ; update velocities
  set velocity (list (item 0 velocity + (a-x * tick-delta)) (item 1 velocity + (a-y * tick-delta)) )
  set angular-velocity (angular-velocity + (angular-acceleration * tick-delta))

end



to calculate_acceleration_without_tether
    let v_x item 0 velocity ; x component of velocity
    let v_y item 1 velocity ; y component of velocity
    let resultant_v sqrt(v_x ^ 2 + v_y ^ 2)



    let ell len / 2 ; length of lever arm from motor to center of mass is half the length of the whole agent
    set drag-heading (rot-drag-coef * angular-velocity)

    let f_drive (item 0 inputs) / meters-per-patch ; force of forwawrd thrust (Newtons) multiplied by meter-per-patch to convert it properly
    let motor_angle item 1 inputs ; angle of motor angle

    let alpha 0 ; initializing angle of true resultant velocity in world coordinate

    ifelse v_x = 0 and v_y = 0 ; checks to make sure atan can be used (if the first argument is zero it sometimes creates an error)
      [set alpha 0]
      [set alpha atan v_x v_y]

    set alpha angle_wrap alpha ; "angle_wrap" is a reporter defined at very bottom of code that just helps simplify what the angle is

    let angle-offset (heading - alpha) ; angle between the true direction of velocity and the heading of the sled

    ; calculate velocity in body frame
    let v_forward resultant_v * cos(angle-offset)
    let v_sideways resultant_v * sin(angle-offset)

    ; calculate drag in body frame
    let drag_forward (k-d * v_forward)
    let drag_sideways(k-d-lateral * v_sideways)
    let body_drag-x (- drag_forward)
    let body_drag-y (- drag_sideways)

    ; calculate acceleration in body frame
    let body_a-x (f_drive * cos(motor_angle) + body_drag-x) / mass
    let body_a-y (f_drive * sin(motor_angle) + body_drag-y) / mass

    ; convert acceleration (without the effects of the tether) to world frame
    set a-x-no-tether ((body_a-x * sin(heading)) - (body_a-y * cos(heading)))
    set a-y-no-tether ((body_a-x * cos(heading)) + (body_a-y * sin(heading)))

    set angular-acceleration-no-tether (((1) * ell * f_drive * sin(motor_angle) - drag-heading) / Ig )

end



to do_collisions ; checks to see if the agent is touching the ellipsoidal body_diff of the nearest_neighbor

  let nearest_neighbor min-one-of other turtles with [breed != rudders and breed != attachment-points] [distance myself]

  let h1 xcor ; sets h1 to own x coordinate
  let k1 ycor ; sets k1 to own y coordinate
  let a1 len / 2 ; sets a1 to be half of length (ie major axis )
  let b1 width / 2 ; sets a1 to be half of width (ie minor axis )
  let ang1 (90 - heading) ; set ang1 to the "real" angle in standard coordinates

  let h2 [xcor] of nearest_neighbor ; sets h2 to neighbors x coordinate
  let k2 [ycor] of nearest_neighbor ; sets k2 to neighbors y coordinate
  let a2 [len / 2] of nearest_neighbor ; sets a2 to be half of length of neighbors(ie major axis )
  let b2 [width / 2] of nearest_neighbor ; sets b2 to be half of width of neighbors(ie minor axis )
  let ang2 [(90 - heading)] of nearest_neighbor ; set ang2 to the "real" angle in standard coordinates

  let collision? false ; initalize
  let num-points 10 ; number of points around main agent to check overlap

  let angle_set n-values num-points [i -> 360 * i / num-points] ; makes a list of num-points to get all the increments around ellipse

  foreach angle_set [j ->  ;;iterates points around main agent to check if overlap with second agent

    ; angle of point around ellipse
    let theta j

    ; parametric point on ellipse 1 (before rotation)
    let x0 a1 * cos theta
    let y0 b1 * sin theta

    ; rotate by ang1 and translate to main's center
    let x (x0 * cos ang1 - y0 * sin ang1 + h1)
    let y (x0 * sin ang1 + y0 * cos ang1 + k1)


    ; Check if (x, y) is inside agent 2
    let dx1 (x - h2)
    let dy1 (y - k2)

    let value (
      ((dx1 * cos ang2 + dy1 * sin ang2) ^ 2) / (a2 ^ 2) +
      ((dx1 * sin ang2 - dy1 * cos ang2) ^ 2) / (b2 ^ 2)
    )

    if value <= 1 [
      set collision? true
    ]
  ]

  ifelse collision? = true
 [
   set nearest-neighbor-touching-flag  1
 ]
 [
   set nearest-neighbor-touching-flag  0
 ]



  ifelse nearest-neighbor-touching-flag = 1 and (abs(towards nearest_neighbor - heading) < 90) ; checks to see if agent is touching another and if the contact point is in its front half (otherwise it doesn't stop)
  [
     set impact-x  (-1 * item 0 velocity)
     set impact-y  (-1 * item 1 velocity)
     set impact-heading  (-1 * angular-velocity)

  ]
  [
    set impact-x 0
    set impact-y 0
    set impact-heading 0
  ]

end



to update_state

  if impact-x != 0 ; if a collision occurs, it make sure to halt the velocity so the agent doesn't keep moving
  [
    set velocity (list 0 (item 1 velocity))
  ]
  if impact-y != 0 ; if a collision occurs, it make sure to halt the velocity so the agent doesn't keep moving
  [
    set velocity (list (item 0 velocity) 0 )
  ]

  let nxcor xcor + ( item 0 velocity * tick-delta )
  let nycor ycor + ( item 1 velocity * tick-delta)

  ; makes sure agents don't go through edge (if the calculated next position is more than the boundary, it just forces the agent to stay in place)
  if nxcor > (max-pxcor - size / 2) or nxcor < (min-pxcor  + size / 2)
   [
     set nxcor xcor
     set nycor ycor
     set velocity (list 0 (item 1 velocity))
   ]

  if nycor > (max-pycor - size / 2) or nycor < (min-pycor  + size / 2)
    [ set nycor ycor
      set nxcor xcor
      set velocity (list (item 0 velocity) 0)
  ]

  setxy nxcor nycor

  let nheading heading + (angular-velocity * tick-delta)
  set heading nheading

end



to clear_paint
ask patches
      [
       set pcolor white
      ]
end



to-report angle_wrap [angle]
ifelse angle < -180
    [
      set angle angle + 360
     ]
    [
      ifelse angle > 180
      [set angle angle - 360]
      [set angle angle]
    ]
    report angle

end
@#$#@#$#@
GRAPHICS-WINDOW
735
17
1329
612
-1
-1
7.235
1
10
1
1
1
0
0
0
1
-40
40
-40
40
1
1
1
ticks
30.0

BUTTON
32
22
98
55
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
105
22
168
55
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

SLIDER
205
25
297
58
seed-no
seed-no
0
20
0.0
1
1
NIL
HORIZONTAL

SWITCH
312
26
441
59
show_path?
show_path?
1
1
-1000

SLIDER
558
404
694
437
meters-per-patch
meters-per-patch
0.25
5
1.0
0.25
1
NIL
HORIZONTAL

BUTTON
474
300
617
333
Angle Motor Right
angle_motor_right
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
254
299
388
332
Angle Motor Left
angle_motor_left
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

SLIDER
28
86
200
119
number-of-dogs
number-of-dogs
2
10
2.0
2
1
NIL
HORIZONTAL

SLIDER
27
128
199
161
rope-length
rope-length
0
6
6.0
0.5
1
m
HORIZONTAL

SLIDER
149
860
329
893
rope-stiffness
rope-stiffness
0
100
3.0
1
1
KN/M
HORIZONTAL

BUTTON
454
28
555
61
Clear Paths
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
560
28
704
61
Disconnect Tether
ask links [die]
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
27
275
199
308
drive_motor
drive_motor
0
20
3.0
1
1
N
HORIZONTAL

SLIDER
25
314
197
347
motor-angle
motor-angle
-30
30
0.0
2
1
deg
HORIZONTAL

PLOT
59
493
700
853
Plot for Testing
NIL
NIL
0.0
0.1
0.0
0.1
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
377
253
505
286
Increase Thrust
increase_thrust
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
385
350
518
383
Decrease Thrust
decrease_thrust
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

CHOOSER
241
129
407
174
Dog-Connection-Point
Dog-Connection-Point
"Center" "Rear"
0

@#$#@#$#@
## WHAT IS IT?

Blank for now
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

attachment-point
true
0
Polygon -7500403 true true 0 150 15 90 30 60 60 30 120 0 180 0 240 30 270 60 285 90 300 150 255 150 240 105 210 60 180 45 120 45 90 60 60 105 45 150 0 150
Polygon -7500403 true true 300 150 285 210 270 240 240 270 180 300 120 300 60 270 30 240 15 210 0 150 45 150 60 195 90 240 120 255 180 255 210 240 240 195 255 150 300 150

boat
true
0
Polygon -7500403 true true 150 0 120 0 110 17 105 44 105 45 105 255 105 285 120 300 150 300 180 300 195 285 195 255 195 45 191 18 180 0 150 0 105 120
Polygon -1 true false 150 0 135 45 165 45 150 0

boat2
true
0
Polygon -7500403 true true 150 0 120 0 110 17 105 44 105 45 105 255 105 285 120 300 150 300 180 300 195 285 195 255 195 45 191 18 180 0 150 0 105 120
Polygon -1 true false 150 0 135 45 165 45 150 0

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
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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

rudder
true
0
Rectangle -7500403 true true 60 30 240 75
Rectangle -7500403 true true 120 75 180 150

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
Rectangle -7500403 true true 30 30 270 270

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
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

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
