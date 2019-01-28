--[[
   * Category:    View
   * Description: Auto enable spectral peaks on selected tracks
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Auto enable spectral peaks on selected tracks
   * О скрипте:   Автоматическое включение спектральных пиков на выбранных дорожках
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(RMM Forum)
   * Gave idea:   smrz1(RMM Forum)
   * Changelog:   + Fixed working with child tracks / v.1.03 [28.01.2019]
   *              + Fixed bug when scanning peak cache files / v.1.03 [28.01.2019]
   *              + Исправлена работа с дочерними треками / v.1.03 [28.01.2019]
   *              + Исправлена ошибка при сканировании пиковых файлов кэша / v.1.03 [28.01.2019]

   *              + initialе / v.1.0
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.1 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   + reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   ? Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.1",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================



    if not reaper.JS_Mouse_GetState then reaper.MB(
    'There is no file "reaper_js_ReaScriptAPI.dll" \nInstall repository "ReaTeam Extensions"\n\n'..
    'Отсутствует файл "reaper_js_ReaScriptAPI.dll" \nУстановите репозиторий "ReaTeam Extensions"'
    ,"Error",0) return end;
    -----------------------

    local RemovePeak = 40097;
    local SpectrPeak = 42073;
    local RebuilPeak = 40048;


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;


    if reaper.JS_Mouse_GetState(12) == 12 then; -- Ctrl + Shift
        if reaper.GetToggleCommandState(SpectrPeak) == 1 then Arc.Action(SpectrPeak)end;
        reaper.DeleteExtState("Auto_SelTrSpectPeak39674867","Auto_key_SpectPeak39674867",false);
        Arc.Action(RebuilPeak);
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
        end;
        Arc.no_undo() return;
    else;
        local Clock = math.ceil(os.clock());
        local ClockES = reaper.HasExtState("Auto_OsCclockHelpSpect","Auto_HelpSpect");
        if ClockES then;
            ClockES = reaper.GetExtState("Auto_OsCclockHelpSpect","Auto_HelpSpect");
            if Clock > ClockES+20 then;
                reaper.DeleteExtState("Auto_OsCclockHelpSpect","Auto_HelpSpect",false);
            end;
        end;
        if not ClockES then;
            Arc.HelpWindowWhenReRunning(1,1689458,false);
            local HelpWindow = Arc.HelpWindow_WithOptionNotToShow(
                               "Rus:\n"..
                               "    Запустите скрипт сочетанием клавиш Ctrl + Shift + Click чтобы\n"..
                               "    Сбросить все пиковые файлы кэша\n"..
                               "    Сбросить Предотвращение всех спектральных пиков\n"..
                               "    Выключить спектральные пики\n"..
                               "-----------------------------------------------"..
                               "---------------------------------------------\n"..
                               "Eng:\n"..
                               "    Run the script with Ctrl + Shift + Click to\n"..
                               "    Reset all peak cache files\n"..
                               "    Reset Prevention of all spectral peaks\n"..
                               "    Turn off spectral peaks\n","Help.",469812,false);--reset
            if HelpWindow > -1 then;
                reaper.SetExtState("Auto_OsCclockHelpSpect","Auto_HelpSpect",Clock,false);
            end;
        end;
    end;


    local Spectral = reaper.GetToggleCommandState(SpectrPeak);
    if Spectral == 0 then;
        reaper.DeleteExtState("Auto_SelTrSpectPeak39674867","Auto_key_SpectPeak39674867",false);
    end;

    local Peak = reaper.HasExtState("Auto_SelTrSpectPeak39674867","Auto_key_SpectPeak39674867");
    if not Peak then;
        reaper.PreventUIRefresh(1);
        if Spectral == 0 then Arc.Action(SpectrPeak) end;
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
        end;
        Arc.Action(RemovePeak,RebuilPeak);
        reaper.SetExtState("Auto_SelTrSpectPeak39674867","Auto_key_SpectPeak39674867",1,false);
        local WindHWND = reaper.JS_Window_Find("Building Peaks",false);
        if WindHWND then;
            local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,0);
            local scr_x = scr_x/2-183;
            local scr_y = scr_y/2+70;
            reaper.JS_Window_SetPosition(WindHWND,scr_x,scr_y,372,95);
            reaper.JS_Window_SetTitle(WindHWND,"Archie: Building Peaks");
            reaper.JS_Window_Enable(WindHWND,false);
        end;
    end;


    local WindHWND = reaper.JS_Window_Find("Building Peaks",false);
    if WindHWND then;
        local Mb = reaper.MB("Rus.\n    Дождитесь окончание перестройки всех пиков,\n    Затем  нажмите ОК \n"..
                       "Eng.\n    Wait for the completion of the restructuring of all the peaks,\n"..
                             "    and then click OK","Archie_: Building Peaks",0);
        if Mb then dofile(select(2,reaper.get_action_context())) return end;
    end;
    ----


    local function Run()
        reaper.PreventUIRefresh(1);
        local Depth,Child;
        for i = CountTrack-1,0,-1 do;
            local Track = reaper.GetTrack(0,i);
            local sel = reaper.IsTrackSelected(Track);
            if Child then;
                local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if fold == 1 then;
                    Depth = reaper.GetTrackDepth(Track);
                    if Depth == 0 then;
                        sel = true;
                        Child = nil;
                    end;
                end;
            end;
            if sel == true then;
                Depth = reaper.GetTrackDepth(Track);
                if Depth > 0 then;
                    Child = true;
                end;
                Arc.SetPreventSpectralPeaksInTrack(Track,false);
            else;
                Arc.SetPreventSpectralPeaksInTrack(Track,true);
            end;
        end;
        reaper.PreventUIRefresh(-1);
    end;


    local function loop();

        local Spectral = reaper.GetToggleCommandState(42073);
        if Spectral == 0 then Arc.no_undo() return end;
        
        local ProjectChange_1 =  reaper.GetProjectStateChangeCount(0);
        if ProjectChange_1 ~= ProjectChange_2 then;
            local sel1,sel2,ProjectChange_2 = "";
            if not sel2 then sel2 = "" end;

            local CountTrack = reaper.CountTracks(0);
            if CountTrack == 0 then Arc.no_undo() return end;
            for i = 1,CountTrack do;
                local Track = reaper.GetTrack(0,i-1);
                local sel = reaper.IsTrackSelected(Track);
                sel1 = sel1..tostring(sel);
            end;
            if sel1 ~= sel2 then;
                Run();
            end;
            sel2 = sel1; 
        ProjectChange_2 = ProjectChange_1;
        end;

        reaper.defer(loop);
    end;


    local function Exit();
        reaper.DeleteExtState("Auto_SelTrSpectPeak39674867","Auto_key_SpectPeak39674867",false);
        if reaper.GetToggleCommandState(SpectrPeak) == 1 then Arc.Action(SpectrPeak)end;
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
        end;
        Arc.SetToggleButtonOnOff(0);
    end;

    reaper.DeleteExtState("Auto_OsCclockHelpSpect","Auto_HelpSpect",false);
    Arc.SetToggleButtonOnOff(1);
    loop();
    reaper.atexit(Exit);