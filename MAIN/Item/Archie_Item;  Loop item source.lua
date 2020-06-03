--[[ New Instance
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Loop item source.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   * Provides:
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.13.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.0+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [030620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --==== FUNCTION MODULE FUNCTION ======================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==================
    local P,F,L,A=reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions','/Arc_Function_lua.lua';L,A=pcall(dofile,P..F);if not L then
    reaper.RecursiveCreateDirectory(P,0);reaper.ShowConsoleMsg("Error - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMissing file'..
    '/ Отсутствует файл!\n'..P..F..'\n\n')return;end;if not A.VersionArc_Function_lua("2.8.0",P,"")then A.no_undo() return end;local Arc=A;--==
    --==== FUNCTION MODULE FUNCTION ===================================================▲=▲=▲======= FUNCTION MODULE FUNCTION ==================
    
    
    
    local itemSelFirst = reaper.GetSelectedMediaItem(0,0);
    if itemSelFirst then;
    
        local item_loopX = reaper.GetMediaItemInfo_Value(itemSelFirst,"B_LOOPSRC");
        item_loopX = math.abs(item_loopX-1);
        
        for i = 1,reaper.CountSelectedMediaItems(0)do;
            local itemSel = reaper.GetSelectedMediaItem(0,i-1);
            local item_loop = reaper.GetMediaItemInfo_Value(itemSel,"B_LOOPSRC");
            if item_loop ~= item_loopX then;
                reaper.SetMediaItemInfo_Value(itemSel,"B_LOOPSRC",item_loopX);
            end;
        end;
    end;
    ------------------------------------------------------------
    
    
    
    --=========================================
    local ProjState2;
    local function ChangesInProject();
        local ret;
        local ProjState = reaper.GetProjectStateChangeCount(0);
        if not ProjState2 or ProjState2 ~= ProjState then ret = true end;
        ProjState2 = ProjState;
        return ret == true;
    end;
    --=========================================
    
    
    
    
    --=========================================
    local _,NP,sec,cmd,_,_,_ = reaper.get_action_context();
    local extnameProj = NP:match('.+[/\\](.+)');
    local ActiveDoubleScr,stopDoubleScr;
    local Repeat_Off,Repeat_On; 
    
    local function loop();
        ----- stop Double Script -------
        if not ActiveDoubleScr then;
            stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
            ActiveDoubleScr = true;
        end;
        
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
        if stopDoubleScr2 > stopDoubleScr then return end;
        --------------------------------
        
        local ProjtState = ChangesInProject();
        if ProjtState then;
            
            local item_loop;
            local itemSelFirst = reaper.GetSelectedMediaItem(0,0);
            if itemSelFirst then;
                item_loop = reaper.GetMediaItemInfo_Value(itemSelFirst,"B_LOOPSRC");
            end;
            
            if item_loop == 1 and not Repeat_On then;
                if reaper.GetToggleCommandStateEx(sec,cmd)~=1 then;
                    reaper.SetToggleCommandState(sec,cmd,1);
                    reaper.RefreshToolbar2(sec,cmd);
                end;
                Repeat_On = true;
                Repeat_Off = nil;
            elseif item_loop ~= 1 and not Repeat_Off then;
                if reaper.GetToggleCommandStateEx(sec,cmd)~=0 then;
                    reaper.SetToggleCommandState(sec,cmd,0);
                    reaper.RefreshToolbar2(sec,cmd);
                end;
                Repeat_Off = true;
                Repeat_On = nil;
            end;
            --t=(t or 0)+1
        end;
        reaper.defer(loop);
    end;
    reaper.defer(loop);
    --=========================================
    
    local ScrPath,ScrName = NP:match('(.+)[/\\](.+)');
    reaper.defer(function()A.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,ScrPath,ScrName)end);
    
    
    
    
    
    
    
    