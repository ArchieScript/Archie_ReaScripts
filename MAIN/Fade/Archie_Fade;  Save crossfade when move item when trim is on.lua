--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fade
   * Description: Save crossfade when move item when trim is on
   * Author:      Archie
   * Version:     1.03
   * AboutScript: ---
   * О скрипте:   Сохранить кроссфейд при перемещении элемента при включенной обрезке
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2078597/ce072a98-1978-4dc5-bf92-0416fc46b167/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   *                  http://rmmedia.ru/threads/134701/post-2389975
   * Extension:   SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   *              Arc_Function_lua v.2.4.8 +  Repository - (Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:   
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
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.8",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    local Api_js,version = Arc.js_ReaScriptAPI(true,0.99);
    local Api_sws = Arc.SWS_API(true); 
    Arc.HelpWindowWhenReRunning(1,"Arc_Function_lua",false);
    
    
    
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
    
    
    
    local ToggleTrimBehind = reaper.GetToggleCommandStateEx(0,41117);--Toggle trim behind items when editing
    if ToggleTrimBehind ~= 1 then;
        local MB = reaper.MB(
                   'Rus:\n\nДля работы скрипта должен быть включен\n'..
                   '"trim behind items when editing"\n\nВключить ?\n'..("-"):rep(55)..'\n\n\n'..
                   'Eng:\n\nTo run the script must be enabled\n"trim behind items when editing"\n\n'..
                   'Enable ?'
                   ,"Woops",1);
        if MB == 2 then Arc.no_undo() return end;
        if MB == 1 then; 
            reaper.Main_OnCommand(41120,0);--Enable trim
        end;  
    end;
    
    
    
    local ToggleAutoCrossfade = reaper.GetToggleCommandStateEx(0,40041)--Toggle auto-crossfade on/off
    if ToggleAutoCrossfade ~= 1 then;
        local MB = reaper.MB(
                   'Rus:\n\nДля работы скрипта должен быть включен\n'..
                   '"Auto-crossfade media items when editing"\n\nВключить ?\n'..("-"):rep(55)..'\n\n\n'..
                   'Eng:\n\nTo run the script must be enabled\n"Auto-crossfade media items when editing"\n\nEnable ?"\n\n'..
                   'Enable ?'
                   ,"Woops",1);
        if MB == 2 then Arc.no_undo() return end;
        if MB == 1 then; 
             reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
             
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
                    local MB = reaper.MB('Rus:\n\n"trim behind items when editing" был отключен.\nВключите "trim behind items when editing"'..
                                         'или скрипт завершит работу.\n\nВключить "trim behind items when editing" ?\n'..
                                         ("-"):rep(35)..'\n\n\n'..
                                         'Eng:\n\n"trim behind items when editing" was disabled.\nTurn on "trim behind items when editing"\n'..
                                         'or the script will shut down\n\nEnable "trim behind items when editing" ?\n',
                                         "Woops! / Save crossfade when move item trim is on",1);
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
                    local MB = reaper.MB('Rus:\n\n"Auto-crossfade" был отключен.\nВключите "Auto-crossfade"'..
                                         'или скрипт завершит работу.\n\nВключить "Auto-crossfade" ?\n'..
                                         ("-"):rep(35)..'\n\n\n'..
                                         'Eng:\n\n"Auto-crossfade" was disabled.\nTurn on"Auto-crossfade"\n'..
                                         'or the script will shut down\n\nEnable "Auto-crossfade" ?\n',
                                         "Woops! / Save crossfade when move item trim is on",1);
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
                if DisableAutoCros then;
                    reaper.Main_OnCommand(41118,0);--Enable auto-crossfades
                    DisableAutoCros = nil;
                end;
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