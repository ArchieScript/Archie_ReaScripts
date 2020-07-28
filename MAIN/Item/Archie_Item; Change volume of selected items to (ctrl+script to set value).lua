--[[
   * Category:    Item
   * Description: Change volume of selected items to (ctrl+script to set the value)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Измените громкость выбранных элементов на (ctrl+script, чтобы установить значение)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Changelog:
   *              v.1.0 [07062019]
   *                  +  initialе


   --=======================================================================================
         SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (+) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (+) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	




    local Api_js = Arc.js_ReaScriptAPI(true,0.987);
    if not Api_js then Arc.no_undo() return end;


    local section = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");


    local GetState = reaper.JS_Mouse_GetState(127);
    if GetState == 4 then;
        ::repeat_1::;
        local retval,retvals_csv = reaper.GetUserInputs("Change volume to",1,"Change volume to db",
                                                tonumber(reaper.GetExtState(section,"val_db"))or 0);
        if not retval then Arc.no_undo() return end;
        retvals_csv = tonumber(retvals_csv);

        if not retvals_csv or retvals_csv < -150 or retvals_csv > 150 then;
            local MB = reaper.MB("RUS:\n\nНеверные значения:\nЗначение должны быть от -150 до 150 дБ\n\n\n"..
                            "ENG:\n\nIncorrect value:\nThe value must be between -150 and 150 db","ERROR",5);
            if MB == 4 then goto repeat_1 end;
            if MB == 2 then Arc.no_undo() return end;
        end
        reaper.DeleteExtState(section,"val_db",true);
        reaper.SetExtState(section,"val_db",retvals_csv,true);
        Arc.no_undo() return;
    end;



    local Count = reaper.CountSelectedMediaItems(0);
    if Count == 0 then Arc.no_undo() return end;

    local value_from_dB = tonumber(reaper.GetExtState(section,"val_db"))or 0;

    local Undo;
    for i = 1,Count do;
       local item = reaper.GetSelectedMediaItem(0,i-1);
       local take = reaper.GetMediaItemTake(item,0);
       if not reaper.TakeIsMIDI(take)then;
           local vol = reaper.GetMediaItemInfo_Value(item,'D_VOL');
           local DB = 20 * math.log(vol,10);
           if DB <= -150 then DB = -150 end;
           if DB >= 24 then DB = 24 end;
           local value = DB + value_from_dB;
           if value <= -150 then value = -150 end;
           if value >= 24 then value = 24 end;
           local  val = (10^(value/20));
           reaper.SetMediaItemInfo_Value(item,'D_VOL',val);
           if not Undo then;
               reaper.Undo_BeginBlock();
               Undo = true;
           end;
       end;
    end;

    reaper.UpdateArrange();

    if Undo then;
        reaper.Undo_EndBlock(value_from_dB..' dB change volume to',-1);
    else;
        Arc.no_undo();
    end;