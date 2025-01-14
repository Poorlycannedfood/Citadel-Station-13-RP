/*
Contains helper procs for airflow, handled in /connection_group.
*/

/mob
	var/tmp/last_airflow_stun = 0

/mob/proc/airflow_stun()
	if(stat == 2)
		return 0
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/stun_cooldown, stuncd)
	if(last_airflow_stun > world.time - stuncd)	return 0

	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, "<span class='notice'>You stay upright as the air rushes past you.</span>")
		return 0
	if(buckled)
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return 0
	if(!lying)
		to_chat(src, "<span class='warning'>The sudden rush of air knocks you over!</span>")
	Weaken(2)
	last_airflow_stun = world.time

/mob/living/silicon/airflow_stun()
	return

/mob/living/carbon/human/airflow_stun()
	if(shoes && (shoes.clothing_flags & NOSLIP))
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return 0
	..()

/atom/movable/proc/check_airflow_movable(n)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/dense_pressure, dense_pressure)
	if(flags & ATOM_ABSTRACT)
		return 0

	if(anchored && !ismob(src))
		return 0

	if(!isobj(src) && n < dense_pressure)
		return 0

	return 1

/mob/check_airflow_movable(n)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/heavy_pressure, heavy_pressure)
	if(n < heavy_pressure)
		return 0
	return 1

/mob/observer/check_airflow_movable()
	return 0

/mob/living/silicon/check_airflow_movable()
	return 0

/obj/check_airflow_movable(n)
	if (!(. = ..()))
		return 0
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/dense_pressure, dense_pressure)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/dense_pressure, light_pressure)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/dense_pressure, lightest_pressure)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/dense_pressure, medium_pressure)
	if(isnull(w_class))
		if(n < dense_pressure) return 0 //most non-item objs don't have a w_class yet
	switch(w_class)
		if(ITEMSIZE_TINY,ITEMSIZE_SMALL)
			if(n < lightest_pressure) return 0
		if(ITEMSIZE_NORMAL)
			if(n < light_pressure) return 0
		if(ITEMSIZE_LARGE,ITEMSIZE_HUGE)
			if(n < medium_pressure) return 0
		else
			if(n < dense_pressure) return 0

/atom/movable
	var/tmp/turf/airflow_dest
	var/tmp/airflow_speed = 0
	var/tmp/airflow_time = 0
	var/tmp/last_airflow = 0

/atom/movable/proc/AirflowCanMove(n)
	return 1

/mob/AirflowCanMove(n)
	if(status_flags & GODMODE)
		return 0
	if(buckled)
		return 0
	var/obj/item/shoes = item_by_slot(SLOT_ID_SHOES)
	if(istype(shoes) && (shoes.clothing_flags & NOSLIP))
		return 0
	return 1

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(A)
	else
		airflow_speed = 0
		airflow_time = 0
		. = ..()

/atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	var/weak_amt = istype(A,/obj/item) ? A:w_class : rand(1,5) //Heheheh
	Weaken(weak_amt)
	return ..()

/obj/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src, "smash.ogg", 25, 1, -1)
	return ..()

/obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/living/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_message("<span class='danger'>[src] slams into [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src, "punch", 25, 1, -1)
	if (prob(33))
		loc:add_blood(src)
		bloody_body(src)
	GET_VSC_PROP(atmos_vsc, /atmos/airflow/impact_damage, impact_damage)
	var/b_loss = airflow_speed * impact_damage

	var/blocked = run_armor_check(BP_HEAD,"melee")
	var/soaked = get_armor_soak(BP_HEAD,"melee")
	apply_damage(b_loss/3, BRUTE, BP_HEAD, blocked, soaked, 0, "Airflow")

	blocked = run_armor_check(BP_TORSO,"melee")
	soaked = get_armor_soak(BP_TORSO,"melee")
	apply_damage(b_loss/3, BRUTE, BP_TORSO, blocked, soaked, 0, "Airflow")

	blocked = run_armor_check(BP_GROIN,"melee")
	soaked = get_armor_soak(BP_GROIN,"melee")
	apply_damage(b_loss/3, BRUTE, BP_GROIN, blocked, soaked, 0, "Airflow")

	GET_VSC_PROP(atmos_vsc, /atmos/airflow/impact_stun, impact_stun)

	if(airflow_speed > 10)
		Paralyse(round(airflow_speed * impact_stun))
		Stun(paralysis + 3)
	else
		Stun(round(airflow_speed * impact_stun/2))
	return ..()

/datum/zas_zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A in T)
			if((A.flags & ATOM_ABSTRACT) || A.anchored || istype(A, /obj/effect) || istype(A, /mob/observer))
				continue
			. += A
