/obj/effect/overmap/visitable/sector/lythios43c
	name = "Lythios 43c"	// Name of the location on the overmap.
	desc = "A cold, desolate iceball world. Home to the NSB Atlas, a far-frontier research base set up by NanoTrasen shortly after establishing in this sector."
	scanner_desc = @{"[b][i]Registration[/i][/b]: NSB Atlas
[b][i]Class[/i][/b]: ALPHA SITE
[b][i]Transponder[/i][/b]: Transmitting (MIL), NanoTrasen IFF
[b][i]Notice[/i][/b]: RESTRICTED AREA, authorized personnel only"}
	base = TRUE
	icon_state = "globe"
	color = "#5bbbd3"
	start_x = 15
	start_y = 10
	initial_generic_waypoints = list(
		"rift_airspace_SE",
		"rift_airspace_E",
		"rift_airspace_NE",
		"rift_airspace_N",
		"rift_plains",
		)

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("rift_excursion_pad"),
		"Courser Scouting Vessel" = list("rift_courser_hangar"),
		"Civilian Transport" = list("rift_civvie_pad"),
		"Dart EMT Shuttle" = list("rift_emt_pad"),
		"Beruang Trade Ship" = list("rift_trade_dock")
		)

	extra_z_levels = list(
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_CAVERN
	)

/*	initial_generic_waypoints = list("nav_capitalship_docking2", "triumph_excursion_hangar", "triumph_space_SW", "triumph_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("triumph_excursion_hangar"),
		"Courser Scouting Vessel" = list("triumph_courser_hangar"),
		"Civilian Transport" = list("triumph_civvie_home"),
		"Dart EMT Shuttle" = list("triumph_emt_dock"),
		"Beruang Trade Ship" = list("triumph_annex_dock"),
		"Mining Shuttle" = list("triumph_mining_port")
		)

	levels_for_distress = list(
		Z_LEVEL_OFFMAP1,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT,
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_FUELDEPOT,
		Z_LEVEL_CLASS_D
		)
*/

/obj/effect/overmap/visitable/sector/lythios43c/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/lythios43c/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/lythios43c/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttle.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			GLOB.lore_atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		GLOB.lore_atc.msg(message)


//////////////////////////////////////////////////////////////////////////
// There is literally a dm file for triumph shuttles, why are these here//
//////////////////////////////////////////////////////////////////////////

// Vox Pirate ship (Yaya, yous be giving us all your gear now.)

/obj/effect/overmap/visitable/ship/landable/pirate
	name = "Pirate Skiff"
	desc = "Yous need not care about this."
	fore_dir = WEST
	vessel_mass = 7000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Pirate Skiff"

/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	fuel_consumption = 5

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"

// STATIC PLANET/BASE LOCATIONS

// -- Datums -- //
/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	scanner_desc = @{"[i]Information[/i]: A collection of ruins from ages ago.."}
	icon_state = "dust2"
	color = "#BBBBBB"
	known = FALSE
	in_space = 1
	initial_generic_waypoints = list("triumph_excursion_debrisfield")

/* Old Class D waypoint, new one is being handled in classd.dm . Please use that one -Bloop
/obj/effect/overmap/visitable/sector/class_d
	name = "Unidentified Planet"
	desc = "ASdlke ERROR%%%% UNABLE TO----."
	scanner_desc = @{"[i]Information[/i]: Scans report a planet with nearly no atmosphere, but life-signs are registered."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#882933"
*/

/obj/effect/overmap/visitable/sector/class_h
	name = "Desert Planet"
	desc = "Planet readings indicate light atmosphere and high heat."
	scanner_desc = @{"[i]Information[/i]
Atmosphere: Thin
Weather: Sunny, little to no wind
Lifesign: Multiple Fauna and humanoid life-signs detected."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#BA9066"


/obj/effect/overmap/visitable/sector/pirate_base
	name = "Vox Pirate Base"
	desc = "A nest of hostiles to the company. Caution is advised."
	scanner_desc = @{"[i]Information[/i]
Warning, unable to scan through sensor shielding systems at location. Possible heavy hostile life-signs."}
	in_space = 1
	known = FALSE
	icon_state = "piratebase"
	color = "#FF3333"
	initial_generic_waypoints = list("piratebase_hanger")

/obj/effect/overmap/visitable/sector/mining_planet
	name = "Mineral Rich Planet"
	desc = "A planet filled with valuable minerals. No life signs currently detected on the surface."
	scanner_desc = @{"[i]Information[/i]
Atmopshere: Mix of Oxygen, Nitrogen and Phoron. DANGER
Lifesigns: No immediate life-signs detected."}
	in_space = 0
	icon_state = "globe"
	color = "#8F6E4C"
	initial_generic_waypoints = list("mining_outpost")

/obj/effect/overmap/visitable/sector/gaia_planet
	name = "Gaia Planet"
	desc = "A planet with peaceful life, and ample flora."
	scanner_desc = @{"[i]Incoming Message[/i]: Hello travler! Looking to enjoy the shine of the star on land?
Are you weary from all that constant space travel?
Looking to quench a thirst of multiple types?
Then look no further than the resorts of Sigmar!
With a branch on every known Gaia planet, we aim to please and serve.
Our fully automated ---- [i]Message exceeds character limit.[/i]
[i] Information [/i]
Atmosphere: Breathable with standard human required environment
Weather: Sunny, with chance of showers and thunderstorms. 25C
Lifesign: Multiple Fauna. No history of hostile life recorded
Ownership: Planet is owned by the Happy Days and Sunshine Corporation.
Allignment: Neutral to NanoTrasen. No Discount for services expected."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#33BB33"

/obj/effect/overmap/visitable/sector/class_p
	name = "Frozen Planet"
	desc = "A world shrouded in cold and snow that seems to never let up."
	scanner_desc = @{"[i]Information[/i]: A planet with a very cold atmosphere. Possible life signs detected."}
	icon_state = "globe"
	color = "#3434AA"
	known = FALSE
	in_space = 0

/*
/obj/effect/overmap/visitable/sector/trade_post
	name = "Nebula Gas Food Mart"
	desc = "A ubiquitous chain of traders common in this area of the Galaxy."
	scanner_desc = @{"[i]Information[/i]: A trade post and fuel depot. Possible life signs detected."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#8F6E4C"

	initial_generic_waypoints = list("nebula_space_SW")

	initial_restricted_waypoints = list(
		"Beruang Trade Ship" = list("tradeport_hangar"),
		"Mining Shuttle" = list("nebula_pad_2"),
		"Excursion Shuttle" = list("nebula_pad_3"),
		"Pirate Skiff" = list("nebula_pad_4"),
		"Dart EMT Shuttle" = list("nebula_pad_5"),
		"Civilian Transport" = list("nebula_pad_6")
		)
*/
