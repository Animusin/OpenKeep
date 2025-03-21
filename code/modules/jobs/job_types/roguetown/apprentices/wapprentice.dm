/datum/job/roguetown/wapprentice
	title = "Magicians Apprentice"
	flag = APPRENTICE
	department_flag = APPRENTICES
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ALL_PLAYER_RACES_BY_NAME
	allowed_patrons = list(/datum/patron/divine/noc)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Your master once saw potential in you, something you are uncertain if they still do with your recent studies. The path to using magic is something treacherous and untamed, and you are still decades away from calling yourself even a journeyman in the field. Listen and serve, and someday you will earn your hat."

	outfit = /datum/outfit/job/roguetown/wapprentice
	display_order = JDO_WAPP
	give_bank_account = 10
	bypass_lastclass = FALSE
	min_pq = 0

/datum/outfit/job/roguetown/wapprentice/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/magic/arcane, pick(1,2), TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
	if(H.gender == MALE)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltr = /obj/item/roguekey/tower
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/light/striped
		backr = /obj/item/storage/backpack/rogue/satchel
	else
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltr = /obj/item/roguekey/tower
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/light/striped
		backr = /obj/item/storage/backpack/rogue/satchel

	H.change_stat("intelligence", 1)
	H.change_stat("speed", -1)
