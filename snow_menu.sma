#include <amxmodx>
#include <engine>

#pragma semicolon 1

new const MENU_ID[] = "_snow_menu";
new const CL_CVAR[] = "cl_weather";

const MENU_KEYS = MENU_KEY_1|MENU_KEY_2;

new g_Snow[33];

public plugin_precache() {
	new pEnt = create_entity("env_snow");
	if(!pEnt) {
		set_fail_state("Failed to create entity");
	}
	pEnt = -1;
	while((pEnt = find_ent_by_class(pEnt, "env_rain"))) {
		remove_entity(pEnt);
	}
}

public plugin_init() {
	register_plugin("Snow menu", "0.1", "AMXX.Shop");
	register_dictionary("snow_menu.txt");
	register_clcmd("say /snow", "CmdSnow");
	register_menucmd(register_menuid(MENU_ID), MENU_KEYS, "HandleMenu");
}

public client_putinserver(id) {
	query_client_cvar(id, CL_CVAR, "CvarResult");
}

public CvarResult(const id, const Cvar[], const Value[]) {
	g_Snow[id] = str_to_num(Value);
}

public CmdSnow(const id) {
	new Menu[512], Buffer[32];
	formatex(Buffer, charsmax(Buffer), "SM_INTENSITY_%d", g_Snow[id]);
	formatex(Menu, charsmax(Menu), "\y%L^n^n\y1. \w%L^n\y2. \w%L", id, "SM_TITLE", id, Buffer, id, "SM_EXIT");
	return show_menu(id, MENU_KEYS, Menu, -1, MENU_ID);
}

public HandleMenu(const id, const Key) {
	if(Key) {
		return PLUGIN_HANDLED;
	} else if(++g_Snow[id] > 3) {
		g_Snow[id] = 0;
	}
	client_cmd(id, "%s %d", CL_CVAR, g_Snow[id]);
	return CmdSnow(id);
}
