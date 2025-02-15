/mob/living/carbon/human/species/skeleton
	name = "skeleton"

	race = /datum/species/human/northern
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					/obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	faction = list("undead")
	var/skel_outfit = /datum/outfit/job/roguetown/npc/skeleton
	ambushable = FALSE
	rot_type = null
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	possible_mmb_intents = list(INTENT_STEAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak)
	stand_attempts = 4

/mob/living/carbon/human/species/skeleton/npc/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/npc
	aggressive = TRUE
	mode = AI_IDLE
	wander = TRUE
	simpmob_attack = 40
	simpmob_defend = 0
	wander = TRUE
	attack_speed = -10

/mob/living/carbon/human/species/skeleton/Initialize()
	. = ..()
	cut_overlays()
	spawn(10)
		after_creation()

/mob/living/carbon/human/species/skeleton/after_creation()
	..()
	QDEL_NULL(sexcon)

	dodgetime = 3 SECONDS
	aggressive = TRUE
	mode = AI_IDLE
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

	if(src.dna && src.dna.species)
		src.dna.species.species_traits |= NOBLOOD
		src.dna.species.soundpack_m = new /datum/voicepack/skeleton()
		src.dna.species.soundpack_f = new /datum/voicepack/skeleton()
	var/obj/item/bodypart/O = src.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	O = src.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	src.regenerate_limb(BODY_ZONE_R_ARM)
	src.regenerate_limb(BODY_ZONE_L_ARM)
	for(var/obj/item/bodypart/B in src.bodyparts)
		B.skeletonize()
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	src.underwear = "Nude"
	if(src.charflaw)
		QDEL_NULL(src.charflaw)
	update_body()
	mob_biotypes = MOB_UNDEAD
	faction = list("undead")
	name = "skeleton"
	real_name = "skeleton"
	QDEL_NULL(sexcon)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	if(skel_outfit)
		var/datum/outfit/OU = new skel_outfit
		if(OU)
			equipOutfit(OU)

/datum/outfit/job/roguetown/npc/skeleton

/datum/outfit/job/roguetown/species/skeleton/npc/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = rand(6,8)
	H.STASPD = rand(8,10)
	H.STACON = rand(8,10)
	H.STAEND = 12
	H.STAINT = 1

/datum/outfit/job/roguetown/greater_skeleton/pre_equip(mob/living/carbon/human/H) //equipped onto Summon Greater Undead player skeletons only after the mind is added
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

	H.STASTR = rand(12,14)
	H.STASPD = 10
	H.STACON = 12

	//light labor skills for skeleton manual labor and some warrior-adventurer skills, equipment is still bad probably
	H.mind?.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)

	H.mind?.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.set_patron(/datum/patron/inhumen/zizo)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/swift,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1) //dont want to mess with base NPCs too much out of fear of breaking them so I assigned the intents in the outfit

	if(prob(50))
		r_hand = /obj/item/rogueweapon/sword
	else
		r_hand = /obj/item/rogueweapon/polearm/halberd/bardiche/woodcutter

///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS

/mob/living/carbon/human/species/skeleton/npc/peasant/after_creation()
	..()
	equipOutfit(new /datum/outfit/job/roguetown/species/skeleton/npc/peasant)

/datum/outfit/job/roguetown/species/skeleton/npc/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	var/loadout = rand(1,7)
	head = /obj/item/clothing/head/roguetown/roguehood/random
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	switch(loadout)
		if(1) //Axe Warrior
			r_hand = /obj/item/rogueweapon/axe/iron
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/knitcap
		if(2) //Long Stick Fighter
			r_hand = /obj/item/rogueweapon/polearm/woodstaff
		if(3) //Club Caveman
			r_hand = /obj/item/rogueweapon/mace/woodclub
		if(4) //Stabbity Stabbity your Knight is now horizontality
			r_hand =/obj/item/rogueweapon/pitchfork
			head = /obj/item/clothing/head/roguetown/strawhat
		if(5) //Bonk Build
			r_hand = /obj/item/rogueweapon/thresher
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
		if(6) //Bonk Build
			r_hand = /obj/item/rogueweapon/hoe
			head = /obj/item/clothing/head/roguetown/fisherhat
		if(7) //Ex Wife
			r_hand = /obj/item/cooking/pan
			head = /obj/item/clothing/head/roguetown/armingcap
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/brown


///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS
/mob/living/carbon/human/species/skeleton/npc/ambush/after_creation()
	..()
	equipOutfit(new /datum/outfit/job/roguetown/species/skeleton/npc/random)

/datum/outfit/job/roguetown/species/skeleton/npc/random/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	if(prob(30))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/leather
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/roguehood/random
	if(prob(50))
		r_hand = /obj/item/rogueweapon/sword/iron
	else
		r_hand = /obj/item/rogueweapon/mace/woodclub

///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS

/mob/living/carbon/human/species/skeleton/npc/warrior/after_creation()
	..()
	equipOutfit(new /datum/outfit/job/roguetown/species/skeleton/npc/warrior)

/datum/outfit/job/roguetown/species/skeleton/npc/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 10
	H.STACON = 11
	var/loadout = rand(1,6)
	belt = /obj/item/storage/belt/rogue/leather
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
	switch(loadout)
		if(1) //Skeleton Warrior
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/wood
			belt = /obj/item/storage/belt/rogue/leather
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if(2)//Skeleton Warrior
			r_hand = /obj/item/rogueweapon/mace
			l_hand = /obj/item/rogueweapon/shield/wood
			belt = /obj/item/storage/belt/rogue/leather
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if(3) //Skeleton Warrior
			r_hand = /obj/item/rogueweapon/flail
			l_hand = /obj/item/rogueweapon/shield/wood
			belt = /obj/item/storage/belt/rogue/leather
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/helmet/skullcap
		if(4) //Skeleton Warrior
			r_hand =/obj/item/rogueweapon/polearm/spear
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if(5) //Skeleton Warrior
			r_hand = /obj/item/rogueweapon/sword/sabre
			l_hand = /obj/item/rogueweapon/knife/dagger
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if(6) //Skeleton Warrior
			r_hand = /obj/item/rogueweapon/sword/scimitar/messer
			l_hand = /obj/item/rogueweapon/knife/dagger
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
			pants = /obj/item/clothing/under/roguetown/tights/vagrant
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/helmet/skullcap


/mob/living/carbon/human/species/skeleton/npc/warrior/skilled/after_creation()
	..()
	equipOutfit(new /datum/outfit/job/roguetown/species/skeleton/npc/warrior)
	d_intent = INTENT_PARRY //these ones will parry instead of dodge, making them much more dangerous
	configure_mind()

/mob/living/carbon/human/species/skeleton/npc/warrior/skilled/configure_mind()
	if(!mind)
		mind = new /datum/mind(src)
		mind.current = src

	mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
/* arena not a thing
/mob/living/carbon/human/species/skeleton/death_arena/after_creation()
	..()
	equipOutfit(new /datum/outfit/job/roguetown/arena_skeleton)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
*/
