--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Track; Auto open-close FX chain windows.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Snjuk(rmm) 
   * Gave idea:   Snjuk(rmm) 
   * Extension:   Reaper 6.12+ http://www.reaper.fm/ 
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.8.7+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.0 [610720] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.7",file,'')then;A=nil;return;end;return A; 
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    --========================================= 
     
     
    function clone(org) 
       return {table.unpack(org)} 
    end 
     
     
    function ComparedTwoTables(table1, table2); 
        if #table1 ~= #table2 then return false end; 
        for key, val in pairs(table1) do; 
            if table2[key] ~= val then; 
                return false; 
            end; 
        end; 
        for key, val in pairs(table2) do; 
            if table1[key] ~= val then; 
                return false; 
            end; 
        end; 
        return true; 
    end; 
     
     
     
    local function loop(); 
     
        local ChangesInProj = Arc.ChangesInProject(1); 
        if ChangesInProj then; 
         
            local CountTrack = reaper.CountTracks(0); 
            if CountTrack > 0 then 
                 
                 
                local _,t1 = Arc.Save_Selected_Track_Slot(1); 
                local tbl_check = ComparedTwoTables((t1 or {}),(t3 or {})); 
                if not tbl_check then; 
                 
                 
                    local CountTrack = reaper.CountTracks(0); 
                    for i = 1, CountTrack do; 
                        local tr = reaper.GetTrack(0,i-1); 
                        local sel = reaper.GetMediaTrackInfo_Value(tr,'I_SELECTED'); 
                        reaper.SetMediaTrackInfo_Value(tr,'I_SELECTED',math.abs(sel-1)); 
                    end; 
                  
                    local _,t2 = Arc.Save_Selected_Track_Slot(2); 
                 
                 
                    local tr = reaper.GetTrack(0,0); 
                    reaper.SetOnlyTrackSelected(tr); 
                    reaper.SetMediaTrackInfo_Value(tr,'I_SELECTED',0); 
                     
                    if type(t2)=='table' then; 
                        for i = 1, #t2 do; 
                            reaper.SetMediaTrackInfo_Value(t2[i],'I_SELECTED',1); 
                            local id = reaper.NamedCommandLookup('_S&M_TOGLFXCHAIN')--SWS/S&M: Toggle show FX chain windows for selected tracks 
                            local tgl = reaper.GetToggleCommandStateEx(0,id); 
                            if tgl == 1 then; 
                                reaper.Main_OnCommand(id,0); 
                            end; 
                            reaper.SetMediaTrackInfo_Value(t2[i],'I_SELECTED',0); 
                        end; 
                    end; 
                 
                    if type(t1)=='table' then; 
                        for i = 1, #t1 do; 
                            reaper.SetMediaTrackInfo_Value(t1[i],'I_SELECTED',1); 
                            local id = reaper.NamedCommandLookup('_S&M_TOGLFXCHAIN')--SWS/S&M: Toggle show FX chain windows for selected tracks 
                            local tgl = reaper.GetToggleCommandStateEx(0,id); 
                            if tgl == 0 then; 
                                reaper.Main_OnCommand(id,0); 
                            end; 
                            reaper.SetMediaTrackInfo_Value(t1[i],'I_SELECTED',0); 
                        end; 
                    end; 
                     
                    Arc.Restore_Selected_Track_Slot(1,true); 
                end; 
                t3 = clone((t1 or {})); 
            end; 
        end; 
        reaper.defer(loop); 
    end; 
     
     
    reaper.defer(loop); 
    SetToggleButtonOnOff(1); 
    reaper.atexit(SetToggleButtonOnOff); 
     
    reaper.defer(function();local ScrPath,ScrName = debug.getinfo(1,'S').source:match('^[@](.+)[/\\](.+)');Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,ScrPath,ScrName)end); 
     
     
     
     
     