--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * ---------------------
   * Changelog:   + Action(id)
--==========================]]



    --======================================================================================
    --///////////  FUNCTIONS  \\\\\\\\\\\\  FUNCTIONS  ////////////  FUNCTIONS  \\\\\\\\\\\\
    --======================================================================================




    --===================
	local Arc_Module = {}
    --===================

	
    ------------------------------------
	local function Arc_Module.Action(id)
        reaper.Main_OnCommand(reaper.NamedCommandLookup(id),0)
    end
    --========================================================
	
	
	
	

    --===============
    return Arc_Module
    --===============