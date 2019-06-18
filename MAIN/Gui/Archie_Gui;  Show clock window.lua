--[[
   * Category:    Gui
   * Description: Show clock window
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Показать окно часов
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(Rmm)
   * Gave idea:   smrz1(Rmm)
   * Changelog:   
   *              v.1.02 [18.16.2019]
   *                  + Invert Color
   
   *              v.1.01 [17.16.2019]
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
    local PosX,PosY,SizeW,SizeH;
    ----------------------------
    
    
    
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
    
    
    
    local function TextByCenterAndResize(string,x,y,w,h,flags);
        local gfx_w = gfx.w/100*w;
        local gfx_h = gfx.h/100*h;
        
        gfx.setfont(1,"Arial",10000);
        local lengthFontW,heightFontH = gfx.measurestr(string);
        
        local F_sizeW = gfx_w/lengthFontW*gfx.texth;
        local F_sizeH = gfx_h/heightFontH*gfx.texth;
        local F_size = math.min(F_sizeW,F_sizeH);
        gfx.setfont(1,"Arial",F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117
        
        local lengthFont,heightFont = gfx.measurestr(string);
        gfx.x = gfx.w/100*x + (gfx_w - lengthFont)/2; 
        gfx.y = gfx.h/100*y + (gfx_h- heightFont )/2;
    end; 
    
    
    
    local SaveDock,T;
    
    local function loop();
        
        local Toggle = GetSetToggleButtonOnOff(0,0);
        if Toggle == 0 then;
            GetSetToggleButtonOnOff(1,1);
        end;
        ----
        
        
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
        
        local BOLD;
        local TextBoldNorm = tonumber(reaper.GetExtState(section,"TextBoldNorm"))or 0;
        if TextBoldNorm == 1 then BOLD = 98 else BOLD = nil end;
        
        
        local ShowDisplayExtSt = reaper.GetExtState(section,"ShowDisplay");
        local showmenu, ShowDisplay, valuesDisplay = ShowDisplayExtSt:match("{(.-)}{(.-)}{(.-)}");
        showmenu      = tonumber(showmenu     );
        ShowDisplay   = tonumber(ShowDisplay  );
        valuesDisplay = tonumber(valuesDisplay);
        if not ShowDisplay then ShowDisplay = 1 valuesDisplay = 0 end;
        
        
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
            
            
            if not T then;
                local showmenuT_ExtState = tonumber(reaper.GetExtState(section,"showmenu_T"))or 3;
                T = {[showmenuT_ExtState] = "!"};
            end;
            
            if showmenu and showmenu >= 2 and showmenu <= 10 then;
                T = {[showmenu] = "!"};
                if showmenu == 9 or showmenu == 10 then;
                   T[8.1] = "!";
                end;
                --t=(t or 0)+ 1;
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
                                    --[[->]]checkCol..">Color|"..
                                    --[[12]]"Invert Color||"..
                                    --[[13]]checkColText.."Customize text color...|"..
                                    --[[14]]checkColTextDefault.."Default text color||"..
                                    --[[15]]checkColBack.."Customize background color|"..
                                    --[[16]]checkColBackDefault.."Default background color||"..
                                    --[[17]]checkColAllDefault.."<Default All color||"..
                                    --[[18]]checkBold.."Text: Normal / Bold||"..
                                    --[[->]]">Archie|"..
                                    --[[19]]"Dodate||"..
                                    --[[20]]"Bug report (Of site forum)|"..
                                    --[[21]]"<Bug report (Rmm forum)||"..
                                    --[[22]]"Close clock window");
            
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
                valuesDisplay = 1;
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
                ShowDisplay = 2;
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
                local path = "https://money.yandex.ru/to/410018003906628";
                OpenWebSite(path);
                reaper.ClearConsole();
                reaper.ShowConsoleMsg("Yandex-money - "..path.."\n\nWebManey - R159026189824");
                ----
            elseif showmenu == 20 then;
                ----
                local path = "https://forum.cockos.com/showthread.php?t=212819";
                OpenWebSite(path);
                ----
            elseif showmenu == 21 then;
                ----
                local path = "https://rmmedia.ru/threads/134701/";
                OpenWebSite(path);
                ----
            elseif showmenu == 22 then;
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
            TextByCenterAndResize(buf,0,0,100,100,BOLD);
            ----
        elseif ShowDisplay == 2 then;
            ----
            buf = math.floor(Position/0.0333333333);--Absolute Frames
            TextByCenterAndResize(buf,0,0,100,100,BOLD);
            ----
        elseif ShowDisplay == 3 or ShowDisplay == 4 then;
            ----
            buf = reaper.format_timestr_pos(Position,"",-1):match("%d-%.(%d-)%.");--Beats (Visual Click)
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
                TextByCenterAndResize(buf,Bpi*(buf-1),0,Bpi,100,BOLD);
            elseif ShowDisplay == 4 then;
                TextByCenterAndResize(buf,0,0,100,100,BOLD);  
            end;
            ----
        end;
        ----
        
        gfx.drawstr(buf);
        -----------------
        
        --gfx.update();
        ---------------
        
        local char = gfx.getchar();
        if char >= 0 and char ~= 27 then;
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
        gfx.quit();
    end;
    
    
    
    
    section = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    PositionDock = tonumber(reaper.GetExtState(section,"PositionDock"))or 0;
    PosX,PosY = reaper.GetExtState(section,"PositionWind"):match("(.-)&(.-)$");
    SizeW,SizeH = reaper.GetExtState(section,"SizeWindow"):match("(.-)&(.-)$");
    ---
    
    gfx.init("Show clock window",SizeW or 200,SizeH or 50,PositionDock,PosX or 150,PosY or 100);
    
    
    loop();
    reaper.atexit(exit);