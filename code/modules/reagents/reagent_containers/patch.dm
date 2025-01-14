
/*
 * Patches. A subtype of pills, in order to inherit the possible future produceability within chem-masters, and dissolving.
 */

/obj/item/reagent_containers/pill/patch
	name = "patch"
	desc = "A patch."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"

	base_state = "patch"

	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

	var/pierce_material = FALSE	// If true, the patch can be used through thick material.

/obj/item/reagent_containers/pill/patch/attack(mob/M as mob, mob/user as mob)
	var/mob/living/L = user

	if(M == L)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
			if(!affecting)
				to_chat(user, "<span class='warning'>The limb is missing!</span>")
				return
			if(affecting.robotic >= ORGAN_ROBOT)
				to_chat(user, "<span class='notice'>\The [src] won't work on a robotic limb!</span>")
				return

			if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
				to_chat(user, "<span class='notice'>\The [src] can't be applied through such a thick material!</span>")
				return

			if(affecting.open)// you cant place Bandaids on open surgeries, why chemical patches.
				to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")
				return


			to_chat(H, "<span class='notice'>\The [src] is placed on your [affecting].</span>")
			M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_TOUCH)
			qdel(src)

			for(var/datum/wound/W in affecting.wounds)
				if (W.internal)//ignore internal wounds and check the remaining
					continue
				if(W.bandaged)//already bandaged wounds dont need to be bandaged again
					continue
				W.bandage()
				break;//dont bandage more than one wound, its only one patch you can have in your stack
			affecting.update_damages()
			return 1

	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
		if(!affecting)
			to_chat(user, "<span class='warning'>The limb is missing!</span>")
			return

		if(affecting.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='notice'>\The [src] won't work on a robotic limb!</span>")
			return

		if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
			to_chat(user, "<span class='notice'>\The [src] can't be applied through such a thick material!</span>")
			return
		if(affecting.open)// you cant place Bandaids on open surgeries, why chemical patches.
			to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")
			return

		user.visible_message("<span class='warning'>[user] attempts to place \the [src] onto [H]`s [affecting].</span>")

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.temporarily_remove_from_inventory(src, INV_OP_FORCE)
		user.visible_message("<span class='warning'>[user] applies \the [src] to [H].</span>")

		var/contained = reagentlist()
		add_attack_logs(user,M,"Applied a patch containing [contained]")

		to_chat(H, "<span class='notice'>\The [src] is placed on your [affecting].</span>")
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)

		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_TOUCH)
		qdel(src)

		for(var/datum/wound/W in affecting.wounds)
			if (W.internal)//ignore internal wounds and check the remaining
				continue
			if(W.bandaged)//already bandaged wounds dont need to be bandaged again
				continue
			W.bandage()
			break;//dont bandage more than one wound, its only one patch you can have in your stack
		affecting.update_damages()

		return 1

	return 0
