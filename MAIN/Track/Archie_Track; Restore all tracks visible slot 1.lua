--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Restore all tracks visible slot 1.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Shico(Rmm)
   * Gave idea:   Shico(Rmm)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [300520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local SLOT = 1;

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local function no_undo()reaper.defer(function()end)end;


    local ProjExtState = 'ARCHIE_SAVE_TRACK_VISIBLE_SLOT'..(SLOT or 1);

    reaper.PreventUIRefresh(1);

    for i = 1, math.huge do;
	   local retval,key,value = reaper.EnumProjExtState(0,ProjExtState,i-1);
	   if retval then;
		  local track = reaper.BR_GetMediaTrackByGUID(0,key);
		  if track then;
			 local visibTcp,visibMcp = value:match("(.*)&(.*)");
			 if visibTcp and visibMcp then;
				reaper.SetMediaTrackInfo_Value(track,"B_SHOWINTCP",visibTcp);
				reaper.SetMediaTrackInfo_Value(track,"B_SHOWINMIXER",visibMcp);
			 end;
		  end;
		
	   else;
		  break;
	   end;
    end;

    -- reaper.SetProjExtState(0,ProjExtState,"","");

    no_undo();
    reaper.TrackList_AdjustWindows(false);
    reaper.PreventUIRefresh(-1);

