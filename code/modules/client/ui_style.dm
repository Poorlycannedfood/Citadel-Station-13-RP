

/var/all_ui_styles = list(
	UI_STYLE_MIDNIGHT     = 'icons/mob/screen/midnight.dmi',
	UI_STYLE_ORANGE       = 'icons/mob/screen/orange.dmi',
	UI_STYLE_OLD          = 'icons/mob/screen/old.dmi',
	UI_STYLE_WHITE        = 'icons/mob/screen/white.dmi',
	UI_STYLE_OLD_NOBORDER = 'icons/mob/screen/old-noborder.dmi',
	UI_STYLE_MINIMALIST   = 'icons/mob/screen/minimalist.dmi',
	UI_STYLE_HOLOGRAM     = 'icons/mob/screen/holo.dmi'
	)

/var/all_ui_styles_robot = list(
	UI_STYLE_MIDNIGHT     = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_ORANGE       = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_OLD          = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_WHITE        = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_OLD_NOBORDER = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_MINIMALIST   = 'icons/mob/screen1_robot_minimalist.dmi',
	UI_STYLE_HOLOGRAM     = 'icons/mob/screen1_robot_minimalist.dmi'
	)

var/global/list/all_tooltip_styles = list(
	"Midnight",		//Default for everyone is the first one,
	"Plasmafire",
	"Retro",
	"Slimecore",
	"Operative",
	"Clockwork"
	)

/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	return all_ui_styles[UI_STYLE_WHITE]


/client/verb/change_ui()
	set name = "Change UI"
	set category = "Preferences"
	set desc = "Configure your user interface"

	if(!ishuman(usr))
		if(!isrobot(usr))
			to_chat(usr, SPAN_WARNING("You must be a human or a robot to use this verb."))
			return

	var/UI_style_new = input(usr, "Select a style. White is recommended for customization") as null|anything in all_ui_styles
	if(!UI_style_new) return

	var/UI_style_alpha_new = input(usr, "Select a new alpha (transparency) parameter for your UI, between 50 and 255") as null|num
	if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
		return

	var/UI_style_color_new = input(usr, "Choose your UI color. Dark colors are not recommended!") as color|null
	if(!UI_style_color_new) return

	//update UI
	var/list/icons = usr.hud_used.adding + usr.hud_used.other + usr.hud_used.hotkeybuttons
	icons.Add(usr.zone_sel)
	icons.Add(usr.gun_setting_icon)
	icons.Add(usr.item_use_icon)
	icons.Add(usr.gun_move_icon)
	icons.Add(usr.radio_use_icon)

	var/icon/ic = all_ui_styles[UI_style_new]
	if(isrobot(usr))
		ic = all_ui_styles_robot[UI_style_new]

	for(var/atom/movable/screen/I in icons)
		if(I.name in list(INTENT_HELP, INTENT_HARM, INTENT_DISARM, INTENT_GRAB)) continue
		I.icon = ic
		I.color = UI_style_color_new
		I.alpha = UI_style_alpha_new


	if(alert("Like it? Save changes?",,"Yes", "No") == "Yes")
		prefs.UI_style = UI_style_new
		prefs.UI_style_alpha = UI_style_alpha_new
		prefs.UI_style_color = UI_style_color_new
		SScharacter_setup.queue_preferences_save(prefs)
		to_chat(usr, "UI was saved")
