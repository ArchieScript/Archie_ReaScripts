--[[
   * Category:    FX
   * Description: Smart template - Add Fx by name to selected tracks + Master track
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Smart template - Add Fx by name to selected tracks + Master track
   * О скрипте:   Умный шаблон - Добавить Fx по имени в выбранные треки + Мастер трек
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(Rmm/forum)
   * Gave idea:   Maestro Sound(Rmm/forum)
   * Changelog:
   *              +  initialе / v.1.0 [31032019]



   -- Тест только на windows  /  Test only on windows.
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               ||
      -------------------------------------------------------------------------------------||
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    ||
   (?) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               ||
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             ||
   (+) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc ||
   (+) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr ||
                                                                    http://clck.ru/Eo5Lw   ||
   (?) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                ||
      -------------------------------------------------------------------------------------||
    ˄ - (+) - required for installation / (-) - not necessary for installation             ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	




    ::StopWrite_0::--<<
    local function S(x)return string.rep(" ",x)end;
    local function Rep(val,num) return string.rep(val,num)end;
    local sectionExtState = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");



    local function Size_Pos_Window(left,top,width,height);
        local rename
        if Arc.js_ReaScriptAPI(false) then;
            reaper.ShowConsoleMsg(" ")reaper.ShowConsoleMsg("");
            local winHWND = reaper.JS_Window_Find("ReaScript console output",true);
            if not winHWND then;
                winHWND = reaper.JS_Window_Find("Archie. Help!",true);
                rename = true
            end;
            if winHWND then;
                reaper.JS_Window_SetPosition(winHWND,left,top,width,height);
                reaper.JS_Window_SetForeground(winHWND);
                if not rename then;
                    reaper.JS_Window_SetTitle(winHWND,"Archie. Help!");
                end;
            end;
        end;
    end;



    local function Window_Destroy();
        if Arc.js_ReaScriptAPI(false) then;
            local winHWND = reaper.JS_Window_Find("ReaScript console output",true);
            if not winHWND then;
                winHWND = reaper.JS_Window_Find("Archie. Help!",true);
            end;
            if winHWND then reaper.JS_Window_Destroy(winHWND)end;
        end;
    end;



    local prefRus =
       S(6)..'Префикс, обозначающий тип "VST3:,VST2:,VST:,AU:,JS:, или DX:." с имени нужно удалить.\n'..
       S(6)..'Пример:"VST: ReaEQ (Cockos)"- неправильно, "ReaEQ (Cockos)"- правильно.'
    local prefEng =
       S(6)..'the prefix denoting the type with the name should be removed "VST3:,VST2:,VST:,AU:, JS:, or DX:.".\n'..
       S(6)..'Example: "VST: ReaEQ (Cockos)"- is incorrect, "ReaEQ (Cockos)"- is correct.'
       -----------------------------------------------------------------------------



    ::X1::
    ---MASTER TRACK-------
    reaper.ClearConsole();
    Size_Pos_Window(60,70,570,390);
    reaper.ShowConsoleMsg('MASTER TRACK:\n\nRus:\n\n  *  Введите в окно ввода Имя эффекта, который будет добавляться на мастер трек:\n'..
                          S(6)..'Если на мастер трек не надо добавлять, то оставьте поле пустым.\n\n'..prefRus..'\n\n\n\n'..
                                'Eng:\n\n  *  Enter in the input box the name of the effect that will be added to the master track:\n'..
                          S(6)..'If you do not need to add the master track, leave the field blank.\n\n'..prefEng..'\n\n\n');
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx by name to selected tracks + Master track", 1,
                             S(4).."Enter Name Fx Master track:, extrawidth=200","");
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    local
    MasterFx = retvals_csv:reverse():gsub("^%s+.-",""):reverse():gsub("^%s+.-","");
    ----------------------



    ---SELECTED TRACK-----
    reaper.ClearConsole();
    Size_Pos_Window(60,70,570,390);
    reaper.ShowConsoleMsg('SELECTED TRACK:\n\nRus:\n\n  *  Введите в окно ввода Имя эффекта, который будет добавляться на выделенные треки:\n'..
                          S(6)..'Если на выделенные треки не надо добавлять, то оставьте поле пустым.\n\n'..prefRus..'\n\n\n\n'..
                                'Eng:\n\n  *  Enter in the input box the name of the effect that will be added to the selected tracks:\n'..
                          S(6)..'If you do not need to add the selected track, leave the field blank.\n\n'..prefEng..'\n\n\n');
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx by name to selected tracks + Master track", 1,
                             S(2).."Enter Name Fx Selected track:, extrawidth=200","");
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    local
    Track_FX = retvals_csv:reverse():gsub("^%s+.-",""):reverse():gsub("^%s+.-","");
    ----------------------



    ---no name------------
    if MasterFx == "" and Track_FX == "" then;
        Window_Destroy()
        local _MB = reaper.MB('Rus:\n\nНеобходимо заполнить хотя бы одно поле.\nВвести имя эффекта по новой ? - OK\n\n'..
                        'Eng:\n\nAt least one field must be filled.\nEnter Fx name by new ? - OK',"ERROR",1);
        if _MB == 2 then Arc.no_undo() return end;
        if _MB == 1 then goto X1 end;
    end;
    ----------------------



    ---Open_FX------------
    ::X2::
    reaper.ClearConsole();
    Size_Pos_Window(60,70,410,360);
    reaper.ShowConsoleMsg('OPEN FX:\n\nRus:\n\n  *  Введите в окно ввода значение от 0 до 2, как открыть Fx:\n'..
                              S(8)..'0 = Не открывать эффект;\n'..
                              S(8)..'1 = Открыть эффект в цепочке;\n'..
                              S(8)..'2 = Открыть эффект плавающий;'..
                              '\n\n\n\n'..
                          'Eng:\n\n  *  Enter in the input window a value from 0 to 2, how to open Fx:\n'..
                              S(8)..'0 = Do not open the Fx;;\n'..
                              S(8)..'1 = Open Fx in chain;\n'..
                              S(8)..'2 = Open floating Fx;'..'\n\n\n');
    local
    Open_FX = tonumber(reaper.GetExtState(sectionExtState,"Open_FX"));
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx by name to selected tracks + Master track", 1,
                             S(0).."Open Fx: 0 no; 1 chain; 2 float;",Open_FX or 2);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    retvals_csv = retvals_csv:gsub("%s+","")
    if not Arc.If_Equals(retvals_csv,"0","1","2")then goto X2 end;
    reaper.SetExtState(sectionExtState,"Open_FX",retvals_csv,true);
    Open_FX = tonumber(retvals_csv);
    ----------------------




    ---Position_FX--------
    ::X3::
    reaper.ClearConsole();
    Size_Pos_Window(60,70,470,330);
    reaper.ShowConsoleMsg('POSITION FX:\n\nRus:\n\n  *  Введите в окно ввода значение от -1 до n, на какую позицию добавить Fx:\n\n'..
                              S(8)..'-1 = добавить Fx всегда на последнюю позицию;\n'..
                              S(8)..'Иначе установите номер позиции Fx;\n'..
                              '\n\n'..
                          'Eng:\n\n  *  Enter in the input box a value from -1 to n, to which position to add Fx:\n'..
                              S(8)..'-1 = add Fx always to the last position;\n'..
                              S(8)..'Otherwise, set the position number Fx;'..'\n\n\n');
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx by name to selected tracks + Master track", 1,
                             S(10).."Position Fx: < -1 - n >", -1);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    retvals_csv = tonumber(retvals_csv);
    if type(retvals_csv) == 'number' and retvals_csv >= -1 and retvals_csv <= 100000 then else goto X3 end;
    local
    Position_FX = retvals_csv;
    ----------------------




    ---CloseAllFX---------
    ::X4::
    reaper.ClearConsole();
    Size_Pos_Window(60,70,530,360);
    reaper.ShowConsoleMsg('CLOSE FX:\n\nRus:\n\n  *  Введите в окно ввода значение от 0 до 2, Закрыть предыдущие(открытые) Fx или нет:\n\n'..
                              S(8)..'= 0 Не закрывать предыдущие (открытые) Fx;\n'..
                              S(8)..'= 1 Закрыть все предыдущие (открытые) Fx;\n'..
                              S(8)..'= 2 Закрыть только у выделенных треков предыдущие (открытые)Fx;\n'..
                              '\n\n'..
                          'Eng:\n\n  *  Enter in the input box a value from -1 to n, to which position to add Fx:\n'..
                              S(8)..'= 0 Do not close the previous (open) Fx;\n'..
                              S(8)..'= 1 Close all previous (open) Fx;\n'..
                              S(8)..'= 2 Close only selected tracks from previous (open) Fx;'..'\n\n\n');
    local
    CloseAllFX = tonumber(reaper.GetExtState(sectionExtState,"CloseAllFX"));
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx by name to selected tracks + Master track", 1,
                             S(10).."Close Fx: < 0 - 2 >", CloseAllFX or 0);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    retvals_csv = retvals_csv:gsub("%s+","");
    if not Arc.If_Equals(retvals_csv,"0","1","2")then goto X4 end;
    reaper.SetExtState(sectionExtState,"CloseAllFX",retvals_csv,true);
    CloseAllFX = retvals_csv
    ----------------------



    ---NameScript---------
    local MasNameTr,SelNameTr,RusMasNameTr,RusSelNameTr;
    if MasterFx ~= "" then;
        MasNameTr = S(1)..'MastTrack'..S(1)..MasterFx;
        RusMasNameTr =  S(1)..'Мастер Трек'..S(1)..MasterFx;
    else;
        MasNameTr = "";
        RusMasNameTr = "";
    end;

    if Track_FX ~= "" then;
        SelNameTr = S(1)..'SelTrack'..S(1)..Track_FX;
        RusSelNameTr = S(1)..'Выбранный трек'..S(1)..Track_FX;
    else;
        SelNameTr = "";
        RusSelNameTr = "";
    end;

    local
    AbbreviatedNameScript = 'Add Fx by name'..MasNameTr..SelNameTr;
    AbbreviatedNameScript = AbbreviatedNameScript:gsub("%s%s%s"," "):gsub("%s%s"," "):gsub("%s%s"," ");
    local
    NameScript = 'Archie_FX;'..S(2)..AbbreviatedNameScript..'.lua'
    ----------------------




    local function main();

        ::StartWrite_1::-->>>

        local countTrack = reaper.CountSelectedTracks2(0,true);
        if countTrack == 0 then Arc.no_undo() return end;


        reaper.PreventUIRefresh(1);
        local Undo,NoFxMaster,NoFxSTrack;


        if CloseAllFX == 1 then;
            local track,i;
            while countTrack do;
                i = (i or -2)+1;
                if i == -1 then;
                    track = reaper.GetMasterTrack(0);
                else;
                    track = reaper.GetTrack(0,i);
                end;
                if not track then break end;
                local countFx = reaper.TrackFX_GetCount(track);
                for j = 1, countFx do;
                    reaper.TrackFX_SetOpen(track,j-1,0);
                end;
                if i == 10^6 then break end;
            end;
        elseif CloseAllFX == 2 then;
            local track,i;
            while true do;
                i = (i or -2)+1;
                if i == -1 then;
                    local M_track = reaper.GetMasterTrack(0);
                    local Sel = reaper.IsTrackSelected(M_track);
                    if Sel then track = M_track end;
                else;
                    track = reaper.GetSelectedTrack(0,i);
                end;
                if not track and i > 0 then break end;
                if track then;
                    local countFx = reaper.TrackFX_GetCount(track);
                    for j = 1, countFx do;
                        reaper.TrackFX_SetOpen(track,j-1,0);
                    end;
                end;
                if i == 10^6 then break end;
            end;
        end;
        ----


        local TrackCount = reaper.CountSelectedTracks(0);
        for i = 0,TrackCount do;
            ----
            local track,name_FX;
            if i == 0 then;
                local Master_tr = reaper.GetMasterTrack(0);
                local Sel = reaper.IsTrackSelected(Master_tr);
                if Sel then;
                    track = Master_tr;
                    name_FX = MasterFx;
                end;
            else;
                track = reaper.GetSelectedTrack(0,i-1);
                name_FX = Track_FX;
            end;
            ----
            if track then;

                local Idx = reaper.TrackFX_AddByName(track,name_FX,false,-1);

                if not Undo and Idx >= 0 then;
                    reaper.Undo_BeginBlock() Undo = true;
                end;

                -----/ Does it exist Fx / Существует ли эффект /---------------------
                if i == 0 and MasterFx ~= "" and Idx == -1 then NoFxMaster = true end;
                if i > 0 and Track_FX ~= "" and Idx == -1 then  NoFxSTrack = true end;
                ---------------------------------------------------------------------

                if Idx >= 0 then;
                    ----
                    if Position_FX > 0 then;
                        reaper.TrackFX_CopyToTrack(track,Idx,track,Position_FX-1,1);
                        local countFx = reaper.TrackFX_GetCount(track);

                        if Position_FX > countFx then;
                            Idx = countFx-1;
                        else;
                            Idx = Position_FX-1;
                        end;
                    end;
                    ----
                    if Open_FX == 1 or Open_FX == 2 then;
                        if Open_FX == 2 then Open_FX = 3 end;
                        reaper.TrackFX_Show(track,Idx,Open_FX);
                    end;
                    ----
                end;
            end;
        end;

        if Undo then;
            reaper.Undo_EndBlock(AbbreviatedNameScript,-1);
        else;
            Arc.no_undo();
        end;
        reaper.PreventUIRefresh(-1);
        ---------



        --------------
        local StrRus =
        'Удалите данный скрипт и создайте новый с помощь\n\n'..
        '"Archie_FX;  Smart template - Add Fx by name to selected tracks + Master track.lua"\n\n'..
        'И введите корректное имя Эффекта.\n------------------\n'

        local StrEng =
        'Delete this script and create a new one using\n\n'..
        '"Archie_FX;  Smart template - Add Fx by name to selected tracks + Master track.lua"\n\n'..
        'And enter the correct Fx name.\n------------------\n'

        local StrRem =
         "\n\nУдалить Данный Скрипт ? - Ok.\n\nRemove This Script ? - Ok."


        local _MB;
        if NoFxMaster and NoFxSTrack then;
            _MB = reaper.MB('Rus:\n\nНе существует эффекта с именем "'..MasterFx..'" - (Назначен на мастер трек)"\n и\n"'..
                            Track_FX..'" - (Назначен на выделенный трек)\n\n'..StrRus..'\n\n'..
                           'Eng:\n\nThere is no effect named "'..MasterFx..'" - (Assigned to the master track)\n and\n"'..
                           Track_FX..'" - (Assigned to a selected track)\n\n'..StrEng..StrRem ,AbbreviatedNameScript,1);
        elseif NoFxMaster then;
            _MB = reaper.MB('Rus:\n\nНе существует эффекта с именем "'..MasterFx..'" - (Назначен на мастер трек)"\n\n"'..StrRus..'\n\n'..
                           'Eng:\n\nThere is no effect named "'..MasterFx..'" - (Assigned to the master track)"\n\n"'..StrEng..
                           StrRem ,AbbreviatedNameScript,1);
        elseif NoFxSTrack then;
            _MB = reaper.MB('Rus:\n\nНе существует эффекта с именем "'..Track_FX..'" - (Назначен на выделенный трек)"\n\n"'..StrRus..'\n\n'..
                           'Eng:\n\nThere is no effect named "'..Track_FX..'" - (Assigned to a selected track)"\n\n"'..StrEng..
                           StrRem ,AbbreviatedNameScript,1);
        end;


        if _MB == 1 then;
            local
            filename = ({reaper.get_action_context()})[2];
            reaper.AddRemoveReaScript(false,0,filename,true);
            os.remove(filename);
            if Arc.js_ReaScriptAPI(false) then;
                if reaper.MB('Rus:\n\nОткрыть Экшен лист с фильтром \n'..
                            'Archie_FX;  Smart template - Add Fx by name to selected tracks + Master track.lua ?\n\n\n'..
                            'Eng:\n\nOpen an Action sheet with a filter ?\n'..
                            'Archie_FX;  Smart template - Add Fx by name to selected tracks + Master track.lua ?\n\n\n'
                            ,"Add Fx by Name",1) == 1 then;
                    reaper.ShowActionList();
                    local winHWND = reaper.JS_Window_Find("Actions",true);
                    if winHWND then;
                        local filter_Act = reaper.JS_Window_FindChildByID(winHWND,1324);
                        reaper.JS_Window_SetTitle(filter_Act,'Archie_FX;  Smart template - Add Fx by name to selected tracks + Master track.lua');
                    end;
                end;
            end;
            ---
        end;
        Arc.no_undo();
        --------------

        ::StopWrite_1::--<<<
    end;
    ------------------------
    ------------------------



    ---read / Читаем-------------------------------------
    local write,shift;local
    IO = io.open(({reaper.get_action_context()})[2],"r");
    local tbl={};
    for var in IO:lines()do;


        var = var:gsub("Description:.+", "Description: "..AbbreviatedNameScript, 1);
        var = var:gsub("AboutScript:.+", "AboutScript: "..AbbreviatedNameScript, 1);
        var = var:gsub("О скрипте:.+", "О скрипте:   ".."Добавить Fx по имени"..RusMasNameTr..RusSelNameTr,1);


        local write1 = string.match (var,"::StopWrite_0::");
        if write1 then write = true end;


        local write2 = string.match (var,"::StartWrite_1::");
        if write2 then write = false;
            shift = true;
            var = var:gsub("::StartWrite_1::.+",S(0).."local MasterFx = '"..MasterFx.."';\n"..
                                                S(4).."local Track_FX = '"..Track_FX.."';\n"..
                                                S(4).."local Open_FX = "..Open_FX..";\n"..
                                                S(4).."local Position_FX = "..Position_FX..";\n"..
                                                S(4).."local CloseAllFX = "..CloseAllFX..";\n"..
                                                S(4).."local AbbreviatedNameScript = '"..AbbreviatedNameScript.."';\n\n")

        end;
        if shift then;
            var = var:gsub(" ","",4);
        end;

        if string.match(var,"::StopWrite_1::")then break end;

        if not write then;
            tbl[#tbl+1] = var;

            --reaper.ShowConsoleMsg(tbl[#tbl].."\n");--*
        end;
    end;
    ------------------------------------------------



    reaper.ClearConsole();
    Size_Pos_Window(60,70,500,250);
    reaper.ShowConsoleMsg("Rus:\n\n"..S(3).."ПОДОЖДИТЕ!\n"..S(6).."ПИШЕТСЯ СЦЕНАРИЙ.\n\nEng:\n\n"..S(3).."WAIT!\n"..S(6).."WRITING SCRIPT.");



    ---write / Пишем----------------
    local
    newNameScript = io.open(({reaper.get_action_context()})[2]:match("(.+)[\\/]").."/"..NameScript,'w');
    for i = 1,#tbl do;

        newNameScript:write(tbl[i].."\n");
    end;
    newNameScript:close();
    reaper.AddRemoveReaScript(true,0,({reaper.get_action_context()})[2]:match("(.+)[\\/]").."/"..NameScript,true);
    -------------------------------------------------------------------



    ---Created Script-----
    if not Arc.js_ReaScriptAPI(false) then;
    reaper.ClearConsole();
    Size_Pos_Window(60,70,600,250);
    reaper.ShowConsoleMsg("Rus:\n"..
                          " * СОЗДАН СКРИПТ \n"..
                          " * "..NameScript.."\n"..
                          " * ИЩИТЕ В ЭКШЕН ЛИСТЕ \n"..
                          "-----------------------------------------------\n\n"..
                          "Eng:\n"..
                          " * SCRIPT CREATED \n"..
                          " * "..NameScript.."\n"..
                          " * SEARCH THE ACTION LIST\n"..
                          "-------------------------------------------------");
    end;
    ---------------------------------------------------



    reaper.ShowActionList();

    if Arc.js_ReaScriptAPI(false) then;
        local winHWND = reaper.JS_Window_Find("Actions",true);
        if winHWND then;
            local filter_Act = reaper.JS_Window_FindChildByID(winHWND,1324);
            reaper.JS_Window_SetTitle(filter_Act,NameScript);
            reaper.JS_Window_Move(winHWND,250,100);
            Window_Destroy();
        end;
    end;
    Arc.no_undo();