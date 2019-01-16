--[[
   * Category:    Item
   * Description: Cut silence by grid from selected items to created track under item
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Cut silence by grid from selected items to created track under item
   * О скрипте:   Вырезать тишину по сетке из выбранных элементов в созданную дорожку под элементом
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Вадим Мошев(RMM)
   * Gave idea:   Вадим Мошев(RMM)
   * Changelog:   +  lock second run / v.1.01 [15.01.2019];

   *              +  initialе / v.1.0 [09.01.2019];
==============================================================================================
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.5 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local Thresh_dB = -80;
                         -- | ПОРОГ НИЖЕ КОТОРОГО БУДЕТ УДАЛЯТЬСЯ ТИШИНА
                         -- | THRESHOLD BELOW WHICH SILENCE WILL BE REMOVED
                         --------------------------------------------------

    local Attack_Rel  = 0;
                         -- | КАК БЫСТРО БУДЕТ СРАБАТЫВАТЬ ПОРОГ; = 0 БЫСТРО, 10 МЕДЛЕННЕЕ И Т.Д.
                         -- | HOW QUICKLY WILL TRIGGER the THRESHOLD; = 0 FAST, 10 SLOWER, Etc.
                         ----------------------------------------------------------------------



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
    Arc.VersionArc_Function_lua("2.1.5",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --####################################################################################################################### 




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;
    ---------------------------------------------------

    if not tonumber(Thresh_dB ) or Thresh_dB  < -150 or Thresh_dB  > 24   then Thresh_dB  = -80 end;
    if not tonumber(Attack_Rel) or Attack_Rel <  0   or Attack_Rel > 1000 then Attack_Rel =   0 end;
    local ValInDB = 10^(Thresh_dB/20);
    ----------------------------------

    local zeroPeak,item_Sp_Left,item_Sp,leftCheck,rightEdge,rightCheck,Numb,Undo;

    for i = CountSelItem-1,0,-1 do;
        local Selitem = reaper.GetSelectedMediaItem(0,i); 
        local Track = reaper.GetMediaItem_Track(Selitem);
        local trNumb = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
        -------------------------------------------
        local take = reaper.GetActiveTake(Selitem);
        local source = reaper.GetMediaItemTake_Source(take);
        local samples_skip = reaper.GetMediaSourceSampleRate(source)/100;-- обработается 100 сэмплов в секунду
        local CountSamples_AllChannels,
              CountSamples_OneChannel,
              NumberSamplesAllChan,
              NumberSamplesOneChan,
              Sample_min,
              Sample_max,
              TimeSample = Arc.GetSampleNumberPosValue(take,samples_skip,true,true,true);
              ---------------------------------------------------------------------------

        for i = #TimeSample,1,-1 do;

            if Sample_max[i] < ValInDB and i ~= 1 then;

                if not PosRight then PosRight = i end;
                zeroPeak = (zeroPeak or 0) + 1;

            elseif Sample_max[i] >= ValInDB or i == 1 then;

                if zeroPeak and zeroPeak >= 5 then;

                    if not TimeSample[PosRight-Attack_Rel] then TimeSample[PosRight-Attack_Rel] = 0   end;
                    if not TimeSample[i + 1 + Attack_Rel ] then TimeSample[i + 1 + Attack_Rel ] = 9^9 end;

                    if PosRight == #TimeSample then rightCheck = PosRight else rightCheck = PosRight-Attack_Rel end;
                    if i == 1 then leftCheck = i else leftCheck = i+1+Attack_Rel end;

                    -- grid -------------------
                    ---------------------------
                    if PosRight ~= #TimeSample then;  
                        TimeSample[rightCheck] = reaper.BR_GetPrevGridDivision(TimeSample[rightCheck]);
                    end;
                    if i ~= 1 then;  
                        TimeSample[leftCheck] = reaper.BR_GetNextGridDivision(TimeSample[leftCheck]);
                    end;
                    ---------------------------
                    ---------------------------

                    if TimeSample[rightCheck] > TimeSample[leftCheck] then;

                        if i == 1 then;
                            item_Sp_Left = Selitem;
                        else;
                            item_Sp_Left = reaper.SplitMediaItem(Selitem,TimeSample[i+1+Attack_Rel]);
                            LockSecondRun = item_Sp_Left; -- v.1.01
                        end;
                        ----

                        if not rightEdge then;
                            item_Sp = reaper.SplitMediaItem(item_Sp_Left,TimeSample[PosRight]);
                        else;
                            item_Sp = reaper.SplitMediaItem(item_Sp_Left,TimeSample[PosRight-Attack_Rel]);
                        end;
                        ---------------------
                        if LockSecondRun then; -- v.1.01
                            if item_Sp_Left then;
                                if trNumb ~= Numb then;
                                    reaper.InsertTrackAtIndex(trNumb,false);
                                    local track = reaper.GetTrack(0,trNumb);
                                    reaper.GetSetMediaTrackInfo_String(track,"P_NAME","Silence",1);
                                end;
                            end;
                            Numb = trNumb;
                            local track = reaper.GetTrack(0,Numb);
                            reaper.MoveMediaItemToTrack(item_Sp_Left,track);
                       
                            if not Undo then;
                                reaper.Undo_BeginBlock();
                                Undo = "Active";
                            end;
                        end -- v.1.01
                        --------------------
                    end;
                end;
                rightEdge = 1;
                PosRight = nil;
                zeroPeak = 0;
            end;
        end;
        LockSecondRun = nil; -- v 1.01
    end;

    if Undo then;
        reaper.Undo_EndBlock("Cut silence by grid from selected items to created track under item",-1);
    else;
        Arc.no_undo();
    end;

    reaper.UpdateArrange();
    
    -- / v.1.01 [15.01.2019] / lock second run (If there is no useful signal in the element, nothing will happen.)
