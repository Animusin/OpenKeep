//eorite

/obj/effect/proc_holder/spell/invoked/bud
	name = "Eoran Bloom"
	desc = ""
	clothes_req = FALSE
	range = 7
	overlay_state = "love"
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psycross/silver)
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	charge_max = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/bud/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(!isclosedturf(T))
		new /obj/item/clothing/head/peaceflower(T)
		..()
		return TRUE
	to_chat(user, "<span class='warning'>The targeted location is blocked. The flowers of Eora refuse to grow.</span>")
	return FALSE

/obj/effect/proc_holder/spell/invoked/projectile/eoracurse
	name = "Eora's Curse"
	overlay_state = "curse2"
	releasedrain = 50
	chargetime = 30
	range = 7
	projectile_type = /obj/projectile/magic/eora
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psycross/silver)
	sound = 'sound/magic/whiteflame.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	charge_max = 10 SECONDS


/obj/projectile/magic/eora
	name = "wine bubble"
	icon_state = "leaper"
	paralyze = 50
	damage = 0
	range = 7
	hitsound = 'sound/blank.ogg'
	nondirectional_sprite = TRUE
	impact_effect_type = /obj/effect/temp_visual/wine_projectile_impact

/obj/projectile/magic/eora/on_hit(atom/target, blocked = FALSE)
	..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.visible_message("<span class='info'>A purple haze shrouds [target]!</span>", "<span class='notice'>I feel like I've been drinking incredible amounts of wine...</span>")
		C.reagents.add_reagent(/datum/reagent/berrypoison, 3)
		C.apply_status_effect(/datum/status_effect/buff/drunk)
		C.apply_status_effect(/datum/status_effect/debuff/pintledestruction)
//		C.reagents.add_reagent(/datum/reagent/moondust, 3)
//		C.reagents.add_reagent(/datum/reagent/consumable/ethanol/beer/wine, 3)
		return
//	if(isanimal(target))
//		var/mob/living/simple_animal/L = target
//		L.adjustHealth(25)

/obj/projectile/magic/eora/on_range()
	var/turf/T = get_turf(src)
	..()
	new /obj/structure/wine_bubble(T)

/obj/effect/temp_visual/wine_projectile_impact
	name = "wine bubble"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper_bubble_pop"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 3

/obj/structure/wine_bubble
	name = "wine bubble"
	desc = ""
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper"
	max_integrity = 10
	density = FALSE

/obj/structure/wine_bubble/Initialize()
	. = ..()
	float(on = TRUE)
	QDEL_IN(src, 100)

/obj/structure/wine_bubble/Destroy()
	new /obj/effect/temp_visual/wine_projectile_impact(get_turf(src))
	playsound(src,'sound/blank.ogg',50, TRUE, -1)
	return ..()

/obj/structure/wine_bubble/Crossed(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		playsound(src,'sound/blank.ogg',50, TRUE, -1)
		L.Paralyze(50)
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.reagents.add_reagent(/datum/reagent/berrypoison, 3)
			C.apply_status_effect(/datum/status_effect/buff/drunk)
			C.apply_status_effect(/datum/status_effect/debuff/pintledestruction)
			C.visible_message("<span class='info'>A purple haze shrouds [L]!</span>", "<span class='notice'>I feel incredibly drunk...</span>")
//		if(isanimal(L))
//			var/mob/living/simple_animal/A = L
//			A.adjustHealth(25)
		qdel(src)
	return ..()


/obj/effect/proc_holder/spell/invoked/eoracurse/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/druqks)
		target.apply_status_effect(/datum/status_effect/buff/drunk)
		target.visible_message("<span class='info'>A purple haze shrouds [target]!</span>", "<span class='notice'>I feel much calmer.</span>")
		target.blur_eyes(10)
		..()
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/targeted/mind_transfer/rogue
	name = "Mind Transfer"
	desc = ""
	charge_max = 60 SECONDS
	clothes_req = FALSE
	invocation = "Let Eoar show you the world differently!"
	invocation_type = "whisper"
	range = 1
	cooldown_min = 200 //100 deciseconds reduction per rank
	unconscious_amount_caster = 200 //how much the caster is stunned for after the spell
	unconscious_amount_victim = 200 //how much the victim is stunned for after the spell
	miracle = TRUE
	devotion_cost = 100
	action_icon_state = "mindswap"
	associated_skill = /datum/skill/magic/holy
