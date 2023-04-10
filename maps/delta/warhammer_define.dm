
/datum/map/warhammer
	name = "Evora"
	full_name = "Evora IV"
	path = "warhammer"
	station_name  = "The March of Aquileia"
	station_short = "Aquileia"
	dock_name     = "Aquileia"
	boss_name     = "Planetary Command"
	boss_short    = "PC"
	company_name  = "Imperium of Man"
	company_short = "Imperium"
	system_name = "Evora-Laanah System"

	lobby_icon = 'maps/delta/fullscreen.dmi'
	lobby_screens = list("lobby1","lobby2","lobby3","lobby4")

	station_levels = list(1,2,3,4)
	contact_levels = list(1,2,3,4)
	player_levels = list(1,2,3,4)

	allowed_spawns = list("Arrivals Shuttle")
	base_turf_by_z = list("1" = /turf/simulated/floor/dirty, "2" = /turf/simulated/floor/dirty, "3" = /turf/simulated/floor/dirty,"4" = /turf/simulated/floor/dirty)
	shuttle_docked_message = "The slipstream has been opened."
	shuttle_leaving_dock = "The slipstream is closing."
	shuttle_called_message = "A requested slipstream is being opened."
	shuttle_recall_message = "The slipstream opening has been aborted"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
	map_lore = "The planetoid Evora IV is at the very edge of human influence, far beyond the Laanah rifts of the Segmentum Pacificus and bordering the Halo Stars. This world once thrived as a frontier trading hub, but that all changed on the day of Our Lord of Aquileia when the many faithful in the fair city simultaneously heard a glorious voice, which all who listented understood to be that of the God Emperor himself. Dozens were killed immediately from the pure power of his voice. Warp storms started that day, nearly eighty years later they have not ceased. Our system was cut off and unable to communicate with the rest of humanity. We wonder why our God Emperor has trapped us here, and we can only guess why from the one word uttered that day, 'prepare' "



//Overriding event containers to remove random events.
/datum/event_container/mundane
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
		)

/datum/event_container/moderate
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
	)

/datum/event_container/major
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
	)