--[[
   * Category:    Item
   * Description: Remove silence in selected media items (-60 db)
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Remove silence in selected media items (-60 db)
   * О скрипте:   Удалить тишину в выбранных элементах мультимедиа (-60 дБ)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    --- (---)
   * Gave idea:   --- (---)
   * Changelog:   +  Fixed paths for Mac/ v.1.01 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.01 [29.01.19]  
   *              
   *              +  initialе / v.1.0 [10.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Thresh_dB = -60;
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




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.8.5",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;
    ---------------------------------------------------

    if not tonumber(Thresh_dB ) or Thresh_dB  < -150 or Thresh_dB  > 24   then Thresh_dB  = -80 end;
    if not tonumber(Attack_Rel) or Attack_Rel <  0   or Attack_Rel > 1000 then Attack_Rel =   0 end;
    local ValInDB = 10^(Thresh_dB/20);
    ----------------------------------

    local zeroPeak,item_Sp_Left,item_Sp,leftCheck,rightEdge,rightCheck,Undo;

    for i = CountSelItem-1,0,-1 do;
        local Selitem = reaper.GetSelectedMediaItem(0,i); 
        local Track = reaper.GetMediaItem_Track(Selitem);
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

                    if TimeSample[rightCheck] > TimeSample[leftCheck] then;

                        if i == 1 then;
                            item_Sp_Left = Selitem;
                        else;
                            item_Sp_Left = reaper.SplitMediaItem(Selitem,TimeSample[i+1+Attack_Rel]);
                        end;
                        ----

                        if not rightEdge then;
                            item_Sp = reaper.SplitMediaItem(item_Sp_Left,TimeSample[PosRight]);
                        else;
                            item_Sp = reaper.SplitMediaItem(item_Sp_Left,TimeSample[PosRight-Attack_Rel]);
                        end;
                        ----
                        ----------------------------------
                        Arc.DeleteMediaItem(item_Sp_Left);

                        if not Undo then;
                            reaper.Undo_BeginBlock();
                            Undo = "Active";
                        end;
                        --------------------
                    end;
                end;
                rightEdge = 1;
                PosRight = nil;
                zeroPeak = 0;
            end;
        end;
    end;

    if Undo then;
        reaper.Undo_EndBlock("Remove silence in selected media items (-60 db)",-1);
    else;
        Arc.no_undo();
    end;

    reaper.UpdateArrange();