var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Facility Director"
	flag = CAPTAIN
	disallow_jobhop = TRUE
	departments = list(DEPARTMENT_COMMAND)
	sorting_order = 3 // Above everyone.
	departments_managed = list(DEPARTMENT_COMMAND)
	department_flag = ENGSEC
	pto_type = PTO_COMMAND
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	idtype = /obj/item/card/id/gold
	selection_color = "#2F2F7F"
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 25
	ideal_character_age = 70 // Old geezer captains ftw

	outfit_type = /datum/outfit/job/captain
	job_description = "The Facility Director manages the other Command Staff, and through them the rest of the station. Though they have access to everything, \
						they do not understand everything, and are expected to delegate tasks to the appropriate crew member. The Facility Director is expected to \
						have an understanding of Standard Operating Procedure, and is subject to it, and legal action, in the same way as every other crew member."
	alt_titles = list(
		"Overseer"= /datum/alt_title/overseer,
		"Site Manager" = /datum/alt_title/captain/site,
		"Director of Operations" = /datum/alt_title/captain/director,
		"Captain" = /datum/alt_title/captain/captain
	)


/datum/job/captain/get_access()
	return get_all_station_access().Copy()

/datum/alt_title/overseer
	title = "Overseer"

/datum/alt_title/captain/site
	title = "Site Manager"

/datum/alt_title/captain/director
	title = "Director of Operations"

/datum/alt_title/captain/captain
	title = "Captain"

/datum/outfit/job/captain
	name = OUTFIT_JOB_NAME("Captain")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain
	l_ear = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/storage/backpack/captain
	satchel_one = /obj/item/storage/backpack/satchel/cap
	messenger_bag = /obj/item/storage/backpack/messenger/com
	id_type = /obj/item/card/id/gold/captain
	pda_type = /obj/item/pda/captain

/datum/outfit/job/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		if(uniform)
			var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)
