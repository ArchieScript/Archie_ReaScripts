--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fade
   * Description: Save crossfade when move item when trim is on
   * Author:      Archie
   * Version:     1.08
   * AboutScript: ---
   * О скрипте:   Сохранить кроссфейд при перемещении элемента при включенной обрезке
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2078597/ce072a98-1978-4dc5-bf92-0416fc46b167/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   *                  http://rmmedia.ru/threads/134701/post-2389975
   * Extension:   SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   *              Arc_Function_lua v.2.4.8 +  Repository - (Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:
   *              v.1.06 [19.06.20]
   *                  +  fix (http://forum.cockos.com/showpost.php?p=2306173&postcount=22)

   *              v.1.05 [19.06.20]
   *                  +  fixed bug (http://forum.cockos.com/showpost.php?p=2306049&postcount=20)
   *              v.1.04 [28.08.19]
   *                  +  Remove Enable "Overlap and crossfade items when splitting-length"
   *              v.1.03 [28.08.19]
   *                  +  Disable "Show overlapping media items in lanes" due to incompatibility
   *              v.1.02 [28.08.19]
   *                  +  No change
   *              v.1.01 [28.08.19]
   *                  + request or disable the script when you disable trim or autocrossfade
   *              v.1.0 [28.08.19]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local WIND_HELP = false;
                 -- = true; Показать окна с подсказками
                 -- = false; Непоказыть окна с подсказками

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



    local Api_js,version = Arc.js_ReaScriptAPI(true,0.99);
    local Api_sws = Arc.SWS_API(true);
     --Arc.HelpWindowWhenReRunning(1,"Arc_Function_lua",false);--T_I


    --[[
    local OverlapAndCrossfadeX = reaper.SNM_GetIntConfigVar("splitautoxfade",0);
    local OverlapAndCrossfade = OverlapAndCrossfadeX&1;
    if OverlapAndCrossfade == 0 then;
        local MB = reaper.MB(
                             'Rus:\n\nДля работы скрипта должно быть включено в настройках\n'..
                             '"Overlap and crossfade items when splitting-length"\n\n'..
                             'флажок (выкл) - Включить ?\n'..("-"):rep(80)..'\n\n'..
                             'Eng:\n\nFor the script to work, it must be enabled in the settings\n'..
                             '"Overlap and crossfade items when splitting-length"\n\n'..
                             'checkbox (off) - Enable?',
                             'Woops',1);
        if MB == 2 then Arc.no_undo() return end;
        if MB == 1 then;
            reaper.SNM_SetIntConfigVar("splitautoxfade",OverlapAndCrossfadeX|1);
        end;
    end;
    --]]


    local ToggleTrimBehind = reaper.GetToggleCommandStateEx(0,41117);--Toggle trim behind items when editing
    if ToggleTrimBehind ~= 1 then;
        local MB
        if WIND_HELP then;--v.1.06
            MB = reaper.MB(
                       'Rus:\n\nДля работы скрипта должен быть включен\n'..
                       '"trim behind items when editing"\n\nВключить ?\n'..("-"):rep(55)..'\n\n\n'..
                       'Eng:\n\nTo run the script must be enabled\n"trim behind items when editing"\n\n'..
                       'Enable ?'
                       ,"Woops",1);
        else;--v.1.06
            MB = 1;--v.1.06
        end;--v.1.06
        if MB == 2 then Arc.no_undo() return end;
        if MB == 1 then;
            reaper.Main_OnCommand(41120,0);--Enable trim
            reaper.SetExtState("SaveCrossFade","Toggle trim behind items",0,false);--v.1.06
            --reaper.ShowConsoleMsg("Toggle trim behind items\n")-------------------------
        end;
    end;



    local ToggleAutoCrossfade = reaper.GetToggleCommandStateEx(0,40041)--Toggle auto-crossfade on/off
    if ToggleAutoCrossfade ~= 1 then;
        local MB
        if WIND_HELP then;--v.1.06
            MB = reaper.MB(
                       'Rus:\n\nДля работы скрипта должен быть включен\n'..
                       '"Auto-crossfade media items when editing"\n\nВключить ?\n'..("-"):rep(55)..'\n\n\n'..
                       'Eng:\n\nTo run the script must be enabled\n"Auto-crossfade media items when editing"\n\nEnable ?"\n\n'..
                       'Enable ?'
                       ,"Woops",1);
        else;--v.1.06
            MB = 1;--v.1.06
        end;--v.1.06
        if MB == 2 then;
            local Tgl_trim_b1 = tonumber(reaper.GetExtState("SaveCrossFade","Toggle trim behind items"));
            if Tgl_trim_b1 then;
                reaper.DeleteExtState("SaveCrossFade","Toggle trim behind items",false);
            end;
            if ToggleTrimBehind ~= 1 then;
                local ToggleTrimBehind = reaper.GetToggleCommandStateEx(0,41117);--Toggle trim behind items when editing
                if ToggleTrimBehind == 1 then;
                    reaper.Main_OnCommand(41121,0);--Disable trim
                end;
            end;
            Arc.no_undo()return;
        end;
        if MB == 1 then;
            reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
            reaper.SetExtState("SaveCrossFade","Auto-crossfade media items",0,false);--v.1.06
            --reaper.ShowConsoleMsg("Auto-crossfade media items\n")-------------------------
        end;
    end;


    reaper.DeleteExtState("SaveCrossFade","SaveCrossFadeX",false);
    local ShowOverMediaI = reaper.GetToggleCommandStateEx(0,40507)--Show overlapping media items in lanes
    if ShowOverMediaI == 1 then;
        reaper.Main_OnCommand(40507,0);
        reaper.SetExtState("SaveCrossFade","SaveCrossFadeX",1,false);
    end;




    local function exit();
        local _,_,sectionID,cmdID,_,_,_ = reaper.get_action_context();
        reaper.SetToggleCommandState(sectionID,cmdID,0);
        reaper.RefreshToolbar2(sectionID,cmdID);
        pcall(loop,true);
        --(v.1.06
        local Toggle_trim_behind1 = tonumber(reaper.GetExtState("SaveCrossFade","Toggle trim behind items"));
        if Toggle_trim_behind1 then;
            reaper.DeleteExtState("SaveCrossFade","Toggle trim behind items",false);
            local ToggleTrimBehind2 = reaper.GetToggleCommandStateEx(0,41117);--Toggle trim behind items when editing
            if ToggleTrimBehind2 == 1 then;
                reaper.Main_OnCommand(41121,0);--Disable trim
            end;
        end;

        local Auto_crossfad_item1 = tonumber(reaper.GetExtState("SaveCrossFade","Auto-crossfade media items"));
        if Auto_crossfad_item1 then;
            reaper.DeleteExtState("SaveCrossFade","Auto-crossfade media items",false);
            local ToggleAutoCrossfade2 = reaper.GetToggleCommandStateEx(0,40041)--Toggle auto-crossfade on/off
            if ToggleAutoCrossfade2 == 1 then;
                reaper.Main_OnCommand(41119,0);--Disable auto-crossfades
            end;
        end;
        --v.1.06)


        local GetExtState = tonumber(reaper.GetExtState("SaveCrossFade","SaveCrossFadeX"))or 0;
        local ShowOverMed = reaper.GetToggleCommandStateEx(0,40507)--Show overlapping media items in lanes
        if GetExtState == 1 then;
            if ShowOverMed ~= 1 then; reaper.Main_OnCommand(40507,0); end;
        elseif GetExtState == 2 then;
            local MB = reaper.MB('Rus:\n\nПри включении скрипта был включен\n'..
                                 '"Show overlapping media items in lanes"\n'..
                                 'Но скрипт отключил его\n\n'..
                                 'Включить Повторно ?\n'..
                                 ("-"):rep(55)..'\n\n'..
                                 'Eng:\n\nWhen you turn on the script was turned on\n'..
                                 '"Show overlapping media items in lanes"\n'..
                                 'But the script disabled it\n\n'..
                                 'Re-enable ?',
                                 'save crossfade when move item when trim is on',1);
            if MB == 2 then Arc.no_undo() return end;
            if ShowOverMed ~= 1 then; reaper.Main_OnCommand(40507,0); end;
        end;
    end;





    local MousItActive,checking,DisableAutoCros,Tr,Ac,ShowOverMediaIX;

    local function loop(stop)
        --T=(T or 0)+1
        if stop then return -1 end;

        local ShowOverMediaI_2 = reaper.GetToggleCommandStateEx(0,40507)--Show overlapping media items in lanes
        if ShowOverMediaI_2 == 1 then;
            reaper.Main_OnCommand(40507,0);
            if not ShowOverMediaIX then;
                local GetExtState = tonumber(reaper.GetExtState("SaveCrossFade","SaveCrossFadeX"))or 0;
                if GetExtState == 1 then;
                    reaper.SetExtState("SaveCrossFade","SaveCrossFadeX", 2,false);
                    ShowOverMediaIX = true;
                end;
            end;
        end;

        local ToggleTrimBehind = reaper.GetToggleCommandStateEx(0,41117);--Toggle trim behind items when editing
        if ToggleTrimBehind ~= 1 then;
            local Mouse_State = reaper.JS_Mouse_GetState(1);
            if Mouse_State ~= 1 then;
                Tr=(Tr or 0)+1;
                if Tr >= 10 then;
                    local MB;
                    if WIND_HELP then;--v.1.06
                        MB = reaper.MB('Rus:\n\n"trim behind items when editing" был отключен.\nВключите "trim behind items when editing"'..
                                       'или скрипт завершит работу.\n\nВключить "trim behind items when editing" ?\n'..
                                       ("-"):rep(35)..'\n\n\n'..
                                       'Eng:\n\n"trim behind items when editing" was disabled.\nTurn on "trim behind items when editing"\n'..
                                       'or the script will shut down\n\nEnable "trim behind items when editing" ?\n',
                                       "Woops! / Save crossfade when move item trim is on",1);
                    else;--v.1.06
                        MB = 2;--v.1.06
                    end;--v.1.06

                    if MB == 1 then;
                        Tr = 0;
                        reaper.Main_OnCommand(41120,0);--Enable trim
                    elseif MB == 2 then;
                        exit()Arc.no_undo()return;
                    end;
                end;
            else;
                Tr = 0;
            end;
        end;


        local ToggleAutoCrossfade = reaper.GetToggleCommandStateEx(0,40041)--Toggle auto-crossfade on/off
        if ToggleAutoCrossfade ~= 1 then;
            local Mouse_State = reaper.JS_Mouse_GetState(1);
            if Mouse_State ~= 1 then;
                Ac=(Ac or 0)+1;
                if Ac >= 10 then;
                    local MB;
                    if WIND_HELP then;--v.1.06
                        MB = reaper.MB('Rus:\n\n"Auto-crossfade" был отключен.\nВключите "Auto-crossfade"'..
                                       'или скрипт завершит работу.\n\nВключить "Auto-crossfade" ?\n'..
                                       ("-"):rep(35)..'\n\n\n'..
                                       'Eng:\n\n"Auto-crossfade" was disabled.\nTurn on"Auto-crossfade"\n'..
                                       'or the script will shut down\n\nEnable "Auto-crossfade" ?\n',
                                       "Woops! / Save crossfade when move item trim is on",1);
                    else;--v.1.06
                        MB = 2;--v.1.06
                    end;--v.1.06

                    if MB == 1 then;
                        Ac = 0;
                        reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
                    elseif MB == 2 then;
                        exit()Arc.no_undo()return;
                    end;
                end;
            else;
                Ac = 0;
            end;
        end;


        ----------------------
        local x, y = reaper.GetMousePosition();
        local item,take = reaper.GetItemFromPoint(x,y,false);

        if item then;
            local Mouse_GetState = reaper.JS_Mouse_GetState(1);
            if Mouse_GetState == 1 then;
                if not checking then;
                    checking = true;
                    local fadeIn = reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO");
                    local fadeOut = reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO");
                    if fadeIn ~= 0 or fadeOut ~= 0 then;
                        local TogAutoCrossfade = reaper.GetToggleCommandStateEx(0,40041)--Toggle auto-crossfade on/off
                        if TogAutoCrossfade == 1 then;
                            reaper.Main_OnCommand(41119,0);--Disable auto-cros
                            DisableAutoCros = true;
                        end;
                        MousItActive = true;
                    end;
                end;
            else;
                checking=nil;
            end;

            if Mouse_GetState == 0 and MousItActive then;

                local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
                local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
                local fadeIn = reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO");
                if fadeIn == 0 then;
                    fadeIn = reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN");
                end;
                local fadeOut = reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO");
                if fadeOut == 0 then;
                    fadeOut = reaper.GetMediaItemInfo_Value(item,"D_FADEOUTLEN");
                end;

                ----(v.1.05
                if DisableAutoCros then;
                    reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
                    DisableAutoCros = nil;
                end;
                ----v.1.05)

                local trackIt = reaper.GetMediaItemInfo_Value(item, "P_TRACK");
                local CountTracItem = reaper.CountTrackMediaItems(trackIt);
                for i = 1,CountTracItem do;
                    local item2 =  reaper.GetTrackMediaItem(trackIt,i-1);
                    local pos2 = reaper.GetMediaItemInfo_Value(item2,"D_POSITION");
                    local len2 = reaper.GetMediaItemInfo_Value(item2,"D_LENGTH");
                    if pos2+len2 == pos then;
                        reaper.SetMediaItemInfo_Value(item2,"D_FADEOUTLEN_AUTO",fadeIn);
                        reaper.SetMediaItemInfo_Value(item2,"D_LENGTH",pos+fadeIn-pos2);
                    end;
                    if pos2 == pos+len then;
                        if fadeOut > len2 then fadeOut = len2 end;
                        reaper.SetMediaItemInfo_Value(item2,"D_FADEINLEN_AUTO",fadeOut);
                        --reaper.SetMediaItemInfo_Value(item, "D_LENGTH",pos2+fadeOut);
                        Arc.SetMediaItemLeftTrim2(pos2-fadeOut,item2);
                    end;
                end;
                --[[v.1.05  переместить выше ^^^
                if DisableAutoCros then;
                    reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
                    DisableAutoCros = nil;
                end;
                --]]
                MousItActive = nil;
            end;
        end;
        ----------------------
        reaper.defer(loop);
    end;


    local _,_,sectionID,cmdID,_,_,_ = reaper.get_action_context();
    reaper.SetToggleCommandState(sectionID,cmdID,1);
    reaper.RefreshToolbar2(sectionID,cmdID);
    loop(false);
    reaper.atexit(exit);

    reaper.defer(function();local ScrPath,ScrName = debug.getinfo(1,'S').source:match('^[@](.+)[/\\](.+)');Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,ScrPath,ScrName)end);
