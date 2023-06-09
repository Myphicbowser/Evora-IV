#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/comm_monitor
	name = T_BOARD("telecommunications monitor console")
	build_path = /obj/machinery/computer/telecomms/monitor
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/comm_server
	name = T_BOARD("telecommunications server monitor console")
	build_path = /obj/machinery/computer/telecomms/server
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/comm_traffic
	name = T_BOARD("telecommunications traffic control console")
	build_path = /obj/machinery/computer/telecomms/traffic
	origin_tech = list(TECH_DATA = 2)
