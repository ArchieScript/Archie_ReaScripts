--[[
   * Category:    Gui
   * Description: Show clock window
   * Author:      Archie
   * Version:     1.11
   * AboutScript: ---
   * О скрипте:   Показать окно часов
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1(Rmm)
   * Gave idea:   smrz1(Rmm)
   * Changelog:
   *              v.1.09 [23.06.2019]
   *                  +! Fixed bug (Use ruler time unit)

   *              v.1.08 [23.06.2019]
   *                  + Remove - close the clock by pressing Esc
   *              v.1.07 [22.06.2019]
   *                  + Add Font Size (Submenu)
   *              v.1.06 [21.06.2019]
   *                  + Remove focus from window (Submenu)
   *              v.1.05 [20.06.2019]
   *                  + Reset All (Submenu)
   *              v.1.04 [20.06.2019]
   *                  + Save position of last dock when move / removing focus from a window
   *              v.1.03 [19.06.2019]
   *                  No change
   *              v.1.02 [18.06.2019]
   *                  + Invert Color (Submenu)
   *              v.1.01 [17.06.2019]
   *                  + initialе


    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.978 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ---- / Default Color / ----
    local R_Text_Default = 150;
    local G_Text_Default = 150;
    local B_Text_Default = 150;

    local R_Back_Default =  50;
    local G_Back_Default =  50;
    local B_Back_Default =  50;
    ---------------------------

    local section;
    local PositionDock;
    local SaveDock,Dock_,T;
    local PosX,PosY,SizeW,SizeH,But;
    local ScriptNameOptFontSize = "Arc_Gui_Options; Font Size(Show clock window).lua"
    local scrPach = ({reaper.get_action_context()})[2]:match("(.+)[/\\]");
    ----------------------------------------------------------------------



    local function SetColorRGB(r,g,b,a,mode);
        gfx.set(r/256,g/256,b/256,a,mode);
    end;



    local function OpenWebSite(path);
        local OS,cmd = reaper.GetOS();
        if OS == "OSX32" or OS == "OSX64" then;
            os.execute('open "'..path..'"');
        else;
            os.execute('start "" '..path);
        end;
    end;



    function GetIDByScriptName(scriptName);
        if type(scriptName)~="string"then error("expects a 'string', got "..type(scriptName),2) end;
        local file = io.open(reaper.GetResourcePath()..'/reaper-kb.ini','r'); if not file then return -1 end;local
        scrName = scriptName:gsub('Script:%s+',''):gsub("[%%%[%]%(%)%*%+%-%.%?%^%$]",function(s)return"%"..s;end);
        for var in file:lines()do;if var:match('"Custom:%s-'..scrName..'"')then;
            return "_"..var:match(".-%s+.-%s+.-%s+(.-)%s"):gsub('"',""):gsub("'","");
    end;end;return -1;end;



    local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags);
        local gfx_w = gfx.w/100*w;
        local gfx_h = gfx.h/100*h;

        gfx.setfont(1,"Arial",10000);
        local lengthFontW,heightFontH = gfx.measurestr(string);

        local F_sizeW = gfx_w/lengthFontW*gfx.texth;
        local F_sizeH = gfx_h/heightFontH*gfx.texth;
        local F_size = math.min(F_sizeW+ZoomInOn,F_sizeH+ZoomInOn);
        if F_size < 1 then F_size = 1 end;
        gfx.setfont(1,"Arial",F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117

        local lengthFont,heightFont = gfx.measurestr(string);
        gfx.x = gfx.w/100*x + (gfx_w - lengthFont)/2;
        gfx.y = gfx.h/100*y + (gfx_h- heightFont )/2;
    end;



    local SaveDock,T;

    local function loop();

        local Toggle = GetSetToggleButtonOnOff(0,0);
        if Toggle <= 0 then;
            GetSetToggleButtonOnOff(1,1);
        end;
        ----


        local ZoomInOn = tonumber(reaper.GetExtState(section,"FontSize"))or 0;


        -----
        local Color_Text = reaper.GetExtState(section,"Color_Text");
        local R_Text,G_Text,B_Text = Color_Text:match("R(%d-)G(%d-)B(%d-)$");
        R_Text = tonumber(R_Text)or R_Text_Default;
        G_Text = tonumber(G_Text)or G_Text_Default;
        B_Text = tonumber(B_Text)or B_Text_Default;
        -----
        local Color_Background = reaper.GetExtState(section,"Color_Background");
        local R_Back,G_Back,B_Back = Color_Background:match("R(%d-)G(%d-)B(%d-)$");
        R_Back = tonumber(R_Back)or R_Back_Default;
        G_Back = tonumber(G_Back)or G_Back_Default;
        B_Back = tonumber(B_Back)or B_Back_Default;
        -----


        if R_Text==R_Back and G_Text==G_Back and B_Text==B_Back then;
            local x;
            if R_Text < 128 then x=15 else x=-15 end;
            R_Text=R_Text+x; G_Text=G_Text+x; B_Text=B_Text+x;
        end;
        ----


        ---- / background -|- Logo / ------------------
        gfx.gradrect(0,0,gfx.w,gfx.h,R_Back/256,G_Back/256,B_Back/256,1);

        if gfx.w > 200 or gfx.h > 42 then;

            gfx.x=0;
            gfx.y=0;
            local col = gfx.getpixel();
            if col > 0.5 then;
                gfx.set(0,0,0,0.2);
            else;
                gfx.set(1,1,1,0.2);
            end;
            gfx.setfont(1,"Arial",15,105);
            local len,hei = gfx.measurestr("Archie");
            gfx.x = gfx.w-len-5;
            gfx.y = gfx.h-hei;
            gfx.drawstr("Archie");
        end
        --------------------------


        SetColorRGB(R_Text,G_Text,B_Text,1);


        local FlickWinExState = tonumber(reaper.GetExtState(section,"FlickeringWindow"))or 1;


        ---- / Remove focus from window (useful when switching Screenset) / -----------
        local RemFocusWin = tonumber(reaper.GetExtState(section,"RemFocusWin"))or 0;
        if RemFocusWin == 1 then;
            --- / Снять фокус с окна / ---
            local winGuiFocus = gfx.getchar(65536)&2;
            if winGuiFocus ~= 0 then;
                if gfx.mouse_cap == 0 then;
                    local Context = reaper.GetCursorContext2(true);
                    reaper.SetCursorContext(Context,nil);
                    --t=(t or 0)+1;
                end;
            end;
        end;
        -------------------------------------------------------------------------------


        local BOLD;
        local TextBoldNorm = tonumber(reaper.GetExtState(section,"TextBoldNorm"))or 0;
        if TextBoldNorm == 1 then BOLD = 98 else BOLD = nil end;


        local ShowDisplayExtSt = reaper.GetExtState(section,"ShowDisplay");
        local showmenu, ShowDisplay, valuesDisplay = ShowDisplayExtSt:match("{(.-)}{(.-)}{(.-)}");
        showmenu      = tonumber(showmenu     );
        ShowDisplay   = tonumber(ShowDisplay  );
        valuesDisplay = tonumber(valuesDisplay);
        if not ShowDisplay then ShowDisplay = 1 valuesDisplay = 0 end;



        local Dock_ = gfx.dock(-1);
        if Dock_&1 ~= 0 and SaveDock ~= Dock_ then SaveDock = Dock_ end;


        if gfx.mouse_cap == 2 then;

            gfx.x = gfx.mouse_x;
            gfx.y = gfx.mouse_y;


            local checkedDock;
            local Dock = gfx.dock(-1);
            if Dock&1 ~= 0 then checkedDock = "!" else checkedDock = "" end;


            local checkFlick;
            if FlickWinExState == 1 then checkFlick = "!" else checkFlick = "" end;


            local checkColText,checkColBack,checkCol,checkColTextDefault,checkColBackDefault,checkColAllDefault;
            if R_Text == R_Text_Default and G_Text == G_Text_Default and B_Text == B_Text_Default then;
                checkColText = "" checkColTextDefault = "#" else checkColText = "!" checkColTextDefault = "";
            end;
            if R_Back == R_Back_Default and G_Back == G_Back_Default and B_Back == B_Back_Default then;
                checkColBack = "" checkColBackDefault = "#" else checkColBack = "!" checkColBackDefault = "";
            end;
            if checkColText == "!" or checkColBack == "!" then
                checkCol = "!" checkColAllDefault = "" else checkCol = "" checkColAllDefault = "#";
            end;


            local checkBold;
            if TextBoldNorm > 0 then checkBold = "!" else checkBold = "" end;


            local checkZoomInOn;
            if ZoomInOn ~= 0 then checkZoomInOn = "!" else checkZoomInOn = "" end;


            local checkRemFocWin;
            if RemFocusWin > 0 then checkRemFocWin = "!" else checkRemFocWin = "" end;


            if not T then;
                local showmenuT_ExtState = tonumber(reaper.GetExtState(section,"showmenu_T"))or 3;
                T = {[showmenuT_ExtState] = "!"};
            end;

            if showmenu and showmenu >= 2 and showmenu <= 10 then;
                T = {[showmenu] = "!"};
                if showmenu == 9 or showmenu == 10 then;
                   T[8.1] = "!";
                end;
                --t=(t or 0)+1;
            end;


            showmenu = gfx.showmenu(--[[ 1]]checkedDock.."Dock Big Clock in Docker||"..
                                    --[[ 2]](T[2] or "").."Use ruler time unit|".. -- -1
                                    --[[ 3]](T[3] or "").."Minutes : Seconds|"..   --  0
                                    --[[ 4]](T[4] or "").."Measures . Beats|"..    --  1
                                    --[[ 5]](T[5] or "").."Seconds|"..             --  3
                                    --[[ 6]](T[6] or "").."Samples|"..             --  4
                                    --[[ 7]](T[7] or "").."Hours: Minutes : Seconds : Frames|"..--5
                                    --[[ 8]](T[8] or "").."Absolute Frames|"..
                                    --[[ >]](T[8.1] or "")..">Beats (Visual Click)|"..
                                    --[[ 9]](T[9] or "").."Visual number|"..
                                    --[[10]](T[10] or "").."Fixed number||"..
                                    --[[11]]checkFlick.."<Flickering window||"..
                                    --[[->]]">View|"..
                                    --[[->]]checkCol..">Color|"..
                                    --[[12]]"Invert Color||"..
                                    --[[13]]checkColText.."Customize text color...|"..
                                    --[[14]]checkColTextDefault.."Default text color||"..
                                    --[[15]]checkColBack.."Customize background color|"..
                                    --[[16]]checkColBackDefault.."Default background color||"..
                                    --[[17]]checkColAllDefault.."<Default All color|"..
                                    --[[18]]checkBold.."Text: Normal / Bold|"..
                                    --[[19]]checkZoomInOn.."Font Size||"..
                                    --[[20]]checkRemFocWin.."Remove focus from window (useful when switching Screenset)||"..
                                    --[[21]]"<Reset All|"..
                                    --[[->]]">Support project|"..
                                    --[[22]]"Dodate||"..
                                    --[[23]]"Bug report (Of site forum)|"..
                                    --[[24]]"<Bug report (Rmm forum)||"..
                                    --[[25]]"Close clock window");

            if showmenu == 1 then;
                if Dock&1 ~= 0 then;
                    gfx.dock(0);
                    SaveDock = Dock;
                else;
                   if math.fmod(PositionDock,2) == 0 then PositionDock = 2049 end;
                   gfx.dock(SaveDock or PositionDock);
                end;
            elseif showmenu ==  2 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = -1;
                ----
            elseif showmenu == 3 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 0;
                ----
            elseif showmenu == 4 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 2;
                ----
            elseif showmenu == 5 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 3;
                ----
            elseif showmenu == 6 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 4;
                ----
            elseif showmenu == 7 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 5;
                ----
            elseif showmenu == 8 then;
                ----
                ShowDisplay = 1;
                valuesDisplay = 8;
                ----
            elseif showmenu == 9 then;
                ----
                ShowDisplay = 3;
                ----
            elseif showmenu == 10 then;
                ----
                ShowDisplay = 4;
                ----
            elseif showmenu == 11 then;
                ----
                local val;
                if FlickWinExState == 1 then val = 0 else val = 1 end;
                reaper.SetExtState(section,"FlickeringWindow",val,true);
                ----
            elseif showmenu == 12 then;
                ----
                local r,g,b = R_Back, G_Back, B_Back;
                reaper.SetExtState(section,"Color_Text","R"..r.."G"..g.."B"..b,true);
                local r,g,b = R_Text, G_Text, B_Text;
                reaper.SetExtState(section,"Color_Background","R"..r.."G"..g.."B"..b,true);
                ----
            elseif showmenu == 13 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Text","R"..r.."G"..g.."B"..b,true);
                end;
                ----
            elseif showmenu == 14 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                ----
            elseif showmenu == 15 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Background","R"..r.."G"..g.."B"..b,true);
                end;
                ----
            elseif showmenu == 16 then;
                ----
                reaper.DeleteExtState(section,"Color_Background",true);
                ----
            elseif showmenu == 17 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                reaper.DeleteExtState(section,"Color_Background",true);
                ----
            elseif showmenu == 18 then;
                ----
                local val;
                if TextBoldNorm == 1 then val = 0 else val = 1 end;
                reaper.SetExtState(section,"TextBoldNorm",val,true);
                ----
            elseif showmenu == 19 then;
                ----
                local file = io.open(scrPach.."/"..ScriptNameOptFontSize,'r');
                if not file then;
                    file = io.open(scrPach.."/"..ScriptNameOptFontSize,'w');
                    file:close();
                    file = io.open(({reaper.get_action_context()})[2],'r');
                    ----
                    local text = file:read('a');file:close();
                    local Write = text:match("%s-function MainTextSize%(%).-local EndMainTextSize;");

                    local new_file = io.open(scrPach.."/"..ScriptNameOptFontSize,'w');
                    new_file:write("\n\n\n\n\n\n"..Write.."\n    MainTextSize()");
                    new_file:close();
                    reaper.AddRemoveReaScript(true,0,scrPach.."/"..ScriptNameOptFontSize,true);
                else;
                    file:close();
                end;

                local x, y = reaper.GetMousePosition();
                reaper.SetExtState(section,"Opt_FontSizeWinPosition","{"..x .."}{"..y .."}",true);
                local IDByScriptName = GetIDByScriptName(ScriptNameOptFontSize);
                if IDByScriptName == -1 then;
                    reaper.AddRemoveReaScript(true,0,scrPach.."/"..ScriptNameOptFontSize,true);
                    IDByScriptName = GetIDByScriptName(ScriptNameOptFontSize);
                end;
                reaper.Main_OnCommand(reaper.NamedCommandLookup(IDByScriptName),0);
                ----
            elseif showmenu == 20 then;
                ----
                local val;
                if RemFocusWin == 1 then val = 0 else val = 1 end;
                reaper.SetExtState(section,"RemFocusWin",val,true);
                ----
            elseif showmenu == 21 then;
                ----
                reaper.DeleteExtState(section, "Color_Text"      ,true);
                reaper.DeleteExtState(section, "Color_Background",true);
                reaper.DeleteExtState(section, "ShowDisplay"     ,true);
                reaper.DeleteExtState(section, "TextBoldNorm"    ,true);
                reaper.DeleteExtState(section, "showmenu_T"      ,true);
                reaper.DeleteExtState(section, "PositionDock"    ,true);
                reaper.DeleteExtState(section, "PositionWind"    ,true);
                reaper.DeleteExtState(section, "SizeWindow"      ,true);
                reaper.DeleteExtState(section, "SaveDock"        ,true);
                reaper.DeleteExtState(section, "RemFocusWin"     ,true);
                ---19---
                reaper.DeleteExtState(section, "Opt_FontSizeWinPosition",true);
                reaper.DeleteExtState(section, "FontSize",true);
                local file = io.open(scrPach.."/"..ScriptNameOptFontSize,'r');
                if file then;
                    file:close();
                    reaper.AddRemoveReaScript(false,0,scrPach.."/"..ScriptNameOptFontSize,true);
                    os.remove(scrPach.."/"..ScriptNameOptFontSize);
                end;
                -------
                gfx.quit();
                local PachScr = ({reaper.get_action_context()})[2];
                dofile(PachScr);
                do return end;
                ----
            elseif showmenu == 22 then;
                ----
                local path = "https://money.yandex.ru/to/410018003906628";
                OpenWebSite(path);
                reaper.ClearConsole();
                reaper.ShowConsoleMsg("Yandex-money - "..path.."\n\nWebManey - R159026189824");
                ----
            elseif showmenu == 23 then;
                ----
                local path = "https://forum.cockos.com/showthread.php?t=212819";
                OpenWebSite(path);
                ----
            elseif showmenu == 24 then;
                ----
                local path = "https://rmmedia.ru/threads/134701/";
                OpenWebSite(path);
                ----
            elseif showmenu == 25 then;
                ----
                exit();
                ----
            end;--EndShowmenu

            if showmenu > 0 then;
                local val = '{'..(showmenu or "")..'}{'..(ShowDisplay or "")..'}{'..(valuesDisplay or "")..'}';
                reaper.SetExtState(section,"ShowDisplay",val,true);
                if showmenu >= 2 and showmenu <= 10 then;
                    reaper.SetExtState(section,"showmenu_T",showmenu,true);
                end;
            end;
        end;--End_gfx.mouse_cap == 2;
        ------------



        local Position;
        local PlayState = reaper.GetPlayState();
        if PlayState == 0 or PlayState == 2 then;
            Position = reaper.GetCursorPosition();
        else;
            Position = reaper.GetPlayPosition();
        end;



        local buf;
        if ShowDisplay == 1 then;
            ----
            buf = reaper.format_timestr_pos(Position,"",valuesDisplay);
            TextByCenterAndResize(buf,0,0,100,100,ZoomInOn,BOLD);
            ----
            ----
        elseif ShowDisplay == 3 or ShowDisplay == 4 then;
            ----
            buf = reaper.format_timestr_pos(Position,"",2):match("%d-%.(%d-)%.");--Beats (Visual Click)
            if math.fmod(buf,2) == 0 then;
                if FlickWinExState == 1 then;
                    -- /color changing in places/--
                    gfx.gradrect(0,0,gfx.w,gfx.h,R_Text/256,G_Text/256,B_Text/256,1);
                    SetColorRGB(R_Back,G_Back,B_Back,1);
                    ------------------------------------
                end;
            end;

            if ShowDisplay == 3 then;
                local _, bpi = reaper.GetProjectTimeSignature2(0);
                local Bpi = 100 / bpi;
                TextByCenterAndResize(buf,Bpi*(buf-1),0,Bpi,100,ZoomInOn,BOLD);
            elseif ShowDisplay == 4 then;
                TextByCenterAndResize(buf,0,0,100,100,ZoomInOn,BOLD);
            end;
            ----
        end;
        ----

        gfx.drawstr(buf);
        -----------------

        --gfx.update();
        ---------------


        local char = gfx.getchar();
        if char >= 0 --[[and char ~= 27]] then;
            reaper.defer(loop);
        else;
            reaper.atexit(exit);
        end;
    end;--End_loop



    function GetSetToggleButtonOnOff(numb,set);
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        if set == 0 or set == false then;
            return reaper.GetToggleCommandStateEx(sec,cmd);
        else;
            reaper.SetToggleCommandState(sec,cmd,numb or 0);
            reaper.RefreshToolbar2(sec,cmd);
        end
    end;



    function exit();
        GetSetToggleButtonOnOff(0,1);
        local PosDock,PosX,PosY,PosW,PosH = gfx.dock(-1,-1,-1,-1,-1);
        reaper.SetExtState(section,"PositionDock",PosDock,true);
        reaper.SetExtState(section,"PositionWind",PosX.."&"..PosY,true);
        reaper.SetExtState(section,"SizeWindow",PosW.."&"..PosH,true);
        reaper.SetExtState(section,"SaveDock",SaveDock or "NULL",true);
        gfx.quit();
    end;




    section = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    PositionDock = tonumber(reaper.GetExtState(section,"PositionDock"))or 0;
    PosX,PosY = reaper.GetExtState(section,"PositionWind"):match("(.-)&(.-)$");
    SizeW,SizeH = reaper.GetExtState(section,"SizeWindow"):match("(.-)&(.-)$");
    SaveDock = tonumber(reaper.GetExtState(section,"SaveDock"));
    ---

    gfx.init("Show clock window",SizeW or 180,SizeH or 50,PositionDock,PosX or 150,PosY or 100);


    loop();
    reaper.atexit(exit);





    --=========================================================================================
    --=========================================================================================
    --=========================================================================================


    function MainTextSize();

        local ScriptNameMain = "Archie_Gui; Show clock window.lua";

        function GetIDByScriptName(scriptName);
            if type(scriptName)~="string"then error("expects a 'string', got "..type(scriptName),2) end;
            local file = io.open(reaper.GetResourcePath()..'/reaper-kb.ini','r'); if not file then return -1 end;local
            scrName = scriptName:gsub('Script:%s+',''):gsub("[%%%[%]%(%)%*%+%-%.%?%^%$]",function(s)return"%"..s;end);
            for var in file:lines()do;if var:match('"Custom:%s-'..scrName..'"')then;
                return "_"..var:match(".-%s+.-%s+.-%s+(.-)%s"):gsub('"',""):gsub("'","");
        end;end;return -1;end;



        local IDByScriptName = GetIDByScriptName(ScriptNameMain);
        if IDByScriptName == -1 then;
            reaper.AddRemoveReaScript(false,0,({reaper.get_action_context()})[2],true);
            os.remove(({reaper.get_action_context()})[2]);
        end;
        local Toggle = reaper.GetToggleCommandState(reaper.NamedCommandLookup(IDByScriptName));
        if Toggle ~= 1 then return end;



        local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags);
            local gfx_w = gfx.w/100*w;
            local gfx_h = gfx.h/100*h;

            gfx.setfont(1,"Arial",10000);
            local lengthFontW,heightFontH = gfx.measurestr(string);

            local F_sizeW = gfx_w/lengthFontW*gfx.texth;
            local F_sizeH = gfx_h/heightFontH*gfx.texth;
            local F_size = math.min(F_sizeW+ZoomInOn,F_sizeH+ZoomInOn);
            if F_size < 1 then F_size = 1 end;
            gfx.setfont(1,"Arial",F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117

            local lengthFont,heightFont = gfx.measurestr(string);
            gfx.x = gfx.w/100*x + (gfx_w - lengthFont)/2;
            gfx.y = gfx.h/100*y + (gfx_h- heightFont )/2;
        end;


        -----
        local function Mouse_Is_Inside(x, y, w, h) --мышь находится внутри
        local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y
        local inside =
        mouse_x >= x and mouse_x < (x + w) and
        mouse_y >= y and mouse_y < (y + h)
        return inside
        end



        local mouse_btn_down,fake,lamp = {},{},{}
        local function LeftMouseButton(x, y, w, h,numbuf)
        if Mouse_Is_Inside(x, y, w, h) then;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 and lamp[numbuf] ~= 0 then mouse_btn_down[numbuf] = 0 end;
            if gfx.mouse_cap&1 == 1 and fake[numbuf]==1 then mouse_btn_down[numbuf]=1 lamp[numbuf]=0; end;
            if mouse_btn_down[numbuf] == 2 then mouse_btn_down[numbuf] = -1 end;
            if gfx.mouse_cap&1 == 0 and fake[numbuf] == 1 and mouse_btn_down[numbuf] == 1 then;
                mouse_btn_down[numbuf] = 2 lamp[numbuf] = nil;
            end;
        else
            mouse_btn_down[numbuf] = -1 lamp[numbuf]=nil;
            if gfx.mouse_cap&1 == 1 and fake[numbuf] == 1 then mouse_btn_down[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = nil end;
        end
        return mouse_btn_down[numbuf];
        end
        ----=================================================================



        local Opt_FontSizeWinPosition = reaper.GetExtState(ScriptNameMain,"Opt_FontSizeWinPosition");
        local X,Y = Opt_FontSizeWinPosition:match("{(.-)}{(.-)}$");

        gfx.init("Font Size",190,50,0,X-(190/2),Y-(50/2));
        local FontSize = tonumber(reaper.GetExtState(ScriptNameMain,"FontSize"))or 0;

        local function loopFontSize();

            if FontSize <= -99 then FontSize = -99 elseif FontSize >= 99 then FontSize = 99 end;

            local winGuiFocus = gfx.getchar(65536)&2;
            if winGuiFocus ~= 2 then;
                gfx.quit();return;
            end;

            local Toggle = reaper.GetToggleCommandState(reaper.NamedCommandLookup(IDByScriptName));
            if Toggle ~= 1 then gfx.quit();return end;

            gfx.gradrect(0,0,gfx.w,gfx.h,0.55,0.55,0.55,1);

            gfx.set(.9,.9,.9);
            TextByCenterAndResize("-",0,0,20,100,0,nil); gfx.drawstr("-");
            TextByCenterAndResize("Reset",25,0,50,100,0,nil); gfx.drawstr("Reset");
            TextByCenterAndResize("+",80,0,20,100,0,nil); gfx.drawstr("+");

            gfx.set(.65,.65,.65);
            gfx.line(gfx.w/100*20, 0, gfx.w/100*20, gfx.h);
            gfx.line(gfx.w/100*80, 0, gfx.w/100*80, gfx.h);


            local ButMin = LeftMouseButton(0,0,gfx.w/100*20,gfx.h,"minus");
            if ButMin == 0 then;
                gfx.set(.8,.8,.8);
            elseif ButMin == 1 then;
                gfx.set(.3,.3,.3);
                TextByCenterAndResize("-",0,0,20,100,0,nil); gfx.drawstr("-");
                TextByCenterAndResize("Ctrl",5,0,10,40,0,nil); gfx.drawstr("Ctrl");
            end;
            if ButMin == 0 or ButMin == 1 or ButMin == 2 then;
                gfx.roundrect(0,0,gfx.w/100*20,gfx.h-1,0,0);
                gfx.roundrect(3,3,gfx.w/100*20-6,gfx.h-1-6,0);
                if gfx.mouse_cap&5==5 then;ButMin = 2 end;
            end;


            local ButReset = LeftMouseButton(gfx.w/100*20,0,gfx.w/100*60,gfx.h,"Reset");
            if ButReset == 0 then;
                gfx.set(.8,.8,.8);
            elseif ButReset == 1 then;
                gfx.set(.3,.3,.3);
                TextByCenterAndResize("Reset",25,0,50,100,0,nil); gfx.drawstr("Reset");
            end;
            if ButReset == 0 or ButReset == 1 then;
                gfx.roundrect(gfx.w/100*20,0,gfx.w/100*60,gfx.h-1,0,0);
                gfx.roundrect(gfx.w/100*20+3,3,gfx.w/100*60-6,gfx.h-1-6,0);
            end;


            local ButPlus = LeftMouseButton(gfx.w/100*80,0,gfx.w,gfx.h,"Plus");
            if ButPlus == 0 then;
                gfx.set(.8,.8,.8);
            elseif ButPlus == 1 then;
                gfx.set(.3,.3,.3);
                TextByCenterAndResize("+",80,0,20,100,0,nil);gfx.drawstr("+");
                TextByCenterAndResize("Ctrl",85,0,10,40,0,nil);gfx.drawstr("Ctrl");
            end;
            if ButPlus == 0 or ButPlus == 1 or ButPlus == 2 then;
                gfx.roundrect(gfx.w/100*80,0,gfx.w/100*20,gfx.h-1 ,0,0);
                gfx.roundrect(gfx.w/100*80+3,3,gfx.w/100*20-6,gfx.h-1-6,0);
                if gfx.mouse_cap&5==5 then;ButPlus = 2 end;
            end;


            if ButMin == 2 then;
                FontSize = (FontSize or 0)-1;
                reaper.SetExtState(ScriptNameMain,"FontSize",FontSize,true);
            end;
            if ButReset == 2 then;
               reaper.DeleteExtState(ScriptNameMain,"FontSize",true);
               FontSize = 0;
            end;
            if ButPlus == 2 then;
                FontSize = (FontSize or 0)+1;
                reaper.SetExtState(ScriptNameMain,"FontSize",FontSize,true);
            end;

            if gfx.getchar() >= 0 then;
                reaper.defer(loopFontSize);
            else;
                reaper.atexit(loopFontSize);
                return;
            end;
            --t=(t or 0)+1;
        end;
        -----
        loopFontSize();
    end; local EndMainTextSize;
    --=========================================================================================
    --=========================================================================================
    --=========================================================================================