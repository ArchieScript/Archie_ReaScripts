--[[
   * Category:    Item
   * Description: Ignore item(s) lock with Ctrl Shift or Alt + left  click
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Ignore item(s) lock with Ctrl Shift or Alt + left  click
   * О скрипте:   Игнорировать блокировку элементов с помощью Ctrl Shift или Alt + левый клик
   * GIF:         http://archiescript.github.io/ReaScriptSiteGif/html/IgnoreItemLockWithCtrlShiftOrAltLeftClick.html
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   Moyses(RMM)
   * Changelog:   +  initialе / v.1.0 [17022019]
   ===========================================================================================

   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.10.0 -------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.8.5 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   + reaper_js_ReaScriptAPI...-| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
   ==========================================================================================]]





    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	



    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;

    local js_API = Arc.js_ReaScriptAPI(true);
    if not js_API then Arc.no_undo() return end;

    Arc.HelpWindowWhenReRunning(1,"CtrlAltShiftUngroup",false);

    local T = {};
    local MouseClick,lock,lock2,item_1,Guid_,lock_;

    local function loop();
        local window, segment, details = reaper.BR_GetMouseCursorContext();
        local item = reaper.BR_GetMouseCursorContext_Item();


        if not Arc.If_Equals(reaper.JS_Mouse_GetState(29),17,5,9,21,13,25,29) then;
            MouseClick = "Active";
        end;

        if MouseClick == "Active" then;

            if item or Active then;

                local JS_Mouse = reaper.JS_Mouse_GetState(29);

                if item_1 and item_1 ~= item then JS_Mouse = -1 MouseClick = nil end;

                if Arc.If_Equals(JS_Mouse,17,5,9,21,13,25,29) then;

                    MouseClick = nil;

                    if not lock  then;
                       lock = reaper.GetMediaItemInfo_Value(item, "C_LOCK");
                    end;

                    if lock ~= 0 then;
                        local lock2 = reaper.GetMediaItemInfo_Value(item,"C_LOCK");
                        if lock2 ~= 0 then;
                            for i = 1,reaper.CountSelectedMediaItems(0) do;
                                local SelItem = reaper.GetSelectedMediaItem(0,i-1);
                                local guidString = reaper.BR_GetMediaItemGUID(SelItem);
                                local AllLock = reaper.GetMediaItemInfo_Value(SelItem,"C_LOCK");
                                T[#T+1] = guidString..AllLock;
                                reaper.SetMediaItemInfo_Value(SelItem,"C_LOCK",0);
                            end;
                        end;
                    end;

                    Active = "Active";

                    if not item_1 then item_1 = item end;

                else;

                    if lock then;

                        if #T > 0 then;
                            for i = 1, #T do;
                                Guid_,lock_ = string.match(T[i],"({.+})(.+)");
                                local it = reaper.BR_GetMediaItemByGUID(0,Guid_);
                                if it then;
                                    reaper.SetMediaItemInfo_Value(it,"C_LOCK",lock_);
                                end;
                            end;
                        end;

                        lock = nil;
                        Active = nil;
                        item_1 = nil;
                        T = {};
                        MouseClick = nil;
                    end;
                end;
            end;
        end;

        reaper.defer(loop);

        local ProjState = reaper.GetProjectStateChangeCount(0);
        if ProjState ~= ProjState2 then;
            reaper.UpdateArrange();
            ProjState2 = ProjState;
        end;
    end;


    local ErScr = pcall(loop,"");
    if ErScr == true then;
        Arc.SetToggleButtonOnOff(1);
    end;

    reaper.atexit(Arc.SetToggleButtonOnOff);
