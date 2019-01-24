--[[
   * Category:    Item
   * Description: Delete selected items (time selection)
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Delete selected items (time selection)
   * О скрипте:   Удалить выбранные элементы (выбор времени)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    HDVulcan(RMM)
   * Gave idea:   HDVulcan(RMM)
   * Changelog:   +  initialе / v.1.0 [20.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.8 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Selection = 0
                 -- = 0 | ЛЕВАЯ И ПРАВАЯ ЧАСТИ РАЗРЕЗАННОГО АЙТЕМА ОСТАЮТСЯ ВЫДЕЛЕННЫМИ.
                 -- = 1 | С ЛЕВОЙ И ПРАВОЙ ЧАСТИ РАЗРЕЗАННОГО АЙТЕМА СНИМАЕТСЯ ВЫДЕЛЕНИЕ.
                 -- = 2 | С ЛЕВОЙ ЧАСТИ РАЗРЕЗАННОГО АЙТЕМА СНИМАЕТСЯ ВЫДЕЛЕНИЕ, А С ПРАВОЙ ОСТАЕТСЯ ВЫДЕЛЕНИЕ 
                 -- = 3 | С ПРАВОЙ ЧАСТИ РАЗРЕЗАННОГО АЙТЕМА СНИМАЕТСЯ ВЫДЕЛЕНИЕ, А С ЛЕВОЙ ОСТАЕТСЯ ВЫДЕЛЕНИЕ 
                          ------------------------------------------------------------------------------------
                 -- = 0 | LEFT AND RIGHT PART OF THE CUT ITEM ARE SELECTED.
                 -- = 1 | LEFT AND RIGHT PART OF THE CUT ITEM RELEASE.
                 -- = 2 | LEFT-HAND PART OF THE CUT ITEM DESELECTED, AND THE RIGHT REMAINS THE ALLOCATION OF 
                 -- = 3 | RIGHT PART OF THE CUT ITEM DESELECTED, AND THE LEFT REMAINS THE ALLOCATION OF 
                 --------------------------------------------------------------------------------------



    local fade_in = -1
               -- = -1 | FADE IN УСТАНАВЛИВАЕТСЯ В ЗАВИСИМОСТИ ОТ НАСТРОЕК REAPER, ИНАЧЕ В СЕКУНДАХ.
               --         = 0 FADE IN ОТСУТСТВУЕТ, = 0.5 ПОЛСЕКУНДЫ, = 1 ОДНА СЕКУНДА И Т.Д.
                          ------------------------------------------------------------------
              -- =  -1 | FADE IN IS SET DEPENDING ON THE SETTINGS REAPER OTHERWISE IN SECONDS.
              --         = 0 FADE IN ABSENTS, = 0.5 HALF A SECOND = 1 ONE SECOND, ETC.
              ------------------------------------------------------------------------

    local fade_out =  -1
                -- = -1 | FADE OUT УСТАНАВЛИВАЕТСЯ В ЗАВИСИМОСТИ ОТ НАСТРОЕК REAPER, ИНАЧЕ В СЕКУНДАХ.
                --        = 0 FADE OUT ОТСУТСТВУЕТ, = 0.5 ПОЛСЕКУНДЫ, = 1 ОДНА СЕКУНДА И Т.Д.
                          -------------------------------------------------------------------
                -- = -1 | FADE OUT IS SET DEPENDING ON THE SETTINGS REAPER OTHERWISE IN SECONDS.
                --        = 0 FADE OUT ABSENTS, = 0.5 HALF A SECOND = 1 ONE SECOND, ETC.
                 -----------------------------------------------------------------------



    local TimeSelection = 0  
                     -- = 0 | НЕ УБИРАТЬ ВЫБОР ВРЕМЕНИ
                     -- = 1 | УБРАТЬ ВЫБОР ВРЕМЕНИ
                            ----------------------
                     -- = 0 | DO NOT REMOVE TIME SELECTION
                     -- = 1 | REMOVE TIME SELECTION
                     ------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;


    local Loopstart,LoopEnd,Active = reaper.GetSet_LoopTimeRange(0,0,0,0,0);

    
    if Loopstart ~= LoopEnd then;
    
        for i = 1, CountSelItem do;
            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
            local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
            if PosIt < LoopEnd and EndIt > Loopstart then;
                Active = "Active" break;
            end
        end
        if not Active then Arc.no_undo() return end;
    
        reaper.Undo_BeginBlock();
    
        for i = CountSelItem-1,0,-1 do;
            local SelItem = reaper.GetSelectedMediaItem(0,i);
            local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
            if PosIt < LoopEnd and EndIt > Loopstart then;
    
                local Right = reaper.SplitMediaItem(SelItem,LoopEnd);
                if Right then;
                    if Selection == 1 or Selection == 3 then;
                        Arc.SetMediaItemInfo_Value(Right,"B_UISEL",0);
                    end
                    if fade_in >= 0 then;
                        Arc.SetMediaItemInfo_Value(Right,"D_FADEINLEN",fade_in);
                    end
                end
    
                local Left = reaper.SplitMediaItem(SelItem,Loopstart);
                if Left then;
                    if Selection == 1 or Selection == 2 then;
                        Arc.SetMediaItemInfo_Value(SelItem,"B_UISEL",0);
                    end
                    if fade_out >= 0 then;
                        Arc.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);
                    end
                    Arc.DeleteMediaItem(Left);
                else;
                    Arc.DeleteMediaItem(SelItem);
                end; 
            end;  
        end;
    else;
        reaper.Undo_BeginBlock();
        for i = CountSelItem-1,0,-1 do;
            local SelItem = reaper.GetSelectedMediaItem(0,i);
            Arc.DeleteMediaItem(SelItem);
        end;
    end;

    if TimeSelection == 1 then;
        reaper.GetSet_LoopTimeRange(1,0,0,0,0);
    end;
    reaper.Undo_EndBlock("Delete selected items (time selection)",-1);
    reaper.UpdateArrange();