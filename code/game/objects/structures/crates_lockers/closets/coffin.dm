/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	setup = 0

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/sarcophagus
	name = "sarcophagus"
	desc = "A heavy, stone sarcophagus made of the same black stone as the abbey."
	icon_state = "sarcofagus"
	icon_closed = "sarcofagus"
	icon_opened = "sarcofagus_open"
	setup = 0

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened
