/obj/effect/proc_holder/spell/invoked/blindness
	name = "Blindness"
	overlay_state = "blindness"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	invocation = "Noc blinds thee of thy sins!"
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	charge_max = 15 SECONDS
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/blindness/cast(list/targets, mob/user = usr)
	..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message("<span class='warning'>[user] points at [target]'s eyes!</span>","<span class='warning'>My eyes are covered in darkness!</span>")
		target.blind_eyes(2)
	return TRUE

/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	overlay_state = "invisibility"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	charge_max = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	sound = 'sound/misc/area.ogg' //This sound doesnt play for some reason. Fix me.
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 45

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message("<span class='warning'>[target] starts to fade into thin air!</span>", "<span class='notice'>You start to become invisible!</span>")
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + 15 SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 15 SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), "<span class='warning'>[target] fades back into view.</span>", "<span class='notice'>You become visible again.</span>"), 15 SECONDS)
		..()
	return FALSE

/obj/effect/proc_holder/spell/aoe_turf/timestop/rogue
	name = "Stop Time"
	desc = ""
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	charge_max = 50 SECONDS
	invocation = "Noc prohibits you to act!"
	invocation_type = "shout"
	range = 0
	cooldown_min = 100
	action_icon_state = "time"
	timestop_range = 3
	timestop_duration = 100
	miracle = TRUE
	devotion_cost = 45
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/aoe_turf/timestop/rogue/cast(list/targets, mob/user = usr)
	..()
	new /obj/effect/timestop/magic(get_turf(user), timestop_range, timestop_duration, list(user))
