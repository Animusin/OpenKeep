// Lesser miracle
/obj/effect/proc_holder/spell/invoked/lesser_heal
	name = "Lesser Miracle"
	overlay_state = "lesserheal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	charge_max = 10 SECONDS
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/lesser_heal/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			target.visible_message("<span class='danger'>[target] is burned by holy light!</span>", "<span class='userdanger'>I'm burned by holy light!</span>")
			target.adjustFireLoss(25)
			target.fire_act(1,5)
			..()
			return TRUE
		var/conditional_buff = FALSE
		var/situational_bonus = 10
		//this if chain is stupid, replace with variables on /datum/patron when possible?
		switch(user.patron.type)
			if(/datum/patron/forgotten)
				target.visible_message(span_info("A strange stirring feeling pours from [target]!"), span_notice("Sentimental thoughts drive away my pains!"))
			if(/datum/patron/divine/astrata)
				target.visible_message(span_info("A wreath of gentle light passes over [target]!"), span_notice("I'm bathed in holy light!"))
				// during the day, heal 10 more (basic as fuck)
				if (GLOB.tod == "day")
					conditional_buff = TRUE
			if(/datum/patron/divine/noc)
				target.visible_message(span_info("A shroud of soft moonlight falls upon [target]!"), span_notice("I'm shrouded in gentle moonlight!"))
				// during the night, heal 10 more (i wish this was more interesting but they're twins so whatever)
				if (GLOB.tod == "night")
					conditional_buff = TRUE
			if(/datum/patron/divine/dendor)
				target.visible_message(span_info("A rush of primal energy spirals about [target]!"), span_notice("I'm infused with primal energies!"))
				var/list/natural_stuff = list(/obj/structure/flora/roguegrass, /obj/structure/flora/roguetree, /obj/structure/flora/rogueshroom, /obj/structure/fluff/clodpile)
				situational_bonus = 0
				// the more natural stuff around US, the more we heal
				for (var/obj/O in oview(5, user))
					if (O in natural_stuff)
						situational_bonus = min(situational_bonus + 1, 25)
				if (situational_bonus > 0)
					conditional_buff = TRUE
			if(/datum/patron/divine/abyssor)
				target.visible_message(span_info("A mist of salt-scented vapour settles on [target]!"), span_notice("I'm invigorated by healing vapours!"))
				target.reagents.add_reagent(/datum/reagent/medicine/abyssalpurificator, 15) //Addictional chemical to remove demonic corruption. That's a system coming to second part of Kaizoku.
				// if our target is standing in water, heal a flat amount extra
				if (istype(get_turf(target), /turf/open/water))
					conditional_buff = TRUE
					situational_bonus = 15
			if(/datum/patron/divine/ravox)
				target.visible_message(span_info("An air of righteous defiance rises near [target]!"), span_notice("I'm filled with an urge to fight on!"))
				situational_bonus = 0
				// the bloodier the area around our target is, the more we heal
				for (var/obj/effect/decal/cleanable/blood/O in oview(5, target))
					situational_bonus = min(situational_bonus + 1, 25)
				conditional_buff = TRUE
			if(/datum/patron/divine/necra)
				target.visible_message(span_info("A sense of quiet respite radiates from [target]!"), span_notice("I feel the Undermaiden's gaze turn from me for now!"))
				if (iscarbon(target))
					var/mob/living/carbon/C = target
					// if the target is "close to death" (at or below 25% health)
					if (C.health <= (C.maxHealth * 0.25))
						conditional_buff = TRUE
						situational_bonus = 25
			if(/datum/patron/divine/xylix)
				target.visible_message(span_info("A fugue seems to manifest briefly across [target]!"), span_notice("My wounds vanish as if they had never been there! "))
				// half of the time, heal a little (or a lot) more - flip the coin
				if (prob(50))
					conditional_buff = TRUE
					situational_bonus = rand(1, 25)
			if(/datum/patron/divine/pestra)
				target.visible_message(span_info("An aura of clinical care encompasses [target]!"), span_notice("I'm sewn back together by sacred medicine!"))
				// pestra always heals a little more toxin damage and restores a bit more blood
				target.adjustToxLoss(-situational_bonus)
				target.blood_volume += BLOOD_VOLUME_SURVIVE/2
			if(/datum/patron/divine/malum)
				target.visible_message("<span class='info'>A tempering heat is discharged out of [target]!</span>", "<span class='notice'>I feel the heat of a forge soothing my pains!</span>")
				var/list/firey_stuff = list(/obj/machinery/light/rogue/torchholder, /obj/machinery/light/rogue/campfire, /obj/machinery/light/rogue/hearth, /obj/machinery/light/rogue/wallfire, /obj/machinery/light/rogue/wallfire/candle, /obj/machinery/light/rogue/forge)
				// extra healing for every source of fire/light near us
				situational_bonus = 0
				for (var/obj/O in oview(5, user))
					if (O in firey_stuff)
						situational_bonus = min(situational_bonus + 5, 25)
				if (situational_bonus > 0)
					conditional_buff = TRUE
			if(/datum/patron/divine/eora)
				target.visible_message("<span class='info'>An emanance of love blossoms around [target]!</span>", "<span class='notice'>I'm filled with the restorative warmth of love!</span>")
				// if they're wearing an eoran bud (or are a pacifist), pretty much double the healing.
				situational_bonus = 0
				if (HAS_TRAIT(target, TRAIT_PACIFISM))
					conditional_buff = TRUE
					situational_bonus = 25
			if(/datum/patron/inhumen/zizo)
				target.visible_message(span_info("Vital energies are sapped towards [target]!"), span_notice("The life around me pales as I am restored!"))
				// set up a ritual pile of bones (or just cast near a stack of bones whatever) around us for massive bonuses, cap at 50 for 75 healing total (wowie)
				situational_bonus = 0
				for (var/obj/item/stack/sheet/bone/O in oview(5, user))
					situational_bonus = min(situational_bonus + 5, 50)
				if (situational_bonus > 0)
					conditional_buff = TRUE
			if(/datum/patron/inhumen/graggar)
				target.visible_message(span_info("Foul fumes billow outward as [target] is restored!"), span_notice("A noxious scent burns my nostrils, but I feel better!"))
				// if you've got lingering toxin damage, you get healed more, but your bonus healing doesn't affect toxin
				var/toxloss = target.getToxLoss()
				if (toxloss >= 10)
					conditional_buff = TRUE
					situational_bonus = 25
					target.adjustToxLoss(situational_bonus) // remember we do a global toxloss adjust down below so this is okay
			if(/datum/patron/inhumen/matthios)
				target.visible_message(span_info("A wreath of... strange light passes over [target]?"), span_notice("I'm bathed in a... strange holy light?"))
				// COMRADES! WE MUST BAND TOGETHER!
				if (HAS_TRAIT(target, TRAIT_BANDITCAMP))
					conditional_buff = TRUE
					situational_bonus = 25
			if(/datum/patron/godless)
				target.visible_message(span_info("No Gods answer these prayers."), span_notice("No Gods answer these prayers."))
				return
			else
				target.visible_message(span_info("A choral sound comes from above and [target] is healed!"), span_notice("I am bathed in healing choral hymns!"))

		var/healing = 40
		if (conditional_buff)
			to_chat(user, "Channeling my patron's power is easier in these conditions!")
			healing += situational_bonus

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(affecting)
				if(affecting.heal_damage(healing, healing))
					C.update_damage_overlays()
				if(affecting.heal_wounds(healing))
					C.update_damage_overlays()
		else
			target.adjustBruteLoss(-healing)
			target.adjustFireLoss(-healing)
		target.adjustToxLoss(-healing)
		target.adjustOxyLoss(-healing)
		return TRUE
	return FALSE

// Miracle
/obj/effect/proc_holder/spell/invoked/heal
	name = "Miracle"
	overlay_state = "astrata"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
//	chargedloop = /datum/looping_sound/invokeholy
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psycross)
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	charge_max = 20 SECONDS
	miracle = TRUE
	devotion_cost = 45

/obj/effect/proc_holder/spell/invoked/heal/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			target.visible_message("<span class='danger'>[target] is burned by holy light!</span>", "<span class='userdanger'>I'm burned by holy light!</span>")
			target.adjustFireLoss(50)
			target.Knockdown(10)
			target.fire_act(1,5)
			..()
			return TRUE
		target.visible_message("<span class='info'>A wreath of gentle light passes over [target]!</span>", "<span class='notice'>I'm bathed in holy light!</span>")
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(affecting)
				if(affecting.heal_damage(50, 50))
					C.update_damage_overlays()
				if(affecting.heal_wounds(100))
					C.update_damage_overlays()
		else
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
		target.adjustToxLoss(-50)
		target.adjustOxyLoss(-50)
		target.blood_volume += BLOOD_VOLUME_SURVIVE
		..()
		return TRUE
	return FALSE

// RAVOX

/obj/effect/proc_holder/spell/self/barbrage
	name = "Rage"
	desc = "Enter a state of martial fervour, increasing offensive capabilities at the cost of making yourself vulnerable."
	overlay_state = "bcry"
	releasedrain = 30
	antimagic_allowed = TRUE
	invocation_type = "shout"
	charge_max = 1 MINUTES

/obj/effect/proc_holder/spell/self/barbrage/cast(list/targets,mob/living/user = usr)
	. = ..()
	user.emote("rage", forced = TRUE)
	playsound(get_turf(user), 'sound/magic/barbroar.ogg', 50, TRUE)
	user.apply_status_effect(/datum/status_effect/buff/barbrage)

// XYLIX

/obj/effect/proc_holder/spell/invoked/mockery
	name = "Vicious Mockery"
	releasedrain = 50
	associated_skill = /datum/skill/misc/music
	charge_max = 10 MINUTES
	range = 7

/obj/effect/proc_holder/spell/invoked/mockery/cast(list/targets, mob/living/user)
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 40, FALSE)
	for(var/mob/living/listener in hearers(7))
		if(listener.can_hear()) // Vicious mockery requires people to be able to hear you.
			if(listener?.mind?.has_antag_datum(/datum/antagonist))
				if(!listener?.mind?.isactuallygood())
					listener.apply_status_effect(/datum/status_effect/debuff/viciousmockery)
				else
					return // No debuff for good guys
			else
				return // No debuff for good guys

/obj/effect/proc_holder/spell/invoked/mockery/invocation(mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/B = user
		switch(B.dna.species.id)
			if("human") // Half elves too
				switch(pick(1,2,3,4,5))
					if(1)
						user.say("Your mother was a Rous, and your father smelled of jacksberries!", forced = "spell")
					if(2)
						user.say("What are you going to do for a face when the monkey wants his arse back?!", forced = "spell")
					if(3)
						user.say("Wandought thine blades stand, much like thine loving parts!", forced = "spell")
					if(4)
						user.say("That's a face not even Graggar could love!", forced = "spell")
					if(5)
						user.say("I shall ne'er desist from thee, nor shall I ever disappoint thee much~", forced = "spell")

			if("elf")
				switch(pick(1,2,3,4,5))
					if(1)
						user.say("As graceful as a drunken mole, I see!", forced = "spell")
					if(2)
						user.say("I've fought zads more fiercer than you!", forced = "spell")
					if(3)
						user.say("You're making this so easy, I'm losing confidence in myself... barely!", forced = "spell")
					if(4)
						user.say("OHH-HOH-HOH-HOH-HOH!", forced = "spell")
					if(5)
						user.say("Uncultured churls, barely worth my words!", forced = "spell")

			if("dwarf")
				switch(pick(1,2,3,4,5))
					if(1)
						user.say("If yer mind was as sharp as yer ears, we wouldn't be in this mess!", forced = "spell")
					if(2)
						user.say("Ye kick softer than a newborn saiga!", forced = "spell")
					if(3)
						user.say("Make it quick, dullards! T'is happy hour in the tavern!", forced = "spell")
					if(4)
						user.say("Ohh, is the milk drinker gonna cry?", forced = "spell")
					if(5)
						user.say("I will drink from yer skull!", forced = "spell")

			if("tiefling")
				switch(pick(1,2,3,4,5))
					if(1)
						user.say("Ay caramba, que mal baila la bamba!", forced = "spell")
					if(2)
						user.say("Aserejé, ja, deje, dejebetudejebe de seibi noua!", forced = "spell")
					if(3)
						user.say("Good job Slowpoke Rodriguez, you almost had me! Almost!", forced = "spell")
					if(4)
						user.say("Come on, entertain me a little longer!", forced = "spell")
					if(5)
						user.say("Dance with the devil and win a prize!", forced = "spell")

			if("aasimar")
				switch(pick(1,2,3,4,5))
					if(1)
						user.say("Your imperfect body could never match the fires I was forged on.", forced = "spell")
					if(2)
						user.say("You're in for a world of hurt, impudent one.", forced = "spell")
					if(3)
						user.say("Your name shall be stricken down from the annals of history.", forced = "spell")
					if(4)
						user.say("I wouldn't sing your praises even if you forged me to!", forced = "spell")
					if(5)
						user.say("What manner of blabbering creecher art thou?", forced = "spell")
			if("abyssariad")
				switch(pick(1,2,3,4,5,6,7,8))
					if(1)
						user.say("Even the sea refuses to swallow a fool like ye!", forced = "spell")
					if(2)
						user.say("I'd say ye head be thick as an oni's skull, but different of ye, onis can think.", forced = "spell")
					if(3)
						user.say("Is that yer battle stance, or are ye just tryin' not to keel over?", forced = "spell")
					if(4)
						user.say("Do the waves weep for yer blade's sad fate, or be it just ye", forced = "spell")
					if(5)
						user.say("Yer tongue's sharper than yer blade, but neither does a lick o' damage.", forced = "spell")
					if(6)
						user.say("If brains were gold, ye'd be poorer than a sunken wreck.", forced = "spell")
					if(7)
						user.say("Ye've the charm of a beached whale, and the smell to match.", forced = "spell")
					if(8)
						user.say("Ye fight like a landlubber, and yer wits be even slower!", forced = "spell")
