--[[
   * Category:    FX
   * Description: Smart template - Add Fx chain by name for selected items or in time selection
   * Author:      Archie
   * Version:     1.06
   * AboutScript: Smart template - Add Fx chain by name for selected items or in time selection
   * О скрипте:   Умный шаблон - Добавить цепочку Fx по имени для выбранных элементов или в выборе времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    HDVulcan[RMM]
   * Gave idea:   HDVulcan[RMM]
   * Changelog:
   *              +  Add support for formats DDP,FLAC,MP3,OGG VORBIS,OGG OPUS,WV / v.1.05 [25112019]

   *              +  Added selection FadeOut Shape / v.1.04 [27032019]
   *              !+ Fixed bug with midi / v.1.03 [23032019]
   *              !+ Optimization / v.1.02 [22032019]
   *              +  Open Fx, Fade in/out Shape, Remove time sel / v.1.01 [20032019]
   *              +  initialе / v.1.0 [18032019]


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
	




    local function S(x)return string.rep(" ",x)end;--<<
    local sectionExtState = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");



    local function Size_Pos_Window(left,top,width,height);
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



    local function Rep(val,num) return string.rep(val,num)end;



    ----------------------
    reaper.ClearConsole();
    Size_Pos_Window(60,70,450,250);
    reaper.ShowConsoleMsg("Rus:\n\n  *  Введите в окно ввода Имя или полный путь сохраненной цепочки Fx:\n"..
                          "----------------------\n\n"..
                          "Eng:\n\n  *  Enter the name or full path of the saved Fx chain in the input box:\n"..
                          "----------------------");
    ::X1::local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select", 1,
                         S(5).."Enter Name Saved Fx Chain:, extrawidth=200","");
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    if retvals_csv:gsub(" ","") == "" then goto X1 end;
    local
    Name_FXChains = retvals_csv:gsub("\\","/");
    local
    Name_FXChainsX = (Name_FXChains:match(".+[\\/](.+)") or Name_FXChains)
    :reverse()
    :gsub("niahCxfR.","",1)
    :reverse();
    local
    ScripnName = "Archie_FX;  Add Fx chain by Name - "..Name_FXChainsX.." - for selected items or in time selection(smart).lua";
    local
    ScripnNameX = "Add Fx chain by Name - "..Name_FXChainsX.." - for selected items or in time selection(smart)";
    -------------------------------------



    --Selection-----------
    reaper.ClearConsole();
    Size_Pos_Window(60,70,500,440);
    reaper.ShowConsoleMsg("Rus:\nВыделение:\nВведите в окно ввода значение от -1 до 1. \n\n"..
                          "-1  =  Останутся все элементы выделенными. \n\n"..
                          "0  =  Если выбор времени присутствует, то останутся выделенные только "..
                          "активные элементы, если выбора времени нет то останутся все "..
                          "выделенные, т.к. все выделенные активные. \n\n"..
                          "1 = выделение снимется со всех элементов.\n----------------------\n\n"..
                          "Eng:\nSelection:\nEnter a value from -1 to 1 in the input box.\n\n"..
                          "-1  =  All items will remain selected.\n\n"..
                          "0  =  If time selection is present, then only active items will "..
                          "remain selected, if there is no time selection, then all selected "..
                          "ones will remain, since all selected active.\n\n"..
                          "1 = selection will be removed from all items\n----------------------\n\n");
    local
    Selection = tonumber(reaper.GetExtState(sectionExtState,"Selection"));
    ::X2::local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select", 1,
                          "What to Select: < -1  |  0  |  1 >, extrawidth=87",Selection or 0);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    if not Arc.If_Equals(retvals_csv,"-1","0","1")then goto X2 end;
    reaper.SetExtState(sectionExtState,"Selection",retvals_csv,true);
    Selection = tonumber(retvals_csv);
    ----------------------------------



    --openFx--------------
    reaper.ClearConsole();
    Size_Pos_Window(60,70,520,470);
    reaper.ShowConsoleMsg("Rus:\nОткрыть Эффекты.\nВведите в окно ввода значение от 0 до 3.\n\n"..
                          "0 = не открывать эффекты,\n\n1 = открыть в цепи,\n\n"..
                          "2 = открыть только первый эффект из сохраненной цепочки эффектов (плавающий),"..
                          "\n\n3 = открыть все эффекты сохраненной цепочки эффектов  (плавающие)\n"..
                          "------------------------------------\n\n\n"..
                          "Eng:\nOpen Fx.\nEnter a value between 0 and 3 in the input box.\n\n"..
                          "0 = do not open fx,\n\n1 = open in chain,\n\n"..
                          "2 = open only the first fx from the saved fx chain (floating),\n\n"..
                          "3 = open all fx (floating)\n------------------------------------");
    local
    openFx = tonumber(reaper.GetExtState(sectionExtState,"openFx"));
    ::X7::local
    retval,retvals_csv = reaper.GetUserInputs( "Smart template - Add Fx chain by name for selected items or in time select", 1,
                          S(10).."Open Fx:  < 0  -  3 >, extrawidth=87",openFx or 0);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    if not Arc.If_Equals(retvals_csv,"0","1","2","3")then goto X7 end;
    reaper.SetExtState(sectionExtState,"openFx",retvals_csv,true);
    openFx = tonumber(retvals_csv);
    ----------------------



    --fade_in_out---------
    reaper.ClearConsole();
    Size_Pos_Window(60,70,730,455);
    reaper.ShowConsoleMsg("Rus:\nПовышение / Затухание.\nВведите в окно ввода значение от -1 до 1. \n\n"..
                          "-1  = Повышение / Затухание устанавливается исходя из настроек Жнеца.\n\n"..
                          "0  =  Если выбор времени присутствует, то  Повышение / Затухание установится на всех "..
                          "разрезах и активных элементах, а если выбор времени отсутствует, то Повышение / "..
                          "Затухание устанавливается на всех выделенных, т.к. все выделенные активные.\n\n"..
                          "1  =  Если выбор времени присутствует, то  Повышение / Затухание установится только на "..
                          "активных элементах, а если выбор времени отсутствует, то Повышение / Затухание "..
                          "устанавливается на всех выделенных, т.к. все выделенные активные.\n-----------------\n\n"..
                          "Eng:\nFade in / Fade out.\nEnter a value from -1 to 1 in the input box.\n\n "..
                          "-1  =  Fade in / Fade out is set based on the Reaper settings.\n\n"..
                          "0  =  If time selection is present, then  Fade in / Fade out  will be established on all"..
                          "cuts and active elements, and if there is no time selection, then  Fade in / Fade out "..
                          "is set on all selected ones, since all selected active.\n\n"..
                          "1  =  If the time selection is present, then the  Fade in / Fade out  is established only "..
                          "on the active elements, and if there is no time selection, then the Fade in / Fade is set"..
                          " on all selected elements, since all selected active.\n-----------------\n\n");
    local
    fade_all_active = tonumber(reaper.GetExtState(sectionExtState,"fade_all_active"));
    ::X3::local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select",1,
                          "Fade in / out: < -1  |  0  |  1 >, extrawidth=87",fade_all_active or -1);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    if not Arc.If_Equals(retvals_csv,"-1","0","1")then goto X3 end;
    reaper.SetExtState(sectionExtState,"fade_all_active",retvals_csv,true);
    fade_all_active = retvals_csv;
    local fade_in,fade_out;
    if Arc.If_Equals(fade_all_active,"0","1")then;



        --fade_in-------------
        reaper.ClearConsole();
        Size_Pos_Window(60,70,450,250);
        reaper.ShowConsoleMsg("Rus:\nПовышение.\nВведите в окно ввода значение Повышения от 0 до бесконечности. \n"..
                              "----------------------\n\n"..
                              "Eng:\nFade in. \nEnter the Fade in value from 0 to infinity in the input box.\n"..
                              "----------------------");

        fade_in = tonumber(reaper.GetExtState(sectionExtState,"fade_in"));
        ::X4::local
        retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select",1,
                              "Fade in Value:  <  0  - ? >, extrawidth=87",fade_in or 0);
        if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
        if not tonumber(retvals_csv) or tonumber(retvals_csv) < 0 then goto X4 end;
        reaper.SetExtState(sectionExtState,"fade_in",retvals_csv,true);
        fade_in = retvals_csv;
        ----------------------



        --fade_out------------
        reaper.ClearConsole();
        Size_Pos_Window(60,70,450,250);
        reaper.ShowConsoleMsg("Rus:\nЗатухание.\nВведите в окно ввода значение Затухание от 0 до бесконечности. \n"..
                              "----------------------\n\n"..
                             "Eng:\nFade out. \nEnter the Fade out value from 0 to infinity in the input box.\n"..
                             "----------------------");

        fade_out = tonumber(reaper.GetExtState(sectionExtState,"fade_out"));
        ::X5::local
        retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select",1,
                                      "Fade out Value:  <  0  - ? >, extrawidth=87",fade_out or 0);
        if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
        if not tonumber(retvals_csv) or tonumber(retvals_csv) < 0 then goto X5 end;
        reaper.SetExtState(sectionExtState,"fade_out",retvals_csv,true);
        fade_out = retvals_csv;
        -----------------------



        --Shape_Fade_in----------
        reaper.ClearConsole();
        Size_Pos_Window(60,70,500,300);
        reaper.ShowConsoleMsg("Rus:\nПовышение - форма..\nВведите в окно ввода значение формы Повышения от 1 до 7.\n1 линия, .....\n"..
                              "-1  = Форма Повышение устанавливается исходя из настроек Жнеца.\n"..
                              "----------------------\n\n"..
                              "Eng:\nFade in - Shape. \nEnter a value in the input box Fade in shape from 1 to 7.\n1 lines, .....\n"..
                              "-1  =  Fade in Shape is set based on the Reaper settings.\n"..
                              "----------------------");
        shape_Fade_in = tonumber(reaper.GetExtState(sectionExtState,"shape_Fade_in"));
        ::X6::local
        retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select",1,
                                      "FadeIn Shape Value: <1-7 or -1>, extrawidth=87",shape_Fade_in or -1);
        if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
        if not Arc.If_Equals(retvals_csv,"-1","1","2","3","4","5","6","7")then goto X6 end;
        reaper.SetExtState(sectionExtState,"shape_Fade_in",retvals_csv,true);
        shape_Fade_in = retvals_csv;
        -------------------------
    end;
    ----



    --Shape_Fade_out ----------    shape_Fade_out
    reaper.ClearConsole();
    Size_Pos_Window(60,70,500,300);
    reaper.ShowConsoleMsg("Rus:\nЗатухание  - форма..\nВведите в окно ввода значение формы Затухание  от 1 до 7.\n1 линия, .....\n"..
                          "-1  = Форма Затухание устанавливается исходя из настроек Жнеца.\n"..
                          "----------------------\n\n"..
                          "Eng:\nFade out - Shape. \nEnter a value in the input box Fade out shape from 1 to 7.\n1 lines, .....\n"..
                          "-1  =  Fade out Shape is set based on the Reaper settings.\n"..
                          "----------------------");
    shape_Fade_out = tonumber(reaper.GetExtState(sectionExtState,"shape_Fade_out"));
    ::X8::local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected items or in time select",1,
                                  "FadeOut Shape Val: <1-7 or -1>, extrawidth=87",shape_Fade_out or -1);
    if retval == false then reaper.ClearConsole()Window_Destroy()Arc.no_undo() return end;
    if not Arc.If_Equals(retvals_csv,"-1","1","2","3","4","5","6","7")then goto X8 end;
    reaper.SetExtState(sectionExtState,"shape_Fade_out",retvals_csv,true);
    shape_Fade_out = retvals_csv;
    -----------------------------



    local function main();
    -->>New Script>>
        local IO;
        do;
            local Path1 = reaper.GetResourcePath().."/FXChains/"..Name_FXChains..".RfxChain";
            local Path2 = reaper.GetResourcePath().."/FXChains/"..Name_FXChains;
            local Path3 = Name_FXChains..".RfxChain";
            local Path4 = Name_FXChains;



            IO = io.open(Path1,"r");
            if not IO then;
               IO = io.open(Path2,"r");
            end;
            if not IO then;
               IO = io.open(Path3,"r");
            end;
            if not IO then;
               IO = io.open(Path4,"r");
            end;
            if not IO then goto NoChain end;
            local textChain = IO:read("a");
            IO:close();



            local
            CountSelItem = reaper.CountSelectedMediaItems(0);
            if CountSelItem == 0 then Arc.no_undo() return end;



            local function FadeShape(Item,str,num);
                if tonumber(num) > 0 and tonumber(num) <= 7 then;
                    reaper.SetMediaItemInfo_Value(Item,str,num-1);
                    return true;
                end;
                return false;
            end;



            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);



            local
            Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);



            -->>--#5---/ TimeSel /-----
            local Start1, End1;
            if Start ~= End then;
                local ItemTimeSel;
                for i = 1, CountSelItem do;
                    local SelItem = reaper.GetSelectedMediaItem(0,i-1);
                    local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                    local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                    if PosIt < End and EndIt > Start then;
                        ItemTimeSel = true;
                        break;
                    end;
                end;
                if not ItemTimeSel then;
                    reaper.GetSet_LoopTimeRange(1,0,Start,Start,0);
                    Start1, End1 = Start, End; Start, End = 0,0;
                end;
            end;
            --<=--#5---/ TimeSel /-----



            -->>-#1---/ Split, fade_in, fade_out /----------
            if Start ~= End then;-->-1.1.0

                for i = CountSelItem-1,0,-1 do;-->-1
                    local SelItem = reaper.GetSelectedMediaItem(0,i);
                    local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                    local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                    if PosIt < End and EndIt > Start then;-->-1.1

                        local It_f_i = reaper.SplitMediaItem(SelItem,End);
                        if fade_all_active == 0 then;
                            if It_f_i then;
                                reaper.SetMediaItemInfo_Value(It_f_i,"D_FADEINLEN",fade_in);
                                reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);
                                FadeShape(It_f_i,"C_FADEINSHAPE",shape_Fade_in);
                                FadeShape(SelItem,"C_FADEOUTSHAPE",shape_Fade_out);
                            end;
                        end;

                        local It_f_o = reaper.SplitMediaItem(SelItem,Start);
                        if fade_all_active == 0 then;
                            if It_f_o then;
                                reaper.SetMediaItemInfo_Value(It_f_o,"D_FADEINLEN",fade_in);
                                reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);
                                FadeShape(It_f_o,"C_FADEINSHAPE",shape_Fade_in);
                                FadeShape(SelItem,"C_FADEOUTSHAPE",shape_Fade_out);
                            end;
                        end;
                    end;--<-1.1
                end;--<-1

                if Arc.If_Equals(fade_all_active,0,1) then;-->-3
                    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;-->-3.1
                        local SelItem = reaper.GetSelectedMediaItem(0,i);
                        local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                        local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                        if PosIt >= Start and EndIt <= End then;
                            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fade_in);
                            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);
                            FadeShape(SelItem,"C_FADEINSHAPE",shape_Fade_in);
                            FadeShape(SelItem,"C_FADEOUTSHAPE",shape_Fade_out);
                        end;
                    end;--<-3.1
                end;--<-3

            else--<->-1.1.0;
                if Arc.If_Equals(fade_all_active,0,1) then;-->-3.1.1

                    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;-->-3.1.2

                        local SelItem = reaper.GetSelectedMediaItem(0,i);
                        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fade_in);
                        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);
                        FadeShape(SelItem,"C_FADEINSHAPE",shape_Fade_in);
                        FadeShape(SelItem,"C_FADEOUTSHAPE",shape_Fade_out);

                    end;--<-3.1.2
                end;--<-3.1.1
            end;--<-1.1.0
            --<<-#1---/ ------------------------ /----------



            --------------------------------------------------------------------------------
            --COPY------------------------------------------------------------------
            ----------------------------------------------------------------
            --[[
            -->>-#2-----------------------
            local DimmyIt = reaper.CreateNewMIDIItemInProj(reaper.GetTrack(0,0),15000,15010);
            local Dimmy_take = reaper.GetActiveTake(DimmyIt);
            local take = reaper.GetActiveTake(DimmyIt);
            for i = reaper.TakeFX_GetCount(take)-1,0,-1 do;
                reaper.TakeFX_Delete(take,i);
            end;
            local str = ({reaper.GetItemStateChunk(DimmyIt,"",false)})[2]:gsub(">\n>",">\n<TAKEFX\n"..textChain..">\n>",1);
            reaper.SetItemStateChunk(DimmyIt,str,false);
            --<=-#2-----------------------



            -->>-#3-----------------------
            local ChainFx,fload_one_Fx;
            if Start ~= End then;-->-1.1.0
                for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                    local SelItem = reaper.GetSelectedMediaItem(0,i);
                    local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                    local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                    if PosIt >= Start and EndIt <= End then;
                        local dest_take = reaper.GetActiveTake(SelItem);
                        for i2 = 1, reaper.TakeFX_GetCount(Dimmy_take) do;

                            ---
                            if openFx == 1 then;
                                if not ChainFx then;
                                   ChainFx = reaper.TakeFX_GetCount(dest_take);
                                   reaper.TakeFX_Show(dest_take,ChainFx,0);
                                end;
                            end;
                            ----
                            reaper.TakeFX_CopyToTake(Dimmy_take,i2-1,dest_take,reaper.TakeFX_GetCount(dest_take),0);
                            ---
                            if openFx == 2 then;
                                if not fload_one_Fx then;
                                    reaper.TakeFX_Show(dest_take,reaper.TakeFX_GetCount(dest_take)-1,3);
                                    fload_one_Fx = true;
                                end;
                            end;

                            if openFx == 3 then;
                                reaper.TakeFX_Show(dest_take, reaper.TakeFX_GetCount(dest_take)-1,3);
                            end;
                            ----
                        end;
                        if openFx == 1 then;
                            reaper.TakeFX_Show(dest_take,ChainFx,1);
                            ChainFx = nil;
                        end;
                        ChainFx = nil;
                        fload_one_Fx = nil;
                    end;
                end;
            else;
                for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                    local SelItem = reaper.GetSelectedMediaItem(0,i);
                    local dest_take = reaper.GetActiveTake(SelItem);
                    for i2 = 1, reaper.TakeFX_GetCount(Dimmy_take) do;
                        ---
                        if openFx == 1 then;
                            if not ChainFx then;
                               ChainFx = reaper.TakeFX_GetCount(dest_take);
                               reaper.TakeFX_Show(dest_take,ChainFx,0);
                            end;
                        end;
                        ----
                        reaper.TakeFX_CopyToTake(Dimmy_take,i2-1,dest_take,reaper.TakeFX_GetCount(dest_take),0);
                        ---
                        if openFx == 2 then;
                            if not fload_one_Fx then;
                                reaper.TakeFX_Show(dest_take,reaper.TakeFX_GetCount(dest_take)-1,3);
                                fload_one_Fx = true;
                            end;
                        end;

                        if openFx == 3 then;
                            reaper.TakeFX_Show(dest_take, reaper.TakeFX_GetCount(dest_take)-1,3);
                        end;
                        ----
                    end;
                    if openFx == 1 then;
                        reaper.TakeFX_Show(dest_take,ChainFx,1);
                        ChainFx = nil;
                    end;
                    ChainFx = nil;
                    fload_one_Fx = nil;
                end;
            end;
            --<<-#3-----------------------


            -->=-#2----------------------
            Arc.DeleteMediaItem(DimmyIt);
            --<<-#2----------------------
            --]]
            ------------------------------------------------------------------
            ---COPY-----------------------------------------------------------------
            --------------------------------------------------------------------------------




            ------------------------------------------------------------
            ---CHUNK---v.1.02--------------------------------------
            --------------------------------------------------
            local function AddFxChainToItemInActiveTake(Item,textChain);

                local GUIDTake, varX, TakeChunk, str2, lock_1
                local str = ({reaper.GetItemStateChunk(Item,"",false)})[2];
                ----------------------------
                for var in string.gmatch(str.."\n\n\n\n", ".-\n") do;
                    if var == "TAKE\n" or  var == "TAKE SEL\n" then;
                        if var == "TAKE SEL\n" then TakeChunk = true end;
                        var = "\n\n\n\n"..var;
                    end;
                    str2 = (str2 or "")..var;
                end;
                str = str2;
                str2 = nil;
                -----------

                local
                CountFXTake = reaper.TakeFX_GetCount(reaper.GetActiveTake(Item));

                for var in string.gmatch(str, ".-\n\n\n") do;

                    if TakeChunk then;
                        local Take_Sel = string.match(var, "TAKE SEL\n");
                        if Take_Sel then;
                            ----
                            local Take_Fx  = string.match(var, "TAKEFX\n");
                            if Take_Fx then;
                                for var2 in string.gmatch(var,".-\n") do;
                                    if var2 == "<TAKEFX\n" then S=1 end;
                                    if S and S > 0 and var2 ~= "<TAKEFX\n" then;
                                        if string.sub(var2,0,1) == "<" then S=S+1 end;
                                        if string.sub(var2,0,1) == ">" then S=S-1 end;
                                        if S == 0 then;
                                            var2 = textChain.."\n"..var2;
                                            S=nil;
                                        end;
                                    end;
                                    varX = (varX or "")..var2;
                                end;
                                varX = string.gsub(varX,"LASTSEL %d","LASTSEL "..CountFXTake);
                                GUIDTake = string.match(varX, "\nGUID ({.-})");
                            else;
                                for var2 in string.gmatch(var,".-\n") do;
                                    ----
                                    if Arc.If_Equals(var2,"<SOURCE WAVE\n","<SOURCE MIDI\n",
                                              "<SOURCE DDP\n","<SOURCE FLAC\n","<SOURCE MP3\n",
                                          "<SOURCE VORBIS\n","<SOURCE OPUS\n","<SOURCE WAVPACK\n")then;
                                       S=1;
                                    end;
                                    --
                                    --if var2 == "<SOURCE WAVE\n" or var2 == "<SOURCE MIDI\n" then S=1 end;
                                    ----
                                    if S and S == 1 then;
                                        if var2 == ">\n" then var2 = string.gsub(var2,">\n",">\n<TAKEFX\n"..textChain.."\n>\n");
                                            S=nil;
                                        end;
                                    end;
                                    varX = (varX or "")..var2;
                                end;
                                varX = string.gsub(varX,"LASTSEL %d","LASTSEL 0");
                                GUIDTake = string.match(varX,"\nGUID ({.-})");
                            end;
                            ----
                        end;
                    else;
                        ---------
                        if not lock_1 then;
                            local Take_Fx  = string.match(var, "TAKEFX\n");
                            if Take_Fx then;
                                ----
                                for var2 in string.gmatch(var,".-\n") do;
                                    if var2 == "<TAKEFX\n" then S=1 end;
                                    if S and S > 0 and var2 ~= "<TAKEFX\n" then;
                                        if string.sub(var2,0,1) == "<" then S=S+1 end;
                                        if string.sub(var2,0,1) == ">" then S=S-1 end;
                                        if S == 0 then;
                                            var2 = textChain.."\n"..var2;
                                            S=nil;
                                        end;
                                    end;
                                    varX = (varX or "")..var2;
                                end;
                                ----
                                varX = string.gsub(varX,"LASTSEL %d","LASTSEL "..CountFXTake);
                                GUIDTake = string.match(varX,"\nGUID ({.-})");
                            else
                                for var2 in string.gmatch(var,".-\n") do;
                                    ----
                                    if Arc.If_Equals(var2,"<SOURCE WAVE\n","<SOURCE MIDI\n",
                                              "<SOURCE DDP\n","<SOURCE FLAC\n","<SOURCE MP3\n",
                                          "<SOURCE VORBIS\n","<SOURCE OPUS\n","<SOURCE WAVPACK\n")then;
                                       S=1;
                                    end;
                                    --
                                    --if var2 == "<SOURCE WAVE\n" or var2 == "<SOURCE MIDI\n" then S=1 end;
                                    ----
                                    if S and S == 1 then;
                                        if var2 == ">\n" then var2 = string.gsub(var2,">\n",">\n<TAKEFX\n"..textChain.."\n>\n");
                                            S=nil;
                                        end;
                                    end;
                                    varX = (varX or "")..var2;
                                end;
                                varX = string.gsub(varX,"LASTSEL %d","LASTSEL 0");
                                GUIDTake = string.match(varX,"\nGUID ({.-})");
                            end;
                            ----
                            lock_1 = true;
                        end;
                    end;
                    ----
                    if varX then var = varX; varX = nil; end;
                    str2 = (str2 or "").. var;
                end;
                str2 = string.gsub(str2,"\n\n\n\n","\n"):gsub("\n\n","\n");
                --reaper.ShowConsoleMsg(str2)-------------
                reaper.SetItemStateChunk(Item,str2,false);
                return GUIDTake, CountFXTake;
            end;
            ---------------------------------
            ---------------------------------


            --local ChainFx,fload_one_Fx;
            if Start ~= End then;-->-1.1.0
                for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                    local SelItem = reaper.GetSelectedMediaItem(0,i);
                    local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                    local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                    if PosIt >= Start and EndIt <= End then;
                        -------
                        local
                        GuidTake,numbFxPre = AddFxChainToItemInActiveTake(SelItem,textChain);
                        -------
                        local take = reaper.GetMediaItemTakeByGUID(0,GuidTake);
                        if take then;
                            if openFx == 1 then;
                                reaper.TakeFX_Show(take, numbFxPre,1);
                            elseif openFx == 2 then;
                                reaper.TakeFX_Show(take,numbFxPre,3);
                            elseif openFx == 3 then;
                                for i2 = numbFxPre, reaper.TakeFX_GetCount(take)-1 do;
                                    reaper.TakeFX_Show(take,i2,3);
                                end;
                            --[[  Обновить список Fx / Update Fx list;
                            elseif openFx == 0 then;
                                local ChainVisible = reaper.TakeFX_GetChainVisible(take);
                                if ChainVisible >= 0 or ChainVisible == -2 then;
                                    reaper.TakeFX_Show(take,numbFxPre,1);
                                end;
                            --]]
                            end;
                        end;
                        ----
                    end;
                end;
            else;
                for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                    local SelItem = reaper.GetSelectedMediaItem(0,i);
                    -------
                    local
                    GuidTake,numbFxPre = AddFxChainToItemInActiveTake(SelItem,textChain);
                    -------
                    local take = reaper.GetMediaItemTakeByGUID(0,GuidTake);
                    if take then;
                        if openFx == 1 then;
                            reaper.TakeFX_Show(take, numbFxPre,1);
                        elseif openFx == 2 then;
                            reaper.TakeFX_Show(take,numbFxPre,3);
                        elseif openFx == 3 then;
                            for i2 = numbFxPre, reaper.TakeFX_GetCount(take)-1 do;
                                reaper.TakeFX_Show(take,i2,3);
                            end;
                        --[[    Обновить список Fx / Update Fx list;
                        elseif openFx == 0 then;
                            local ChainVisible = reaper.TakeFX_GetChainVisible(take);
                            if ChainVisible >= 0 or ChainVisible == -2 then;
                                reaper.TakeFX_Show(take,numbFxPre,1);
                            end;
                        --]]
                        end;
                    end;
                    ----
                end;
            end;
            ------------------------------------------------
            --CHUNK-----------------------------------------------
            ------------------------------------------------------------




            -->>-#4----------------
            if Selection == 0 then;
                if Start ~= End then;
                    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;-->-2.1
                        local SelItem = reaper.GetSelectedMediaItem(0,i);
                        local PosIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
                        local EndIt = Arc.GetMediaItemInfo_Value(SelItem,"D_END");
                        if PosIt >= End or EndIt <= Start then;
                           Arc.SetMediaItemInfo_Value(SelItem,"B_UISEL",0);
                        end;
                    end;--<-2.1
                end;
            elseif Selection == 1 then;--<->-2
                reaper.SelectAllMediaItems(0,0);
            end;
            --<<-#4----------------



            -->=--#5---/ TimeSel /-----
            if TimeSelection == 0 then;
                reaper.GetSet_LoopTimeRange(1,0,Start, Start,0);
            else;
                if Start1 and End1 then;
                    reaper.GetSet_LoopTimeRange(1,0,Start1, End1,0);
                end;
            end;
            --<<--#5---/ TimeSel /-----



            reaper.Undo_EndBlock(ScripnNameX,-1);
            reaper.PreventUIRefresh(-1);
            reaper.UpdateArrange();
        end;

        ::NoChain::;

        if not IO then;
            local
            MB = reaper.MB(
            "Rus:\n\n"..
            " * Не существует цепочки FX с именем - \n"..
            "    "..Name_FXChainsX.."\n\n"..
            " * Создайте новый скрипт с помощью\n"..
            "    Archie_FX;  Smart template - Add Fx chain by name for selected items or in time selection.lua\n"..
            "   И существующей цепочки Fx! \n\n\n"..
            "Eng:\n\n"..
            " * There is no FX chain with a name - \n"..
            "    "..Name_FXChainsX.."\n\n"..
            " * Create a new script using\n"..
            "    Archie_FX;  Smart template - Add Fx chain by name for selected items or in time selection.lua\n"..
            "   And existing Fx chain! \n\n"..
            "-----------------\n\n"..
            " * УДАЛИТЬ ДАННЫЙ СКРИПТ ? - OK\n\n"..
            " * REMOVE THIS SCRIPT ? - OK\n",
            ScripnNameX,1);

            if MB == 1 then;
                local
                filename = ({reaper.get_action_context()})[2];
                reaper.AddRemoveReaScript(false,0,filename,true);
                os.remove(filename);
            end;
            Arc.no_undo() return;
        end;
        ---
    --<<New Script<<
    end;
    ----



    local Info_TimeSelection =
    "\n\n\n\n\n    --"..Rep("=",86).."\n    --"..Rep("/",12).."  НАСТРОЙКИ  "..Rep("\\",12)..
    "  SETTINGS  ".. Rep("/",12).."  НАСТРОЙКИ  "..Rep("\\",12).."\n"..S(4).."--"..Rep("=",86)..
    "\n\n\n\n\n".. S(4).."local TimeSelection = 1\n".. S(21).."-- = 0 | Убрать выбор времени\n"..
    S(21).."-- = 1 | Не убирать выбор времени\n".. S(21).."--"..Rep("=",32).."\n"..S(21)..
    "-- = 0 | Remove time selection\n".. S(21).."-- = 1 | Do not remove time selection\n"..S(21).."--"..Rep("=",35);



    ---read / Читаем-------------------------------------
    local write,shift;local
    IO = io.open(({reaper.get_action_context()})[2],"r");
    local tbl={};
    for var in IO:lines()do;

        var = var:gsub("Description:.+", "Description: "..ScripnNameX, 1);
        var = var:gsub("AboutScript:.+", "AboutScript: "..ScripnNameX, 1);
        var = var:gsub("О скрипте:.+", "О скрипте:   ".."Добавить цепочку Fx по имени - "..
            Name_FXChainsX.." для выбранных элементов или при выборе времени (умный)", 1);
        var = var:gsub("Open Fx, Fade in/out Shape, ","",1);
        var = var:gsub("%(%+%) reaper_js_ReaScriptAPI","(-) reaper_js_ReaScriptAPI",1);
        var = var:gsub("==========%]%]","==========]]"..Info_TimeSelection,1);




        local write1 = string.match (var,"local function S%(x%)");----str 62
        if write1 then write = true end;

        local write2 = string.match (var,"-->>New Script>>");
        if write2 then write = false;
            shift = true;

            var = var:gsub("-->>New Script>>", S(4).."local Name_FXChains = '"..Name_FXChains.."';\n"..
                                               S(4).."local Name_FXChainsX = '"..Name_FXChainsX.."';\n"..
                                               --S(4).."local ScripnName = '"..ScripnName.."';\n"..
                                               S(4).."local ScripnNameX = '"..ScripnNameX.."';\n"..
                                               S(4).."local Selection = "..Selection..";\n"..
                                               S(4).."local openFx = "..openFx..";\n"..
                                               S(4).."local fade_all_active = "..fade_all_active..";\n"..
                                               S(4).."local fade_in = "..(fade_in or 0)..";\n"..
                                               S(4).."local fade_out = "..(fade_out or 0)..";\n"..
                                               S(4).."local shape_Fade_in = "..(shape_Fade_in or -1)..";\n"..
                                               S(4).."local shape_Fade_out = "..(shape_Fade_out or -1)..";\n\n\n",1);
        end;

        if shift then;
            var = var:gsub(" ","",4);
        end;

        if string.match(var,"--<<New Script<<")then break end;

        if not write then;
            tbl[#tbl+1] = var;
            --reaper.ShowConsoleMsg(tbl[#tbl].."\n");
        end;
    end;
    ------------------------------------------------



    reaper.ClearConsole();
    reaper.ShowConsoleMsg("Rus:\n\n"..S(3).."ПОДОЖДИТЕ!\n"..S(6).."ПИШЕТСЯ СЦЕНАРИЙ.\n\nEng:\n\n"..S(3).."WAIT!\n"..S(6).."WRITING SCRIPT.");
    Size_Pos_Window(60,70,500,250);



    ---write / Пишем----------------
    local
    newNameScript = io.open(({reaper.get_action_context()})[2]:match("(.+)[\\/]").."/"..ScripnName,'w');
    for i = 1,#tbl do
        newNameScript:write(tbl[i].."\n");
    end
    newNameScript:close();
    reaper.AddRemoveReaScript(true,0,({reaper.get_action_context()})[2]:match("(.+)[\\/]").."/"..ScripnName,true);
    -------------------------------------------------------------------



    ---Created Script-----
    if not Arc.js_ReaScriptAPI(false) then;
    reaper.ClearConsole();
    Size_Pos_Window(60,70,600,250);
    reaper.ShowConsoleMsg("Rus:\n"..
                          " * СОЗДАН СКРИПТ \n"..
                          " * "..ScripnName.."\n"..
                          " * ИЩИТЕ В ЭКШЕН ЛИСТЕ \n"..
                          "-----------------------------------------------\n\n"..
                          "Eng:\n"..
                          " * SCRIPT CREATED \n"..
                          " * "..ScripnName.."\n"..
                          " * SEARCH THE ACTION LIST\n"..
                          "-------------------------------------------------");
    end;
    ---------------------------------------------------



    reaper.ShowActionList();

    if Arc.js_ReaScriptAPI(false) then;
        local winHWND = reaper.JS_Window_Find("Actions",true);
        if winHWND then;
            local filter_Act = reaper.JS_Window_FindChildByID(winHWND,1324);
            reaper.JS_Window_SetTitle(filter_Act,ScripnNameX);
            reaper.JS_Window_Move(winHWND,250,100);
            Window_Destroy();
        end;
    end;
    Arc.no_undo();