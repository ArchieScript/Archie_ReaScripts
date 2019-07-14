--[[
   * Category:    Item
   * Description: Switch item source file to next in folder restore original size
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Switch item source file to next in folder restore original size
   * О скрипте:   Переключить исходный файл элемента на следующий в папке восстановить исходный размер
   *              НЕ СПОТЫКАЕТСЯ(ЛОМАЕТСЯ) НА МИДИ ФАЙЛАХ КАК В SWS
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   ---(---)
   * Changelog:   
   *              v.1.03 [14.07.19] 
   *                  Build missing peaks
   
   *              +  Fixed paths for Mac/ v.1.02 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.02 [29.01.19]  
   *              +  initialе / v.1.0 [16.01.2019]
   
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



    local reset_play_rate = 0
                       -- = 0 | СБРОСИТЬ PLAY RATE 
                       -- = 1 | ОСТАВИТЬ ИСХОДНЫМ PLAY RATE
                       ------------------------------------
                       -- = 0 | RESET PLAY RATE 
                       -- = 1 | WRITE THE SOURCE PLAY RATE
                       ------------------------------------


    local Start_in_Sourse = 0
                       -- = 0 | СБРОСИТЬ START IN SOURSE
                       -- = 1 | ОСТАВИТЬ ИСХОДНЫМ START IN SOURSE
                       ------------------------------------------
                       -- = 0 | RESET START IN SOURCE
                       -- = 1 | WRITE THE SOURCE START IN SOURCE
                       -----------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================





    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;


    local Audio = "WAVE";
    local Video = "VIDEO";
    local Countfile,Activ,Undo,Stop;

    for i2 = 1, Count_sel_item do;

        local item = reaper.GetSelectedMediaItem(0,i2-1);
        local take = reaper.GetActiveTake(item);
        local Midi_take = reaper.TakeIsMIDI(take);
        if not Midi_take then;
            local Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
            if Path and Name then;
                local PCM_Source = reaper.PCM_Source_CreateFromFile(Path.."/"..Name);
                local WavMidVideo = reaper.GetMediaSourceType(PCM_Source,"");
                if WavMidVideo == Audio or WavMidVideo == Video then;

                    ---- Number of Files in directory ---------------
                    for i = 1, math.huge do;
                        local file = reaper.EnumerateFiles(Path,i-1);
                        if file then Countfile = i else break end;
                    end;
                    if not Countfile then Countfile = 0 end;
                    ----------------------------------------

                    if Countfile > 0 then;
                        ---- Replace source file --------
                        local i = 1;
                        repeat;

                            local File = reaper.EnumerateFiles(Path,i-1);

                            if Activ == "Active" then;
                                if not File then File = reaper.EnumerateFiles(Path,0);
                                    if not Stop then i = 1; end;
                                end;
                                if File then;
                                    Name = File;
                                end;
                                local ExpansionFile = string.match(Name:reverse(),".-%.");
                                if ExpansionFile then;
                                    local PCM_Source = reaper.PCM_Source_CreateFromFile(Path.."/"..Name);
                                    local WavMidVideo = reaper.GetMediaSourceType(PCM_Source,"");
                                    if WavMidVideo == Audio or WavMidVideo == Video then;
                                        local Channels = reaper.GetMediaSourceNumChannels(PCM_Source);
                                        if Channels > 0 then;
                                            reaper.BR_SetTakeSourceFromFile(take, Path.."/"..Name ,true);
                                            reaper.GetSetMediaItemTakeInfo_String(take,"P_NAME",Name,1);
                                            local retval, lengthIsQN = reaper.GetMediaSourceLength(PCM_Source);
                                            reaper.SetMediaItemLength(item,retval,true);
                                            ----
                                             if not Undo then reaper.Undo_BeginBlock();Undo = "Active";end;
                                            ----
                                            break;
                                        end;
                                    end;
                                end;
                            end;

                            if File == Name then;
                                Activ = "Active";
                            end;

                            if not Stop then;
                                if i > Countfile and not Activ then Activ = "Active"; i = 0; Stop = "Active" end;
                            elseif i > Countfile and Stop then;
                                Activ = nil;
                            end;

                        i = i + 1;
                        until i > (Countfile+5);
                        reaper.ClearPeakCache();
                        ------------------------
                    end;
                    -------------
                    if Undo == "Active" then;
                        ---- Start_in_Sourse --------
                        if Start_in_Sourse == 0 then;
                            reaper.SetMediaItemTakeInfo_Value(take,"D_STARTOFFS",0);
                        end;
                        ---- reset_play_rate --------
                        if reset_play_rate == 0 then;
                            reaper.SetMediaItemTakeInfo_Value(take,'D_PLAYRATE',1);
                        end;
                    end;
                    --------
                end;
            end;
        end;
        Activ = nil;
        Stop = nil;
        Name = nil;
    end;

    if Undo == "Active" then;
        reaper.Undo_EndBlock("Switch item source file to next in folder restore original size",-1);
    else;
        Arc.no_undo();
    end;
    ----
	    Arc.Action(40047);--Build missing peaks
    reaper.UpdateArrange();
