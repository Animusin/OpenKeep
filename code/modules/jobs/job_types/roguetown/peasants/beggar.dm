
/datum/job/roguetown/vagrant
	title = "Beggar"
	flag = BEGGAR
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 15
	spawn_positions = 15

	allowed_races = list(
		"Humen",
		"Elf",
		"Dwarf",
		"Half-Elf",
		"Tiefling",
		"Dark Elf",
		"Aasimar",
		"Changeling",
		"Skylancer",
		"Ogrun",
		"Undine"
	)
	outfit = /datum/outfit/job/roguetown/vagrant
	bypass_lastclass = FALSE
	bypass_jobban = TRUE

	tutorial = "The stench of your piss-laden clothes dont bug you anymore, the glances of disgust and loathing others give you is just a friendly greeting; the only reason youve not been killed already is because Volfs are known to be repelled by decaying flesh. Youre going to be a solemn reminder what happens when something unwanted is born into this world."
	display_order = JDO_VAGRANT
	show_in_credits = FALSE
	min_pq = -100
	can_random = FALSE
	whitelist_req = FALSE

	cmode_music = 'sound/music/combat_bum.ogg'

/datum/job/roguetown/vagrant/New()
	. = ..()
	peopleknowme = list()

/datum/outfit/job/roguetown/vagrant/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap
	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust
	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	if(prob(10))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, pick(1,2,3,4,5), TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, pick(1,2,3,4,5), TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, pick (1,2,3,4,5), TRUE) // thug lyfe
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, pick(2,3,4,5), TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, pick(1,2,3), TRUE) // Street-fu
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, pick(1,2,3), TRUE)
		H.STALUC = rand(1, 20)
	if(prob(25))
		r_hand = /obj/item/natural/stone
	if(prob(10))
		r_hand = /obj/item/rogueweapon/mace/woodclub
	if(prob(10))
		r_hand = /obj/item/rogueweapon/knife/stone
	H.change_stat("intelligence", -3)
	H.change_stat("constitution", -2)
	H.change_stat("endurance", -2)
	if(H.dna.species?.id == "abyssariad")
		mask = /obj/item/clothing/mask/rogue/kaizoku/facemask/dishonor
		to_chat(H, "<span class='userdanger'>In failure I forfeited my honor and values of the Abyssal Tide. If I am to claim the essence of an Abyssariad once more, I must prove myself worthy.</span>")
		H.burakumin = TRUE
		if(H.wear_mask)
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch || /obj/item/clothing/mask/rogue/eyepatch/left ))
				qdel(H.wear_mask)
				mask = /obj/item/clothing/mask/rogue/kaizoku/facemask/dishonor

/datum/outfit/job/roguetown/vagrant
	name = "Beggar"
