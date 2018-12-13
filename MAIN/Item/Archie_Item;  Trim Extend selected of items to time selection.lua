--[[
   * Category:    Item
   * Description: Trim Extend selected of items to time selection
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Trim Extend selected of items to time selection
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Обрезать, Удленить выбранные элементы по времени
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Iskander M(Rmm/forum) 
   * Changelog:   + initialе / v.1.0[14122018]
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.0.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================  
  
  
  
  
    local Only_Items_In_Time_Selection = 0
                                    -- = 0 | ОБРЕЗКА РАСПРОСТРАНЯЕТСЯ ТОЛЬКО НА ТЕ
                                    --     | ЭЛЕМЕНТЫ, КОТОРЫЕ НАХОДЯТСЯ В ВЫБОРЕ ВРЕМЕНИ 
                                    -- = 1 | ОБРЕЗКА РАСПРОСТРАНЯЕТСЯ  НА ВСЕ ЭЛЕМЕНТЫ 
                                             ----------------------------------------- 
                                    -- = 0 | TRIM EXTENDS ONLY THOSE ITEMS WHICH 
                                    --     | ARE IN TIME SELECTION          
                                    -- = 1 | TRIM APPLIES TO ALL ITEMS
                                    --================================



    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================




    --Mod ##########  Mod  ##########  Mod  ########  Mod  ##########  Mod  ##########  Mod  ##########  Mod  ################
    local function GetSubdirectoriesUpToLevelFive(Path);----------------------------------------------------------------------#
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge;--------------------------------------------------#
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;-------------------------------------------------------------#
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;-----------------------------------------------#
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;--------------------------------#
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;---------------#
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;--#
              ---------------------------------------------------------#------------------------------------------------------------#
              end;if not f5 then break end;end;---- #######----#######--------#####------##-----##----##----########------##--------#
            end;if not f4 then break end;end;----- ########----########------#######-----##-----##----##----########------##--------#
          end;if not f3 then break end;end;-------##-----##----##-----##----##-----##----##-----##----------##------------##--------#
        end;if not f2 then break end;end;---------##-----##----##-----##----##-----------#########----##----########------##--------#
      end;if not f1 then return T end;end;--------#########----########-----##-----------#########----##----########------##--------#
    end;------------------------------------------#########----#######------##-----##----##-----##----##----##----------------------#
    ----------------------------------------------##-----##----##----##------#######-----##-----##----##----########------##--------#
    local function GetModule(Path,file);----------##-----##----##-----##------#####------##-----##----##----########------##--------#
    local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);-------------------------------------------------------------------#
    FolPath[-1]=Path..'/Scripts/Archie-ReaScripts/Functions';FolPath[0]=select(2,reaper.get_action_context()):match("(.+)[\\]");----#
    for i=-1,#FolPath do;for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);-----------------------------------#
    if f == file then mod=true Way=FolPath[i]break end;if not f then break end;end; if mod then return mod,Way end;end;end;---------#
    --------------------------------------------------------------------------------------------------------------------------------#
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath():gsub('%\\','/'),"Arc_Function_lua.lua")---------------------#
    if not found_mod then reaper.ClearConsole()reaper.ShowConsoleMsg('Missing file "Arc_Function_lua",\nDownload from'..-----------#
    'repository Archie-ReaScript and put in resources of Reaper.\nОтсутствует файл "Arc_Function_lua",\nСкачайте из '..-----------#
    'репозитория Archie-ReaScript и поместите в ресурсы Reaper') return end------------------------------------------------------#
    package.path = package.path..";"..ScriptPath.."/?.lua"----------------------------------------------------------------------#
    Arc = require "Arc_Function_lua"-------------------------------------------------------------------------------------------#
    Arc.VersionArc_Function_lua("2.0.6",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --#######################################################################################################################




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;


    local startTime,endTime = reaper.GetSet_LoopTimeRange(0,0,0,0,0);

    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();

    for i = 1,CountSelItem do;
        local sel_item = reaper.GetSelectedMediaItem(0,i-1);
        local item_pos = Arc.GetMediaItemInfo_Value(sel_item,"D_POSITION");
        -- local item_len = Arc.GetMediaItemInfo_Value(sel_item,"D_LENGTH");
        local item_end = Arc.GetMediaItemInfo_Value(sel_item,"D_END");

        if Only_Items_In_Time_Selection == 0 then;

            if item_end > startTime and item_pos < endTime then;
                if item_end <= endTime then;
                    reaper.SetMediaItemLength(sel_item,endTime-item_pos,true);
                    Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                else;   
                    Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                    reaper.SetMediaItemLength(sel_item,endTime-startTime,true);
                end;
            end;

        elseif Only_Items_In_Time_Selection == 1 then;

            if item_end <= endTime then;
                reaper.SetMediaItemLength(sel_item,endTime-item_pos,true);
                Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
            else;
                Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                reaper.SetMediaItemLength(sel_item,endTime-startTime,true);
            end;
        end; 
    end;

    reaper.Undo_EndBlock("Trim Extend selected of items to time selection",-1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()