--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Switch item source file to next in folder
   * Author:      Archie
   * Version:     1.03
   * Описание:    Переключить исходный файл элемента на следующий в папке
   *              НЕ СПОТЫКАЕТСЯ(ЛОМАЕТСЯ) НА МИДИ ФАЙЛАХ КАК В SWS
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              Arc_Function_lua v.2.4.8+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Provides:    
   *              [main] . > Archie_Item;  Switch item source file to next in folder.lua
   *              [main] . > Archie_Item;  Switch item source file to next in folder(only RPP).lua  
   *              [main] . > Archie_Item;  Switch item source file to next in folder(only Audio).lua
   *              [main] . > Archie_Item;  Switch item source file to next in folder(only Video).lua
   *              [main] . > Archie_Item;  Switch item source file to next in folder restore original size.lua
   *              [main] . > Archie_Item;  Switch item source file to next in folder restore original size(only RPP).lua 
   *              [main] . > Archie_Item;  Switch item source file to next in folder restore original size(only Audio).lua
   *              [main] . > Archie_Item;  Switch item source file to next in folder restore original size(only Video).lua
   * Changelog:   
   *              v.1.03 [200320]
   *                  +RPP(.rpp-PROX)
   
   *              v.1.02 [08.02.20] 
   *                  + no change
   *              v.1.01 [19.07.19] 
   *                  + "WAVPACK"(.wv)
   *              v.1.0 [19.07.19] 
   *                  initial
--]]
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
    
    
    local ReversTake = 0;
                  -- = 0 | СБРОСИТЬ РЕВЕРС
                  -- = 1 | ОСТАВИТЬ РАЗВЕРНУТЫМ
                  -----------------------------
                  -- = 0 | RESET REVERSE
                  -- = 1 | LEAVE REVERSE
                  ----------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.8",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    
    ---------------
    local
    ScrNameT = {
                "Archie_Item;  Switch item source file to next in folder.lua",
                "Archie_Item;  Switch item source file to next in folder(only RPP).lua",
                "Archie_Item;  Switch item source file to next in folder(only Audio).lua",
                "Archie_Item;  Switch item source file to next in folder(only Video).lua",
                "Archie_Item;  Switch item source file to next in folder restore original size.lua",
                "Archie_Item;  Switch item source file to next in folder restore original size(only RPP).lua",
                "Archie_Item;  Switch item source file to next in folder restore original size(only Audio).lua",
                "Archie_Item;  Switch item source file to next in folder restore original size(only Video).lua"
               };
    --local ScrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    local ScrName = debug.getinfo(1,'S').source:match(".+[/\\](.+)");
    
    local ScrNameUndo = ScrName:match("Archie.-%s%s*(.+)%.lua$");
    
    
    
    local AUDIO = {"WAVE","MP3","WAVPACK","OPUS","VORBIS","FLAC","DDP"};
    local VIDEO = {"VIDEO"};
    local RPP = {"RPP_PROJECT"};
    local ORIGINAL_SIZE;
    
    
    if ScrName == ScrNameT[2] then;--RPP
        VIDEO = nil;
        AUDIO = nil;
    elseif ScrName == ScrNameT[3] then;--AUDIO
        VIDEO = nil;
        RPP = nil;
    elseif ScrName == ScrNameT[4] then;--VIDEO
        AUDIO = nil;
        RPP = nil;
    elseif ScrName == ScrNameT[5] then;--(original size) 
        ORIGINAL_SIZE = true;
    elseif ScrName == ScrNameT[6] then;--RPP(original size) 
        VIDEO = nil;
        AUDIO = nil;
        ORIGINAL_SIZE = true;
    elseif ScrName == ScrNameT[7] then;--AUDIO(original size)
        VIDEO = nil;
        RPP = nil;
        ORIGINAL_SIZE = true;
    elseif ScrName == ScrNameT[8] then;--VIDEO(original size)
        AUDIO = nil;
        RPP = nil;
        ORIGINAL_SIZE = true;
    elseif ScrName ~= ScrNameT[1] then;
        reaper.MB("Rus:\nНеверное имя скрипта!\nИмя скрипта должно быть одно из следующих в зависимости от задачи:\n\n"..
                  "Eng:\nInvalid script name!\nThe script name must be one of the following depending on the task:\n\n\n\n"..
                  table.concat(ScrNameT,"\n\n")
                  ,"Error",0);
        Arc.no_undo() return;
    end;
    ---------------
    
    
    local t = {};
    ----------------------------------------------
    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;
    
    
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
                if Arc.If_Equals_OrEx(WavMidVideo, AUDIO, VIDEO, RPP)then;----
                    
                    if ReversTake == 1 then;
                        t.ret,_,t.startProp,t.lenProp,t.fadeProp,t.reverse = reaper.BR_GetMediaSourceProperties(take);
                    end;
                    
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
                                
                                ---
                                if Name:upper():match('%.RPP[^%.]*$')then;
                                    if File:upper():match('%.RPP.+$')then;
                                        if Name:upper():match('^(.+)%.[^.]*$')==
                                           File:upper():match('^(.+)%.[^.]*$')then;
                                           File='';
                                        end;
                                    end;
                                end;
                                ---
                                
                                local ExpansionFile = string.match(File:reverse(),".-%.");
                                if ExpansionFile then;
                                    local PCM_Source = reaper.PCM_Source_CreateFromFile(Path.."/"..File);
                                    local WavMidVideo = reaper.GetMediaSourceType(PCM_Source,"");
                                    if Arc.If_Equals_OrEx(WavMidVideo, AUDIO, VIDEO, RPP)then;----
                                    
                                        local Channels = reaper.GetMediaSourceNumChannels(PCM_Source);
                                        if Channels > 0 then;
                                            reaper.BR_SetTakeSourceFromFile(take, Path.."/"..File ,true);
                                            ---
                                            if File:upper():match('%.RPP[^.]*$')then;
                                                newName = File:gsub('%.[^.]*$','.rpp');
                                            else;
                                                newName = File;
                                            end;
                                            ---
                                            reaper.GetSetMediaItemTakeInfo_String(take,"P_NAME",newName,1);
                                            ----
                                            if ORIGINAL_SIZE then;
                                                local retval, lengthIsQN = reaper.GetMediaSourceLength(PCM_Source);
                                                reaper.SetMediaItemLength(item,retval,true);
                                            end;
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
                        ---- ReversTake -------------
                        if ReversTake == 1 then;
                            reaper.BR_SetMediaSourceProperties(take,false,t.startProp,t.lenProp,t.fadeProp,t.reverse);
                        end;
                        ---
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
        reaper.Undo_EndBlock(ScrNameUndo,-1);
    else;
        Arc.no_undo();
    end;
    ----
    --------------------------------------------------
    local ShowStatusWindow = reaper.SNM_GetIntConfigVar("showpeaksbuild",0);
    if ShowStatusWindow == 1 then;
        reaper.SNM_SetIntConfigVar("showpeaksbuild",0);
    end;
    ---
    Arc.Action(40047);--Build missing peaks
    ---
    if ShowStatusWindow == 1 then;
        reaper.SNM_SetIntConfigVar("showpeaksbuild",1);
    end;
    --------------------------------------------------
    reaper.UpdateArrange();