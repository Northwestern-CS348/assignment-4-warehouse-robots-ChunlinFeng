(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )





   (:action robotMove
      :parameters (?r - robot ?from - location ?target - location)
      :precondition (and (at ?r ?from) (connected ?from ?target) (no-robot ?target) )
      :effect (and (at ?r ?target) (free ?r) (no-robot ?from) (not (at ?r ?from)) (not (no-robot ?target)) )
   )
   
   
    (:action robotMoveWithPallette
      :parameters (?r - robot ?from - location ?target - location ?p - pallette)
      :precondition (and (or (has ?r ?p) (and (free ?r) (at ?p ?from))) (at ?r ?from) (connected ?from ?target) (no-robot ?target) (no-pallette ?target))
      :effect (and  (at ?p ?target) (at ?r ?target) (no-pallette ?from) (no-robot ?from) (not (at ?p ?from)) (not (at ?r ?from)) (not (no-robot ?target))   )
   )
   
   
   
   
    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-location ?l) (packing-at ?s ?l)  (at ?p ?l) (ships ?s ?o) (started ?s) (orders ?o ?si) (contains ?p ?si))
      :effect (and (includes ?s ?si) (at ?p ?l) (not(contains ?p ?si)) )
   )
   
   
   
   
    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (ships ?s ?o) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l)   )
      :effect (and (available ?l) (complete ?s) (not (started ?s)) (not (packing-at ?s ?l)) )
   )

)
