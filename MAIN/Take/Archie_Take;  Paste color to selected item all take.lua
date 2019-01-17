--[[
   * Category:    Take
   * Description: Paste color to selected item all take
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Paste color to selected item all take
   * О скрипте:   Вставить цвет в выбранные элементы во все тейки
				  скопировать с помощью:          
									    Copy color item active take
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Changelog:   +  initialе / v.1.0 [17.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.7 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local reset = 0 
             -- = 0 | НЕ СБРАСЫВАТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ
             -- = 1 | СБРОСИТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ
                


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --Mod ##########  Mod  ##########  Mod  ########  Mod  ##########  Mod  ##########  Mod  ##########  Mod  ################
    local function GetSubdirectoriesUpToLevelFive(Path);----------------------------------------------------------------------#
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge;--------------------------------------------------#
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;-------------------------------------------------------------#
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;-----------------------------------------------#
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;--------------------------------#
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;---------------#
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;--#
              -----------------------------------------------------------------------------------------------------------------------#
              end;if not f5 then break end;end;-- #########  ##     ##  ## ####      #####     ##       ##    #####    # #####    ## #
            end;if not f4 then break end;end;--- #########  ##     ##  ########    #######    ##       ##   ##   ##   ########   ##  #
          end;if not f3 then break end;end;---- ##         ##     ##  ##     ##  ##     ##   ##           ##     ##  ##     ##  ##   #
        end;if not f2 then break end;end;----- ##         ##     ##  ##     ##  ##         #####     ##  ##     ##  ##     ##  ##    #
      end;if not f1 then return T end;end;--- #########  ##     ##  ##     ##  ##          ##       ##  ##     ##  ##     ##  ##     #
    end;------------------------------------ #########  ##     ##  ##     ##  ##     ##   ##   ##  ##  ##     ##  ##     ##          #
    --------------------------------------- ##          #######   ##     ##   #######     #####   ##   ##   ##   ##     ##  ##       #
    local function GetModule(Path,file);-- ##           #####    ##     ##    #####       ###    ##    #####    ##     ##  ##        #
    local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);--------------------------------------------------------------------#
    FolPath[-1]=Path..'/Scripts/Archie-ReaScripts/Functions';FolPath[0]=select(2,reaper.get_action_context()):match("(.+)[\\]");-----#
    for i=-1,#FolPath do;for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);------------------------------------#
    if f == file then mod=true Way=FolPath[i]break end;if not f then break end;end; if mod then return mod,Way end;end;end;----------#
    ---------------------------------------------------------------------------------------------------------------------------------#
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath():gsub('%\\','/'),"Arc_Function_lua.lua")---------------------#
    if not found_mod then reaper.ClearConsole()reaper.ShowConsoleMsg('Missing file "Arc_Function_lua",\nDownload from'..-----------#
    'repository Archie-ReaScript and put in resources of Reaper.\nОтсутствует файл "Arc_Function_lua",\nСкачайте из '..-----------#
    'репозитория Archie-ReaScript и поместите в ресурсы Reaper') return end------------------------------------------------------#
    package.path = package.path..";"..ScriptPath.."/?.lua"----------------------------------------------------------------------#
    Arc = require "Arc_Function_lua"-------------------------------------------------------------------------------------------#
    Arc.VersionArc_Function_lua("2.1.7",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --####################################################################################################################### 





    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;
    
    
    local HasExtState = reaper.HasExtState("{section_Arc¶Copy¶Color¶Take_ѨڢᴂX}","{key_Arc¶Copy¶Color¶Take_ѨڢᴂX}");
    if not HasExtState then Arc.no_undo() return end;

    reaper.Undo_BeginBlock();

    local Col = reaper.GetExtState("{section_Arc¶Copy¶Color¶Take_ѨڢᴂX}","{key_Arc¶Copy¶Color¶Take_ѨڢᴂX}");
    for i = 1, Count_sel_item do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        Arc.SetMediaItemInfo_Value(SelItem,"I_CUSTOMCOLOR",0);
        local CountTake = reaper.CountTakes(SelItem);
        for i2 = 1, CountTake do;
            local Take = reaper.GetMediaItemTake(SelItem,i2-1);
            reaper.SetMediaItemTakeInfo_Value(Take,"I_CUSTOMCOLOR",Col);
        end
    end;
    if reset ~= 0 then;
        reaper.DeleteExtState("{section_Arc¶Copy¶Color¶Take_ѨڢᴂX}","{key_Arc¶Copy¶Color¶Take_ѨڢᴂX}",false);
    end;
    reaper.Undo_EndBlock('Paste color to selected item all take',-1);
    reaper.UpdateArrange();
 
    
