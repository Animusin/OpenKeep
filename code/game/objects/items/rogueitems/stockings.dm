/obj/item/stockings
	name = "stockings"
	desc = "An Eoran designed undergarment to underline the legs."
	icon = 'icons/roguetown/clothing/stockings.dmi'
	icon_state = "stockings_m"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/gendered = MALE
	var/race
	var/cached_undies

/obj/item/stockings/f
	name = "women's stockings"
	desc = "An Eoran designed undergarment to underline the legs."
	icon_state = "stockings_f"
	gendered = FEMALE

/obj/item/stockings/net
	name = "net women's stockings"
	desc = "An Eoran designed undergarment to underline the legs."
	icon_state = "net_stockings_f"
	gendered = FEMALE

/obj/item/stockings/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.gender != gendered)
			return
		if(H.socks == "Nude")
			user.visible_message("<span class='notice'>[user] tries to put [src] on [H]...</span>")
			if(do_after(user, 50, needhand = 1, target = H))
				get_location_accessible(H, BODY_ZONE_PRECISE_GROIN)
				H.socks = name
				H.underwear_color = color
				H.update_body()
				qdel(src)

/datum/sprite_accessory/socks/stockings_m
	name = "stockings"
	icon = 'icons/roguetown/clothing/stockings.dmi'
	icon_state = "stockings_m"
	gender = MALE
	specuse = list("human", "tiefling", "aasimar")

/datum/sprite_accessory/socks/stockings_f
	name = "women's stockings"
	icon = 'icons/roguetown/clothing/stockings.dmi'
	icon_state = "stockings_f"
	gender = FEMALE
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/socks/net_stockings_f
	name = "net women's stockings"
	icon = 'icons/roguetown/clothing/stockings.dmi'
	icon_state = "net_stockings_f"
	gender = FEMALE
	specuse = ALL_RACES_LIST