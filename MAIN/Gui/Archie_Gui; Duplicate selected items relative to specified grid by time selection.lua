--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Gui
   * Description: Duplicate selected items relative to specified grid by time selection
   * Author:      Archie
   * Version:     1.01
   * AboutScript: ---
   * О скрипте:   Дублирование выбранных элементов относительно указанной сетки по выбору времени
   * GIF:         http://avatars.mds.yandex.net/get-pdb/1940639/407b51a7-64ba-4013-93a4-a557e83afa5e/orig
   *              http://avatars.mds.yandex.net/get-pdb/1551693/90819dd6-1667-4601-aab2-7fc42e935eca/orig
   *
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *
   * Donation:    http://money.yandex.ru/to/410018003906628
   *
   * Customer:    Krikets(Rmm)
   * Gave idea:   Krikets(Rmm)
   * Changelog:   v.1.01 [09.07.2019]
   *                  + initialе
    
    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.975 +            --| http://www.reaper.fm/download.php
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
    local R_Back_Default =  50;
    local G_Back_Default =  50;
    local B_Back_Default =  50;
    
    local R_Text_Default = 150;
    local G_Text_Default = 150;
    local B_Text_Default = 150;
    
    local R_Gui__Default = 90;
    local G_Gui__Default = 90;
    local B_Gui__Default = 90;
    ---------------------------
    
    
    
    ----/ Конвертируем в проценты /----
    local function W(w);
        return (gfx.w/100*w);
    end;
    local X = W;
    local function H(h);
        return (gfx.h/100*h);
    end;
    local Y = H;
    -----------------------------------
    
    
    
    -------------------------------------------
    local function OpenWebSite(path);
        local OS,cmd = reaper.GetOS();
        if OS == "OSX32" or OS == "OSX64" then;
            os.execute('open "'..path..'"');
        else;
            os.execute('start "" '..path);
        end;
    end;
    -------------------------------------------
    
    
    
    -----------------------------------------
    local function SetColorRGB(r,g,b,a,mode);
        gfx.set(r/256,g/256,b/256,a,mode); 
    end;
    -----------------------------------------
    
    
    
    local function gfxSaveScrin_buf( buf,w,h);   
        gfx.dest = buf;
        gfx.setimgdim(buf, -1, -1);  
        gfx.setimgdim(buf, w, h);  
        gfx.a = 1;
    end;
    ---
      
    local function gfxRestScrin_buf(buf,x,y,w,h);
        gfx.dest = -1;
        gfx.a = 1;
        gfx.blit(buf,1,0, x,y,w,h,x,y,w,h,0,0);
    end;
    
    
    ----------------------------------------------------------------------
    local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags,r,g,b);
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
        -------
        local r2,g2,b2,a2 = gfx.r, gfx.g, gfx.b, gfx.a2;
        gfx.set(r/256,g/256,b/256,1);
        gfx.drawstr(string);
        gfx.set(r2,g2,b2,a2);
    end;
    ----------------------------------------------------------------------
    
    
    
    ---/ Клик мыши /------------------------------------------------------
    local function Mouse_Is_Inside(x, y, w, h); --мышь находится внутри
        local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y;
        local inside =
        mouse_x >= x and mouse_x < (x + w) and
        mouse_y >= y and mouse_y < (y + h);
        return inside;
    end;
    ----
    local mouse_btn_down,fake,lamp = {},{},{};
    local function LeftMouseButton(x, y, w, h,numbuf);
        if Mouse_Is_Inside(x, y, w, h) then;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 and lamp[numbuf] ~= 0 then mouse_btn_down[numbuf] = 0 end;
            if gfx.mouse_cap&1 == 1 and fake[numbuf]==1 then mouse_btn_down[numbuf]=1 lamp[numbuf]=0; end; 
            if mouse_btn_down[numbuf] == 2 then mouse_btn_down[numbuf] = -1 end;
            if gfx.mouse_cap&1 == 0 and fake[numbuf] == 1 and mouse_btn_down[numbuf] == 1 then;
                mouse_btn_down[numbuf] = 2 lamp[numbuf] = nil;
            end;
        else;
            mouse_btn_down[numbuf] = -1 lamp[numbuf]=nil;
            if gfx.mouse_cap&1 == 1 and fake[numbuf] == 1 then mouse_btn_down[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = nil end;
        end; 
        return mouse_btn_down[numbuf];
    end;
    ----------------------------------------------------------------------
    
    
    
    local section = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    reaper.SetToggleCommandState(sectionID,cmdID,1);
    reaper.DockWindowRefresh();
    
    
    local PositionDock = tonumber(reaper.GetExtState(section,"PositionDock"))or 0;
    local PosX,PosY = reaper.GetExtState(section,"PositionWind"):match("(.-)&(.-)$");
    local SizeW,SizeH = reaper.GetExtState(section,"SizeWindow"):match("(.-)&(.-)$");
    local SaveDock = tonumber(reaper.GetExtState(section,"SaveDock"));
    -----
    
    
    -----
    local Color_Text = reaper.GetExtState(section,"Color_Text");
    local R_Text,G_Text,B_Text = Color_Text:match("R(%d-)G(%d-)B(%d-)$");
    R_Text = tonumber(R_Text)or R_Text_Default;
    G_Text = tonumber(G_Text)or G_Text_Default;
    B_Text = tonumber(B_Text)or B_Text_Default;
    -----
    
    -----
    local Color_Background = reaper.GetExtState(section,"Color_Background");
    local R_Back,G_Back,B_Back = Color_Background:match("R(%d-)G(%d-)B(%d-)$");
    R_Back = tonumber(R_Back)or R_Back_Default;
    G_Back = tonumber(G_Back)or G_Back_Default;
    B_Back = tonumber(B_Back)or B_Back_Default;
    -----
    
    -----
    local Color_Gui = reaper.GetExtState(section,"Color_Gui");
    local R_Gui,G_Gui,B_Gui = Color_Gui:match("R(%d-)G(%d-)B(%d-)$");
    R_Gui = tonumber(R_Gui)or R_Gui__Default;
    G_Gui = tonumber(G_Gui)or G_Gui__Default;
    B_Gui = tonumber(B_Gui)or B_Gui__Default;
    -----
    
    
    -----
    local TextBoldNorm = tonumber(reaper.GetExtState(section,"TextBoldNorm"));
    -----
    
    
    -----
    local FontSize = tonumber(reaper.GetExtState(section,"FontSize"))or 0;
    -----
    
    
    -----
    local SELECTION = tonumber(reaper.GetExtState(section,"SELECTION"))or 0;
    -----
    
    
    -----
    local COPY_MOVE = tonumber(reaper.GetExtState(section,"COPY_MOVE"))or 1;
    -----
    
    
    -----
    local Triplet = tonumber(reaper.GetExtState(section,"Triplet"))or 0;
    -----
    
    
    ---- / Remove focus from window (useful when switching Screenset) / -----------
    local RemFocusWin = tonumber(reaper.GetExtState(section,"RemFocusWin"))or 0;
    local function RemoveFocusWindow(RemFocusWin);
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
    end;
    -------------------------------------------------------------------------------
    
    local title = "Duplicate selected item relative to specified grid by time selection"
    gfx.init(title,SizeW or 700,SizeH or 37,PositionDock,PosX or 350,PosY or 100);
    
    
    
    ---- / Рисуем основу / ----
    local function Start_GUI();
        
        
        gfxSaveScrin_buf(1,gfx.w,gfx.h); 
        
        gfx.gradrect(0,0,gfx.w,gfx.h,R_Back/256,G_Back/256,B_Back/256,1);--background
        
        
        SetColorRGB(R_Text,G_Text,B_Text,1);
        gfx.line(X(0.5),Y(35),W(1.5),H(50),1);
        gfx.line(X(0.5),Y(65),W(1.5),H(50),1);
        
        SetColorRGB(R_Gui,G_Gui,B_Gui,1);
        
        gfx.line(X(2),Y(0),W(2),H(100),1);
        
        gfx.roundrect(X(4), Y(0), W(5), H(100), 0);
        TextByCenterAndResize("4",5,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(9), Y(0), W(5),H(100),0);
        TextByCenterAndResize("2",10,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(14), Y(0), W(5), H(100),0);
        TextByCenterAndResize("1",15,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(19),Y(0), W(9),H(100),0);
        TextByCenterAndResize("1/2",20,0, 7, 100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(28), Y(0), W(9), H(100),0);
        TextByCenterAndResize("1/4",29,0, 7,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(37), Y(0), W(9), H(100),0);
        TextByCenterAndResize("1/8",38,0, 7,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(46),Y(0), W(12),H(100),0);
        TextByCenterAndResize("1/16",47,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(58),Y(0), W(12),H(100),0);
        TextByCenterAndResize("1/32",59,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(70),Y(0), W(12),H(100),0);
        TextByCenterAndResize("1/64",71,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        gfx.roundrect(X(82),Y(0), W(15),H(100),0);
        TextByCenterAndResize("1/128",83,0, 13,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        
        
        
        if Triplet == 1 then;
            SetColorRGB(R_Text,G_Text,B_Text,1);
            gfx.rect( X(97), Y(0), W(3.1), H(100));
            TextByCenterAndResize("T",97.5,0, 2,100,FontSize,TextBoldNorm,R_Back,G_Back,B_Back);
        else;
            gfx.roundrect(X(97),Y(0), W(3),H(100),0);
            TextByCenterAndResize("T",97.5,0, 2,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        end;
         
        gfxRestScrin_buf(1,0,0,gfx.w,gfx.h);
        -- BODY --   Рисуем основу
    end;
    
    
    Start_GUI();
   
    
    
    ---------
    local checked_Toggle,Start_W,Start_H,LastClickForPreset;
    function loop();
    
        ----/Проверить тоггле(полезно для автозагрузки)/----
        if not checked_Toggle then;
            local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
            if Toggle <= 0 then;
                reaper.SetToggleCommandState(sectionID,cmdID,1);
                reaper.DockWindowRefresh();
            end;
            checked_Toggle = true;
        end;
        ----/Перерисовать основу при изменении размера окна/----
        if Start_W ~= gfx.w or Start_H ~= gfx.h then;
            Start_GUI();
            Start_W = gfx.w;
            Start_H = gfx.h;
        end;
        ----/ Удалить Фокус с Окна /----
        RemoveFocusWindow(RemFocusWin);
        --------------------------------------------------------
        
        
                
        --body-- / Рисуем функциональность (горящие кнопочки и т.д.)
        gfxRestScrin_buf(1,0,0,gfx.w,gfx.h);
        SetColorRGB(R_Gui,G_Gui,B_Gui,1--[[0.5]]);
        
        
        -- Preset --
        local LeftMousBut_LeftMenu = LeftMouseButton(X(0),Y(0),W(2),H(100),"LeftMenu_>1");
        if LeftMousBut_LeftMenu == 0 then;
            gfx.rect(X(0), Y(0), W(2), H(100));
            SetColorRGB(R_Text,G_Text,B_Text,1);
            gfx.line(X(0.5),Y(35),W(1.5),H(50),1);
            gfx.line(X(0.5),Y(65),W(1.5),H(50),1);
        elseif LeftMousBut_LeftMenu == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(0), Y(0), W(2), H(100));
            SetColorRGB(R_Text,G_Text,B_Text,1);
            gfx.line(X(0.3),Y(40),W(1),H(65),1);
            gfx.line(X(1.7),Y(40),W(1),H(65),1);
        elseif LeftMousBut_LeftMenu == 2 then;
            --gfx.mouse_cap = 2;
            ------------
            local List;
            local Preset = reaper.GetExtState(section,"Preset");
            for var in string.gmatch(Preset, "{{(.-)}{.-}{.-}{.-}}") do;
                List = (List or "").."|"..var;
            end;
            if not List then List = "" end;
            gfx.x = gfx.mouse_x;
            gfx.y = gfx.mouse_y;
            local
            showmenuPreset = gfx.showmenu(--[[ 0]]">Preset - Save / Remove|"..
                                          --[[ 1]]"Save|"..
                                          --[[ 2]]"Remove||"..
                                          --[[ 3]]"<Remove All list|"..
                                                  List);
            if showmenuPreset == 1 then; --Save
                
                local Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
                if Start == End then;
                    reaper.MB("No Time Selection","ERROR",0);
                else;
                    
                    ::restartNamePreset::
                    local retval, saveNamePres = reaper.GetUserInputs("Save Preset",1,"Enter Name Preset:,extrawidth=200 ","");
                    saveNamePres = saveNamePres:gsub("[{}]","");
                    if retval and #saveNamePres > 0 then;
                        --local Preset = reaper.GetExtState(section,"Preset");
                        for var in string.gmatch(Preset, "{{(.-)}{.-}{.-}{.-}}") do;
                            if var == saveNamePres then;
                                reaper.MB("End:\nThis Name already exists\n\nRus:\nТакое Имя уже существует","ERROR",0);
                                goto restartNamePreset;
                            end;
                        end;
                        local retval,saveGridPres = reaper.GetUserInputs("Save Preset",1,"Enter value relative grid: 1/4...",LastClickForPreset or"1/4");
                        if retval then;
                            saveGridPres = load("return "..saveGridPres)();
                            if type(saveGridPres)== "number" then;
                                local Pres = Preset.."{{"..saveNamePres.."}".."{"..saveGridPres.."}".."{"..Start.."}".."{"..End.."}}"
                                reaper.SetExtState(section,"Preset",Pres,true);
                            end;
                        end;
                    end;
                end;       
                
            elseif showmenuPreset == 2 then; --Remove
                -----
                local x, y = reaper.GetMousePosition();
                local _,pos_x, pos_y = gfx.dock(-1,-1,-1,-1,-1);
                gfx.x = (x-pos_x)-80;
                gfx.y = (y-pos_y)-50;
                local
                showmenuRemovePreset = gfx.showmenu(List:match("[^|].-$"));
                
                if showmenuRemovePreset > 0 then;
                    
                    local v,StrPreset;
                    for var in string.gmatch(Preset, "{{.-}{.-}{.-}{.-}}") do;
                        v = (v or 0)+1;
                        if v == showmenuRemovePreset then;
                            var = "";
                        end;
                        StrPreset = (StrPreset or "")..var;
                    end;
                    reaper.SetExtState(section,"Preset",StrPreset,true);
                end;
                -----
            elseif showmenuPreset == 3 then;--Rem all
                -----
                reaper.DeleteExtState(section,"Preset",true);
                -----
            elseif showmenuPreset > 3 then;
                -----
                if not reaper.GetSelectedMediaItem(0,0)then;
                    reaper.MB("No Selected Media Item","ERROR",0);
                else;
                    local Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
                    if Start == End then;
                        reaper.GetSet_LoopTimeRange(1,0,Start, End+0.01,0);
                    end;
                    local v;
                    for var in string.gmatch(Preset, "{{.-}{.-}{.-}{.-}}") do;
                        v = (v or 0)+1;
                        if v == showmenuPreset-3 then;
                            local
                            namePres,DIVISION,StartLoop,EndLoop = var:match("{{(.-)}{(.-)}{(.-)}{(.-)}}");
                            reaper.PreventUIRefresh(2);
                            reaper.Undo_BeginBlock();
                            reaper.GetSet_LoopTimeRange(1,0,StartLoop,EndLoop,0);
                            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
                            reaper.GetSet_LoopTimeRange(1,0,Start, End,0);
                            reaper.PreventUIRefresh(-2);
                            reaper.Undo_EndBlock("Duplicate items - preset "..namePres,0)
                        end;  
                    end;  
                    
                end;
                -----
            end;  
        end;
        -- End Preset --
        
        
        local LeftMousBut_4 = LeftMouseButton(X(4),Y(0),W(5),H(100),"4");
        if LeftMousBut_4 == 0 then;
            gfx.rect(X(4), Y(0), W(5), H(100));
            TextByCenterAndResize("4",5,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_4 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(4.5), Y(0.5), W(4), H(99.5));
            TextByCenterAndResize("4",5.5,0, 2,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_4 == 2 then;
            local Duplic = DuplicateSelItRelToSpecGridByTS(4,SELECTION,COPY_MOVE);
            if Duplic then;
                Triplet=0;
                reaper.SetExtState(section,"Triplet",Triplet,true);
                Start_GUI();
            end;
            LastClickForPreset = "4";
        end;
        
        
        local LeftMousBut_2 = LeftMouseButton(X(9),Y(0),W(5),H(100),"2");
        if LeftMousBut_2 == 0 then;
            gfx.rect(X(9), Y(0), W(5),H(100));
            TextByCenterAndResize("2",10,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);    
        elseif LeftMousBut_2 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(9.5), Y(0), W(4),H(100));
            TextByCenterAndResize("2",10.5,0, 2,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text); 
        elseif LeftMousBut_2 == 2 then;
            local Duplic = DuplicateSelItRelToSpecGridByTS(2,SELECTION,COPY_MOVE);
            if Duplic then;
                Triplet=0;
                reaper.SetExtState(section,"Triplet",Triplet,true);
                Start_GUI();
            end;
            LastClickForPreset = "2";
        end;
        
        
        local LeftMousBut_1 = LeftMouseButton(X(14),Y(0),W(5),H(100),"1");
        if LeftMousBut_1 == 0 then;
            gfx.rect(X(14), Y(0), W(5), H(100));
            TextByCenterAndResize("1",15,0, 3,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);    
        elseif LeftMousBut_1 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(14.5), Y(0), W(4), H(100));
            TextByCenterAndResize("1",15.5,0, 2,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1 == 2 then;
            local Duplic = DuplicateSelItRelToSpecGridByTS(1,SELECTION,COPY_MOVE);
            if Duplic then;
                Triplet=0;
                reaper.SetExtState(section,"Triplet",Triplet,true);
                Start_GUI();
            end;
            LastClickForPreset = "1";
        end;
        
        
       
        local LeftMousBut_1_2 = LeftMouseButton(X(19),Y(0),W(9),H(100),"1/2");
        if LeftMousBut_1_2 == 0 then;
            gfx.rect(X(19),Y(0), W(9),H(100));
            TextByCenterAndResize("1/2",20,0, 7, 100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_2 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(19.5),Y(0), W(8),H(100));
            TextByCenterAndResize("1/2",20.5,0, 6, 100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_2 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/2)/1.5
                LastClickForPreset = "1/3"
            else;
                DIVISION = (1/2);
                LastClickForPreset = "1/2"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
            
        end;
        
        
        
        local LeftMousBut_1_4 = LeftMouseButton(X(28), Y(0), W(9), H(100),"1/4");
        if LeftMousBut_1_4 == 0 then;
            gfx.rect(X(28), Y(0), W(9), H(100));
            TextByCenterAndResize("1/4",29,0, 7,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_4 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(28.5), Y(0), W(8), H(100));
            TextByCenterAndResize("1/4",29.5,0, 6,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_4 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/4)/1.5;
                LastClickForPreset = "1/6"
            else;
                DIVISION = (1/4);
                LastClickForPreset = "1/4"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        local LeftMousBut_1_8 = LeftMouseButton(X(37), Y(0), W(9), H(100),"1/8");
        if LeftMousBut_1_8 == 0 then;
            gfx.rect(X(37), Y(0), W(9), H(100));
            TextByCenterAndResize("1/8",38,0, 7,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_8 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(37.5), Y(0), W(8), H(100));
            TextByCenterAndResize("1/8",38.5,0, 6,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_8 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/8)/1.5;
                LastClickForPreset = "1/12"
            else;
                DIVISION = (1/8);
                LastClickForPreset = "1/8"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        local LeftMousBut_1_16 = LeftMouseButton(X(46),Y(0), W(12),H(100),"1/16");
        if LeftMousBut_1_16 == 0 then;
            gfx.rect(X(46),Y(0), W(12),H(100));
            TextByCenterAndResize("1/16",47,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_16 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(46.5),Y(0), W(11),H(100));
            TextByCenterAndResize("1/16",48,0, 8,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_16 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/16)/1.5;
                LastClickForPreset = "1/24"
            else;
                DIVISION = (1/16);
                LastClickForPreset = "1/16"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        
        local LeftMousBut_1_32 = LeftMouseButton(X(58),Y(0), W(12),H(100),"1/32");
        if LeftMousBut_1_32 == 0 then;
            gfx.rect(X(58),Y(0), W(12),H(100));
            TextByCenterAndResize("1/32",59,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_32 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(58.5),Y(0), W(11),H(100));
            TextByCenterAndResize("1/32",60,0, 8,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_32 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/32)/1.5;
                LastClickForPreset = "1/48"
            else;
                DIVISION = (1/32);
                LastClickForPreset = "1/32"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        
        local LeftMousBut_1_64 = LeftMouseButton(X(70),Y(0), W(12),H(100),"1/64");
        if LeftMousBut_1_64 == 0 then;
            gfx.rect(X(70),Y(0), W(12),H(100));
            TextByCenterAndResize("1/64",71,0, 10,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_64 == 1 then;    
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(70.5),Y(0), W(11),H(100));;
            TextByCenterAndResize("1/64",72,0, 8,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_64 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/64)/1.5;
                LastClickForPreset = "1/96"
            else;
                DIVISION = (1/64);
                LastClickForPreset = "1/64"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        
        local LeftMousBut_1_128 = LeftMouseButton(X(82),Y(0), W(15),H(100),"1/128");
        if LeftMousBut_1_128 == 0 then;
            gfx.rect(X(82),Y(0), W(15),H(100));
            TextByCenterAndResize("1/128",83,0, 13,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_128 == 1 then;
            SetColorRGB(R_Back,G_Back,B_Back,1);
            gfx.rect(X(82.5),Y(0), W(14),H(100));
            TextByCenterAndResize("1/128",84,0, 11,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        elseif LeftMousBut_1_128 == 2 then;
            if Triplet == 1 then; 
                DIVISION = (1/128)/1.5;
                LastClickForPreset = "1/192"
            else;
                DIVISION = (1/128);
                LastClickForPreset = "1/128"
            end;
            DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        end;
        
        
        
        local LeftMousBut_T = LeftMouseButton(X(97), Y(0), W(3), H(100),"T");
        if LeftMousBut_T == 0 then;
            if Triplet == 1 then;
                gfx.rect( X(97), Y(0), W(3), H(100));
                TextByCenterAndResize("T",97.5,0, 2,100,FontSize,TextBoldNorm,R_Back,G_Back,B_Back);          
            else;
                gfx.rect( X(97), Y(0), W(3), H(100));
                TextByCenterAndResize("T",97.5,0, 2,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            end; 
        elseif LeftMousBut_T == 1 then;
            if Triplet == 1 then;
                SetColorRGB(R_Text,G_Text,B_Text,1);
                gfx.rect( X(97.5), Y(0), W(2), H(100));
                TextByCenterAndResize("T",98,0, 1,100,FontSize,TextBoldNorm,R_Back,G_Back,B_Back);
            else;
                SetColorRGB(R_Back,G_Back,B_Back,1);
                gfx.rect( X(97.5), Y(0), W(2), H(100));
                TextByCenterAndResize("T",98,0, 1,100,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            end;
        elseif LeftMousBut_T == 2 then;
            if Triplet == 1 then;
                Triplet = 0;
                reaper.SetExtState(section,"Triplet",Triplet,true);
            else;
                Triplet = 1;
                reaper.SetExtState(section,"Triplet",Triplet,true);
            end;
            Start_GUI();
        end;
        
        --body-- / Рисуем функциональность (горящие кнопочки и т.д.)
        --------------------------------------------------------
        
        ---- / Show Menu / ----
        local Dock_ = gfx.dock(-1);
        if Dock_&1 ~= 0 and SaveDock ~= Dock_ then SaveDock = Dock_ end;
        
        if gfx.mouse_cap == 2 then;
            gfx.x = gfx.mouse_x;
            gfx.y = gfx.mouse_y;
            
            
            local checkedDock;
            local Dock = gfx.dock(-1);
            if Dock&1 ~= 0 then checkedDock = "!" else checkedDock = "" end;
            
            local checkSELECTION;
            if SELECTION == 1 then checkSELECTION = "!" else checkSELECTION = "" end;
            
            local checkCOPY_MOVE;
            if COPY_MOVE == 1 then checkCOPY_MOVE = "!" else checkCOPY_MOVE = "" end;
            
            local checkBold;
            if TextBoldNorm == 98 then checkBold = "!" else checkBold = "" end;
            
            local checkZoomInOn;
            if FontSize ~= 0 then checkZoomInOn = "!" else checkZoomInOn = "" end;
            
            local checkRemFocWin;
            if RemFocusWin == 1 then checkRemFocWin = "!" else checkRemFocWin = "" end;
            
            local
            showmenu = gfx.showmenu(--[[ 1]]checkedDock.."Dock Big Clock in Docker||"..
                                    --[[ 2]]checkSELECTION.."Selection Items|"..
                                    --[[ 3]]checkCOPY_MOVE.."Move / COPY Original|"..
                                    --[[ 4]]"# #|"..
                                    --[[ 5]]"# #|"..
                                    --[[ 6]]"# #||"..
                                    --[[->]]">View|"..
                                    --[[->]]">Color|"..
                                    --[[ 7]]"Customize text color...|"..
                                    --[[ 8]]"Default text color||"..
                                    --[[ 9]]"Customize background color|"..
                                    --[[10]]"Default background color||"..
                                    --[[11]]"Customize Gui color|"..
                                    --[[12]]"Default Gui color||"..
                                    --[[13]]"<Default All color|"..
                                    --[[14]]checkBold.."Text: Normal / Bold|"..
                                    --[[15]]checkZoomInOn.."Font Size||"..
                                    --[[16]]checkRemFocWin.."Remove focus from window (useful when switching Screenset)||"..
                                    --[[17]]"<Reset All|"..
                                    --[[->]]">Support project|"..
                                    --[[18]]"Dodate||"..
                                    --[[19]]"Bug report (Of site forum)|"..
                                    --[[20]]"<Bug report (Rmm forum)||"..
                                    --[[21]]"Close clock window");
            
            
            if showmenu == 1 then;
                ----
                if Dock&1 ~= 0 then;
                    gfx.dock(0);
                    SaveDock = Dock;
                else;
                   if math.fmod(PositionDock,2) == 0 then PositionDock = 2049 end;
                   gfx.dock(SaveDock or PositionDock);
                end;
                ----
            elseif showmenu == 2 then;
                ----
                if SELECTION ~= 0 then SELECTION = 0 else SELECTION = 1 end;
                reaper.SetExtState(section,"SELECTION",SELECTION,true);
                ----
            elseif showmenu == 3 then;
                ----
                if COPY_MOVE ~= 0 then COPY_MOVE = 0 else COPY_MOVE = 1 end;
                reaper.SetExtState(section,"COPY_MOVE",COPY_MOVE,true);
                ----
            elseif showmenu == 4 then;
                ----
                
                ----
            elseif showmenu == 5 then;
                ----
                
                ----
            elseif showmenu == 6 then;
                ----
                
                ----
            elseif showmenu == 7 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Text","R"..r.."G"..g.."B"..b,true);
                    R_Text,G_Text,B_Text = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 8 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                Start_GUI();
                ----
            elseif showmenu == 9 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Background","R"..r.."G"..g.."B"..b,true);
                    R_Back,G_Back,B_Back = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 10 then;
                ----
                reaper.DeleteExtState(section,"Color_Background",true);
                R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                Start_GUI();
                ----
            elseif showmenu == 11 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Gui","R"..r.."G"..g.."B"..b,true);
                    R_Gui,G_Gui,B_Gui = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 12 then;
                ----
                reaper.DeleteExtState(section,"Color_Gui",true);
                R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                Start_GUI();
                ----
            elseif showmenu == 13 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                reaper.DeleteExtState(section,"Color_Background",true);
                R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                reaper.DeleteExtState(section,"Color_Gui",true);
                R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                Start_GUI();
                ----
            elseif showmenu == 14 then;
                ----
                if TextBoldNorm == 98 then TextBoldNorm = 0 else TextBoldNorm = 98 end;
                reaper.SetExtState(section,"TextBoldNorm",TextBoldNorm,true);
                Start_GUI();
                ----
            elseif showmenu == 15 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("font size",1,"Size: -- < Default = 0 > ++ ",FontSize or 0);
                if retval and tonumber(retvals_csv) then;
                    reaper.SetExtState(section,"FontSize",retvals_csv,true);
                    FontSize = tonumber(retvals_csv);
                    Start_GUI();
                end;
                ----
            elseif showmenu == 16 then;
                ----
                if RemFocusWin == 1 then RemFocusWin = 0 else RemFocusWin = 1 end;
                reaper.SetExtState(section,"RemFocusWin",RemFocusWin,true);
                ----
            elseif showmenu == 17 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                reaper.DeleteExtState(section,"Color_Background",true);
                reaper.DeleteExtState(section,"Color_Gui",true);
                reaper.DeleteExtState(section,"TextBoldNorm",true);
                reaper.DeleteExtState(section,"FontSize",true);
                reaper.DeleteExtState(section,"RemFocusWin",true);
                reaper.DeleteExtState(section,"PositionDock",true);
                reaper.DeleteExtState(section,"PositionWind",true);
                reaper.DeleteExtState(section,"SizeWindow",true);
                reaper.DeleteExtState(section,"SaveDock",true);
                gfx.quit();
                dofile(({reaper.get_action_context()})[2]);
                do return end;
                ----
            elseif showmenu == 18 then;
                ----
                local path = "https://money.yandex.ru/to/410018003906628";
                OpenWebSite(path);
                reaper.ClearConsole();
                reaper.ShowConsoleMsg("Yandex-money - "..path.."\n\nWebManey - R159026189824");
                ----
            elseif showmenu == 19 then;
                ----
                local path = "https://forum.cockos.com/showthread.php?t=212819";
                OpenWebSite(path);
                ----
            elseif showmenu == 20 then;
                ----
                local path = "https://rmmedia.ru/threads/134701/";
                OpenWebSite(path);
                ----
            elseif showmenu == 21 then;
                ----
                exit();
                ----
            end;
        end;
        ----< End Show Menu >----
        
        ------------------------------
        
        --body--
        
        ------------------------------
        if gfx.getchar() >= 0 then reaper.defer(loop);else;reaper.atexit(exit)return;end;
    end;
    ----< End function loop(); >----
    
    
    
    
    function DuplicateSelItRelToSpecGridByTS(DIVISION,SELECTION,COPY_MOVE);
        
        
        if not reaper.GetSelectedMediaItem(0,0) then;
            reaper.MB("No Selected Media Item","ERROR",0);
            return;
        end;
         
        
        local Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if Start == End then;
            reaper.MB("No Time Selection","ERROR",0);
            return;
        end;
        
            
        reaper.PreventUIRefresh(1);
        reaper.Undo_BeginBlock()
        -----
        local TableWithPositions = {};
        -----
        --- / Записываем в Таблицу с позиции / ---
        local FindTempTime = reaper.FindTempoTimeSigMarker(0,Start);
        if FindTempTime < 0 then;
            ------
            local bpm, bpi = reaper.GetProjectTimeSignature2(0);
            local ValueSecond =(60 * bpi / bpm)*(DIVISION);
            
            for i = 1,math.huge do; 
                if Start >= End-0.0000001 then break end;
                Start = Start + ValueSecond;
                TableWithPositions[#TableWithPositions+1] = ValueSecond;
            end;
            -----
        else;
            -----
            for i = 1, math.huge do;
                
                FindTempTime = reaper.FindTempoTimeSigMarker(0,Start);
                local _,_,_,_,bpm,bpi,_,_ = reaper.GetTempoTimeSigMarker(0,FindTempTime);
                
                if bpi < 0 then;
                    bpi = ({reaper.GetProjectTimeSignature()})[2];
                end;
                
                bpm = reaper.TimeMap2_GetDividedBpmAtTime(0,Start);
                
                local ValueSecond =(60 * bpi / bpm)*(DIVISION);
                
                if Start >= End-0.0000001 then break end;
                
                Start = Start + ValueSecond;
                
                TableWithPositions[#TableWithPositions+1] = ValueSecond;
            end;
            -----
        end;
        ------------------------------------------
        
        
        --- / Расставляем по местам и выделяем / ---
        local FindTempTime = reaper.FindTempoTimeSigMarker(0,0);
        if FindTempTime < 0 then;
            reaper.Main_OnCommand(41046,0);
            reaper.Main_OnCommand(41046,0);
        end;
        
        
        local selIt_T = {};
        for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do; 
            selIt_T[i] = reaper.GetSelectedMediaItem(0,i);
            reaper.SetMediaItemSelected(selIt_T[i],0);
        end;
        
        local existingItems = {};
        if SELECTION == 1 then;
            for i = 1, reaper.CountMediaItems(0) do;
                existingItems[i] = reaper.GetMediaItem(0,i-1);  
            end;
        end;
        
        local TableActive, firstMoveItem, Copy_Move;
        local Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        for i = #selIt_T,0,-1 do; 
            reaper.SetMediaItemSelected(selIt_T[i],1);
            
            for i2 = 1,#TableWithPositions do;
                ----
                local pos = reaper.GetMediaItemInfo_Value(selIt_T[i],"D_POSITION");
                local FindTempTime = reaper.FindTempoTimeSigMarker(0,pos);
                local _,_,_,_,bpm,_,_,_ = reaper.GetTempoTimeSigMarker(0,FindTempTime);
                local length = reaper.GetMediaItemInfo_Value(selIt_T[i],"D_LENGTH");
                local prevLength = length * bpm;
                ----
                
                if not TableActive then;
                    table.insert(TableWithPositions,1,Start-pos);
                    TableActive = true;
                end;
                
                if not firstMoveItem then;
                    if COPY_MOVE ~= 0 then COPY_MOVE = 5 end;
                    Copy_Move = COPY_MOVE;
                    firstMoveItem = true;
                else;
                    Copy_Move = 5;
                end;
                
                reaper.ApplyNudge(0,0,Copy_Move--[[5]],1,TableWithPositions[i2],0,1);
                ----
                local pos = reaper.GetMediaItemInfo_Value(selIt_T[i],"D_POSITION");
                local FindTempTime = reaper.FindTempoTimeSigMarker(0,pos);
                local _,_,_,_,bpm,_,_,_ = reaper.GetTempoTimeSigMarker(0,FindTempTime);
                local nextLength = prevLength / bpm;
                reaper.SetMediaItemInfo_Value(selIt_T[i],"D_LENGTH",nextLength);
                ----
            end;
            
            if TableActive then;
                table.remove(TableWithPositions,1);
                TableActive = false;
            end;
            
            firstMoveItem = nil;
            
            reaper.SetMediaItemSelected(selIt_T[i],0);
        end;
        
        if SELECTION == 1 then;
            for i = 1, reaper.CountMediaItems(0) do;
                local item = reaper.GetMediaItem(0,i-1);
                for i2 = 1, #existingItems do;  
                    if existingItems[i2] == item then Sel = 0 end;  
                end; 
                if not Sel then reaper.SetMediaItemSelected(item,true);else;Sel=nil;end;
            end;
            
            for i = #selIt_T,0,-1 do; 
                reaper.SetMediaItemSelected(selIt_T[i],1);
            end;
        end;
        --------------------------------------------
        reaper.Undo_EndBlock("Duplicate by "..DIVISION.." by time selection",-1);
        reaper.PreventUIRefresh(-1);
        reaper.UpdateArrange();
        return true;
    end;--End < DuplicateSelItRelToSpecGridByTS >---------------------------------
    
    
    
    ---------
    function exit();
        reaper.SetToggleCommandState(sectionID,cmdID,0);
        reaper.DockWindowRefresh();
        local PosDock,PosX,PosY,PosW,PosH = gfx.dock(-1,-1,-1,-1,-1);
        reaper.SetExtState(section,"PositionDock",PosDock,true);
        reaper.SetExtState(section,"PositionWind",PosX.."&"..PosY,true);
        reaper.SetExtState(section,"SizeWindow",PosW.."&"..PosH,true);
        reaper.SetExtState(section,"SaveDock",SaveDock or "NULL",true);
        gfx.quit();
    end;
    ---------
    
    loop();
	reaper.atexit(exit);