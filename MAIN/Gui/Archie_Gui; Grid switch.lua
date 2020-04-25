--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Gui
   * Description: Grid switch
   * Author:      Archie
   * Version:     1.06
   * Описание:    Переключатель сетки
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(Rmm)
   * Gave idea:   Krikets(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.06 [230420]
   *                  + No changе
   
   *              v.1.02 [12.10.19]
   *                  + Close window when focus is lost
   *                  + When click button close window
   *              v.1.0 [10.10.19]
   *                  + initialе
--]]
    local Version = 'v.1.06';
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local
    Table = {};
    
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
    
    
    
    
    ---------------/ Координаты кнопок /-----------------------------------------------------
    local But1_1  = {x =  0, y = 0, w =  4, h = 100,  xt =  0.5, yt = 0, wt =   3, ht = 100};
    local But1_2  = {x =  4, y = 0, w =  4, h = 100,  xt =    5, yt = 0, wt =   2, ht = 100};
    local But1_3  = {x =  8, y = 0, w =  4, h = 100,  xt =  8.8, yt = 0, wt = 2.4, ht = 100};
    local But1_4  = {x = 12, y = 0, w =  4, h = 100,  xt = 12.7, yt = 0, wt = 2.6, ht = 100};
    local But1_5  = {x = 16, y = 0, w =  5, h = 100,  xt = 17.3, yt = 0, wt = 2.4, ht = 100};
    local But1_6  = {x = 21, y = 0, w =  5, h = 100,  xt = 22.3, yt = 0, wt = 2.4, ht = 100};
    local But1_7  = {x = 26, y = 0, w =  5, h = 100,  xt = 27.3, yt = 0, wt = 2.4, ht = 100};
    local But1_8  = {x = 31, y = 0, w =  8, h = 100,  xt =   32, yt = 0, wt =   6, ht = 100};
    local But1_9  = {x = 39, y = 0, w =  8, h = 100,  xt =   40, yt = 0, wt =   6, ht = 100};
    local But1_10 = {x = 47, y = 0, w =  8, h = 100,  xt =   48, yt = 0, wt =   6, ht = 100};
    local But1_11 = {x = 55, y = 0, w = 10, h = 100,  xt =   56, yt = 0, wt =   8, ht = 100};
    local But1_12 = {x = 65, y = 0, w = 10, h = 100,  xt =   66, yt = 0, wt =   8, ht = 100};
    local But1_13 = {x = 75, y = 0, w = 10, h = 100,  xt =   76, yt = 0, wt =   8, ht = 100};
    local But1_14 = {x = 85, y = 0, w = 12, h = 100,  xt =   86, yt = 0, wt =  10, ht = 100};
    local But1_15 = {x = 97, y = 0, w =  3, h = 100,  xt = 97.5, yt = 0, wt =   2, ht = 100};
    -----
    local But2_1  = {x = 0, y =    0, w = 100, h =   5,  xt = 29, yt =  0.5, wt =  42, ht =   4};
    local But2_2  = {x = 0, y =    5, w = 100, h =   5,  xt = 37, yt =  5.5, wt =  26, ht =   4};
    local But2_3  = {x = 0, y =   10, w = 100, h =   5,  xt = 37, yt = 10.5, wt =  26, ht =   4};
    local But2_4  = {x = 0, y =   15, w = 100, h =   5,  xt = 37, yt = 15.5, wt =  26, ht =   4};
    local But2_5  = {x = 0, y =   20, w = 100, h = 7.5,  xt = 36, yt = 20.5, wt =  28, ht = 6.5};
    local But2_6  = {x = 0, y = 27.5, w = 100, h = 7.5,  xt = 36, yt =   28, wt =  28, ht = 6.5};
    local But2_7  = {x = 0, y =   35, w = 100, h = 7.5,  xt = 36, yt = 35.5, wt =  28, ht = 6.5};
    local But2_8  = {x = 0, y = 42.5, w = 100, h = 7.5,  xt = 20, yt =   43, wt =  60, ht = 6.5};
    local But2_9  = {x = 0, y =   50, w = 100, h = 7.5,  xt = 20, yt = 50.5, wt =  60, ht = 6.5};
    local But2_10 = {x = 0, y = 57.5, w = 100, h = 7.5,  xt = 20, yt =   58, wt =  60, ht = 6.5};
    local But2_11 = {x = 0, y =   65, w = 100, h = 7.5,  xt = 10, yt = 65.5, wt =  80, ht = 6.5};
    local But2_12 = {x = 0, y = 72.5, w = 100, h = 7.5,  xt = 10, yt =   73, wt =  80, ht = 6.5};
    local But2_13 = {x = 0, y =   80, w = 100, h = 7.5,  xt = 10, yt = 80.5, wt =  80, ht = 6.5};
    local But2_14 = {x = 0, y = 87.5, w = 100, h = 7.5,  xt =  1, yt =   88, wt =  98, ht = 6.5};
    local But2_15 = {x = 0, y =   95, w = 100, h =   5,  xt =  0, yt = 95.5, wt = 100, ht =   4};
    ---------------------------------------------------------------------------------------------
    
    
    
    
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
        local r2,g2,b2,a2 = gfx.r*256, gfx.g*256, gfx.b*256, gfx.a2;
        gfx.set(r/256,g/256,b/256,a,mode);
        return r2,g2,b2,a2;
    end;
    -----------------------------------------
    
    
    
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
    -----------------------------------------
    
    
    
    --- / Всплывающая подсказка / -----------
    local ToolTip = {};
    local function SetToolTip(Str,x,y,w,h,showTip,buf);
        if showTip == 1 then;
            ToolTip.timeToShow = 10; -- time until display tooltip in number of loop
            if gfx.mouse_x > x and  gfx.mouse_y > y and gfx.mouse_x < x+w and gfx.mouse_y < y+h then;
                if gfx.mouse_x == ToolTip.x_tip and gfx.mouse_y == ToolTip.y_tip then ToolTip.tip=(ToolTip.tip or 0)+1 else ToolTip.tip=0 end;
                ToolTip.x_tip, ToolTip.y_tip = gfx.mouse_x, gfx.mouse_y;
                if ToolTip.tip == ToolTip.timeToShow then;
                    local x,y = gfx.clienttoscreen(gfx.mouse_x,gfx.mouse_y);
                    reaper.TrackCtl_SetToolTip(Str,x+20,y+10,true);
                    ToolTip.tipClean = {};
                    ToolTip.tipClean[buf] = true;
                elseif ToolTip.tip < ToolTip.timeToShow then;
                    ToolTip.tipClean = ToolTip.tipClean or {};
                    if ToolTip.tipClean[buf] == true then;
                        reaper.TrackCtl_SetToolTip("",0,0,false);
                        ToolTip.tipClean[buf] = nil;
                    end;
                end;
            end;
        end;
    end;
    
    local function CleanToolTip(buf);
        ToolTip.tipClean = ToolTip.tipClean or {};
        if ToolTip.tipClean[buf] == true then;
            reaper.TrackCtl_SetToolTip("",0,0,false);
            ToolTip.tipClean[buf] = nil;
            ToolTip.tip = math.floor((ToolTip.timeToShow / 2)+0.5);
        end;
    end;
    -----------------------------------------
    
    
    
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
    
    
    
    ---/ Форматирует значение сетки в удобочитаемую форму; /--------------
    local function Get_Format_ProjectGridEx(divisionIn);
        local function IntegerNumber(x);return math.abs(x-math.floor(x+.5))<0.0000001;end;
        local flag,division,swingmode,swingshift = reaper.GetSetProjectGrid(0,0);
        local division = tonumber(divisionIn)or division;
        if not tonumber(division) then return false end;
        local i,T,str1,str2,str3,str4;
        repeat i=(i or 0)+1 if i>50000 then return false end; until IntegerNumber(i/division);
        local fraction = math.floor(i/division+.5);
        str1 = (string.format("%.0f",i).."/"..string.format("%.0f",fraction)):gsub("/%s-1$","");
        if division >= 1 then str2 = string.format("%.3f",division):gsub("[0.]-$","") else str2 = str1 end;
        if (fraction % 3) == 0 then T = true else T = false end;
        if T then str3=string.format("%.0f",i).."/"..string.format("%.0f",fraction-(fraction/3)).."T"else str3=str1 end;
        if T then;
            if division>=0.6666 then str4=string.format("%.3f",(division/2)+division):gsub("[0.]-$","").."T"else str4=str3;end;
            elseif division >= 1 then str4=str2 else str4=str1;
        end;
        return true,flag,division,swingmode,swingshift,T,str1,str2,str3,str4;
    end;
    ----------------------------------------------------------------------
    
    
    
    --- / Счетчик для пропуска / ---
    local function Counter();
        local t={};return function(x,b)b=b or 1 t[b]=(t[b]or 0)+1 if t[b]>(x or math.huge)then t[b]=0 end return t[b]end;  
    end;Counter = Counter(); -- Counter(x,buf); x=reset
    ----------------------------------------------------------------------
    
    
    
    -- Сравните два числа с учетом погрешности плавающей запятой --
    local function compare(x,y);
        if not tonumber(x)or not tonumber(y)then return false end;
        return math.abs(x-y) < 0.0000001;
    end;
    ----------------------------------------------------------------------
    
    
    
    -- local ---
    local Pcall,ShowGridSettings
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    
    
    
    local section = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    reaper.SetToggleCommandState(sectionID,cmdID,1);
    reaper.RefreshToolbar2(sectionID,cmdID);
    
    
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
    local TOOL_TIP = tonumber(reaper.GetExtState(section,"TOOL_TIP"))or 1;
    -----
    
    
    -----
    local FOCUS_LOST_CLOSE = tonumber(reaper.GetExtState(section,"FOCUS_LOST_CLOSE"))or 0;
    -----
    
    
    -----
    local CLICK_BUT_CLOSE_WIN = tonumber(reaper.GetExtState(section,"CLICK_BUT_CLOSE_WIN"))or 1;
    -----
    
    
    -----
    local PIN_ON_TOP = tonumber(reaper.GetExtState(section,"PIN_ON_TOP"))or 1;
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
                    if Context == 2 then ENV = reaper.GetSelectedTrackEnvelope(0)else ENV = nil end;
                    reaper.SetCursorContext(Context,ENV);
                    --t=(t or 0)+1;
                end;
            end;
        end;
    end;
    -------------------------------------------------------------------------------
    
    
    
    ---- / Logo / ------------------
      function Logo();
        if gfx.w > 100 and gfx.h > 42 then;
            local r2,g2,b2,a2 = gfx.r, gfx.g, gfx.b, gfx.a2;
            gfx.x=0; gfx.y=0;
            gfx.setpixel(R_Back/256, G_Back/256, B_Back/256);
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
            gfx.setfont(1,"Arial",15,105);
            gfx.set(r2,g2,b2,a2);
        end;
    end;
    -------------------------------------------------------------------------------
    
    
    
    
    Version = Version or '';
    local titleWin = "Grid switch "..Version;
    gfx.init(titleWin,SizeW or 700,SizeH or 35,PositionDock,PosX or 150,PosY or 100);
    if PIN_ON_TOP == 1 then;
        local PcallWindScr,ShowWindScr = pcall(reaper.JS_Window_Find,titleWin,true);
        if PcallWindScr and type(ShowWindScr)=="userdata" then reaper.JS_Window_AttachTopmostPin(ShowWindScr)end;
    end;
    
    
    
    
    
    ---- / Рисуем основу / ----
    local function Start_GUI();
        
        gfxSaveScrin_buf(1,gfx.w,gfx.h); 
        
        gfx.gradrect(0,0,gfx.w,gfx.h,R_Back/256,G_Back/256,B_Back/256,1);--background
        SetColorRGB(R_Gui,G_Gui,B_Gui,1);
        
        if  gfx.w > gfx.h and gfx.h < 500 then;
            
            gfx.rect(X(But1_1.x),Y(But1_1.y), W(But1_1.w),H(But1_1.h),0);
            TextByCenterAndResize("⚙",But1_1.xt,But1_1.yt, But1_1.wt,But1_1.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_2.x),Y(But1_2.y), W(But1_2.w),H(But1_2.h),0);
            TextByCenterAndResize("L",But1_2.xt,But1_2.yt, But1_2.wt,But1_2.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_3.x),Y(But1_3.y), W(But1_3.w),H(But1_3.h),0);
            TextByCenterAndResize("S",But1_3.xt,But1_3.yt, But1_3.wt,But1_3.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_4.x),Y(But1_4.y), W(But1_4.w),H(But1_4.h),0);
            TextByCenterAndResize("R",But1_4.xt,But1_4.yt, But1_4.wt,But1_4.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_5.x),Y(But1_5.y), W(But1_5.w),H(But1_5.h),0);
            TextByCenterAndResize("4",But1_5.xt,But1_5.yt, But1_5.wt,But1_5.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_6.x),Y(But1_6.y), W(But1_6.w),H(But1_6.h),0);
            TextByCenterAndResize("2",But1_6.xt,But1_6.yt, But1_6.wt,But1_6.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_7.x),Y(But1_7.y), W(But1_7.w),H(But1_7.h),0);
            TextByCenterAndResize("1",But1_7.xt,But1_7.yt, But1_7.wt,But1_7.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_8.x),Y(But1_8.y), W(But1_8.w),H(But1_8.h),0);
            TextByCenterAndResize("1/2",But1_8.xt,But1_8.yt, But1_8.wt,But1_8.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_9.x),Y(But1_9.y), W(But1_9.w),H(But1_9.h),0);
            TextByCenterAndResize("1/4",But1_9.xt,But1_9.yt, But1_9.wt,But1_9.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_10.x),Y(But1_10.y), W(But1_10.w),H(But1_10.h),0);
            TextByCenterAndResize("1/8",But1_10.xt,But1_10.yt, But1_10.wt,But1_10.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_11.x),Y(But1_11.y), W(But1_11.w),H(But1_11.h),0);
            TextByCenterAndResize("1/16",But1_11.xt,But1_11.yt, But1_11.wt,But1_11.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_12.x),Y(But1_12.y), W(But1_12.w),H(But1_12.h),0);
            TextByCenterAndResize("1/32",But1_12.xt,But1_12.yt, But1_12.wt,But1_12.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_13.x),Y(But1_13.y), W(But1_13.w),H(But1_13.h),0);
            TextByCenterAndResize("1/64",But1_13.xt,But1_13.yt, But1_13.wt,But1_13.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_14.x),Y(But1_14.y), W(But1_14.w),H(But1_14.h),0);
            TextByCenterAndResize("1/128",But1_14.xt,But1_14.yt, But1_14.wt,But1_14.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But1_15.x),Y(But1_15.y), W(But1_15.w),H(But1_15.h),0);
            TextByCenterAndResize("T",But1_15.xt,But1_15.yt, But1_15.wt,But1_15.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
        else;
            
            gfx.rect(X(But2_1.x),Y(But2_1.y), W(But2_1.w),H(But2_1.h),0);
            TextByCenterAndResize("⚙",But2_1.xt,But2_1.yt, But2_1.wt,But2_1.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_2.x),Y(But2_2.y), W(But2_2.w),H(But2_2.h),0);
            TextByCenterAndResize("L",But2_2.xt,But2_2.yt, But2_2.wt,But2_2.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_3.x),Y(But2_3.y), W(But2_3.w),H(But2_3.h),0);
            TextByCenterAndResize("S",But2_3.xt,But2_3.yt, But2_3.wt,But2_3.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_4.x),Y(But2_4.y), W(But2_4.w),H(But2_4.h),0);
            TextByCenterAndResize("R",But2_4.xt,But2_4.yt, But2_4.wt,But2_4.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_5.x),Y(But2_5.y), W(But2_5.w),H(But2_5.h),0);
            TextByCenterAndResize("4",But2_5.xt,But2_5.yt, But2_5.wt,But2_5.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                        
            gfx.rect(X(But2_6.x),Y(But2_6.y), W(But2_6.w),H(But2_6.h),0);
            TextByCenterAndResize("2",But2_6.xt,But2_6.yt, But2_6.wt,But2_6.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                      
            gfx.rect(X(But2_7.x),Y(But2_7.y), W(But2_7.w),H(But2_7.h),0);
            TextByCenterAndResize("1",But2_7.xt,But2_7.yt, But2_7.wt,But2_7.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
              
            gfx.rect(X(But2_8.x),Y(But2_8.y), W(But2_8.w),H(But2_8.h),0);
            TextByCenterAndResize("1/2",But2_8.xt,But2_8.yt, But2_8.wt,But2_8.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_9.x),Y(But2_9.y), W(But2_9.w),H(But2_9.h),0);
            TextByCenterAndResize("1/4",But2_9.xt,But2_9.yt, But2_9.wt,But2_9.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_10.x),Y(But2_10.y), W(But2_10.w),H(But2_10.h),0);
            TextByCenterAndResize("1/8",But2_10.xt,But2_10.yt, But2_10.wt,But2_9.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_11.x),Y(But2_11.y), W(But2_11.w),H(But2_11.h),0);
            TextByCenterAndResize("1/16",But2_11.xt,But2_11.yt, But2_11.wt,But2_11.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_12.x),Y(But2_12.y), W(But2_12.w),H(But2_12.h),0);
            TextByCenterAndResize("1/32",But2_12.xt,But2_12.yt, But2_12.wt,But2_12.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_13.x),Y(But2_13.y), W(But2_13.w),H(But2_13.h),0);
            TextByCenterAndResize("1/64",But2_13.xt,But2_13.yt, But2_13.wt,But2_13.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_14.x),Y(But2_14.y), W(But2_14.w),H(But2_14.h),0);
            TextByCenterAndResize("1/128",But2_14.xt,But2_14.yt, But2_14.wt,But2_14.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            
            gfx.rect(X(But2_15.x),Y(But2_15.y), W(But2_15.w),H(But2_15.h),0);
            TextByCenterAndResize("T",But2_15.xt,But2_15.yt, But2_15.wt,But2_15.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
        end;
        Logo();
        gfxRestScrin_buf(1,0,0,gfx.w,gfx.h);  
    end;
    Start_GUI();
    
    
    
    ---------
    local checked_Toggle,Start_W,Start_H;
    function loop();
        
        ----/Проверить тоггле(полезно для автозагрузки)/----
        if not checked_Toggle then;
            local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
            if Toggle <= 0 then;
                reaper.SetToggleCommandState(sectionID,cmdID,1);
                reaper.RefreshToolbar2(sectionID,cmdID);
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
        ---/ Закрыть окно при потере фокуса / ---
        if FOCUS_LOST_CLOSE == 1 and gfx.dock(-1)&1==0 and Counter(5,"focus_lost_close")== 0 then;
            if gfx.getchar(65536)&2 ~= 2 then reaper.atexit(exit) return end;
        end;
        --------------------------------------------------------
        
        
        
        -- body --
        gfxRestScrin_buf(1,0,0,gfx.w,gfx.h);
        
        local _,_,divisionF,swingmodeF,swingshiftF,grid_Format_T,str1F,str2F,str3F,str4F = Get_Format_ProjectGridEx();
        str1F,str2F,str3F,str4F = str1F.."\n",str2F.."\n",str3F.."\n",str4F.."\n";
        --[
        if str3F == str4F or str3F == str2F or str3F == str1F then str3F = "" end;
        if str2F == str4F or str2F == str3F or str2F == str1F then str2F = "" end;
        if str1F == str4F or str1F == str3F or str1F == str2F then str1F = "" end;
        --]]
        
        if gfx.w > gfx.h and gfx.h < 500 then;
            
            
            ---- 1.1 ----/settings/
            local L_But_Seting = LeftMouseButton(X(But1_1.x),Y(But1_1.y), W(But1_1.w),H(But1_1.h),"Seting");
            if Counter(10,"SkipJS_Find")== 0 then;
                Pcall,ShowGridSettings = pcall(reaper.JS_Window_Find,"Snap/Grid Settings",true);
            end;
            if L_But_Seting == 0 then;
                SetToolTip("Shap/Grig Settings",X(But1_1.x),Y(But1_1.y),W(But1_1.w),H(But1_1.h),TOOL_TIP,"L_But_Seting");
                gfx.rect(X(But1_1.x),Y(But1_1.y), W(But1_1.w),H(But1_1.h),1);
                TextByCenterAndResize("⚙",But1_1.xt,But1_1.yt, But1_1.wt,But1_1.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Seting == 1 or L_But_Seting == 2 or ShowGridSettings and Pcall then;
                gfx.rect(X(But1_1.x)+2,Y(But1_1.y)+2, W(But1_1.w)-4,H(But1_1.h)-4,1);
                TextByCenterAndResize("⚙",But1_1.xt+0.25,But1_1.yt+0.25, But1_1.wt-0.5,But1_1.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Seting == 2 then;
                    reaper.Main_OnCommand(40071,0);--Show snap/grid settings
                end;
            end;
            if L_But_Seting < 0 then; CleanToolTip("L_But_Seting") end;
            -------------
            
            
            
            ---- 1.2 ----/Grid lines/
            local Toggle_linesEnable = reaper.GetToggleCommandStateEx(0,40145);--Toggle grid lines
            local L_But_linesEnable = LeftMouseButton(X(But1_2.x),Y(But1_2.y), W(But1_2.w),H(But1_2.h),"linesEnable");
            if L_But_linesEnable == 0 then;
                local state;
                if Toggle_linesEnable == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_linesEnable") end;
                Table.state2=state;
                SetToolTip("Grig lines enabled "..state,X(But1_2.x),Y(But1_2.y),W(But1_2.w),H(But1_2.h),TOOL_TIP,"L_But_linesEnable");
                if Toggle_linesEnable == 1 then;
                    gfx.rect(X(But1_2.x)+2,Y(But1_2.y)+2, W(But1_2.w)-4,H(But1_2.h)-4,1);
                else;
                    gfx.rect(X(But1_2.x),Y(But1_2.y), W(But1_2.w),H(But1_2.h),1);
                end;
                TextByCenterAndResize("L",But1_2.xt,But1_2.yt, But1_2.wt,But1_2.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);   
            elseif L_But_linesEnable == 1 or L_But_linesEnable == 2 or Toggle_linesEnable == 1 then;
                gfx.rect(X(But1_2.x)+2,Y(But1_2.y)+2, W(But1_2.w)-4,H(But1_2.h)-4,1);
                TextByCenterAndResize("L",But1_2.xt+0.25,But1_2.yt+0.25, But1_2.wt-0.5,But1_2.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);  
                if L_But_linesEnable == 2 then;
                    reaper.Main_OnCommand(40145,0);--Toggle grid lines
                end;
            end;
            if L_But_linesEnable < 0 then; CleanToolTip("L_But_linesEnable") end; 
            -------------
             
            
            
            ---- 1.3 ----/Snap Enable/
            local Toggle_Snapping = reaper.GetToggleCommandStateEx(0,1157);--Toggle snapping
            local L_But_Snapping = LeftMouseButton(X(But1_3.x),Y(But1_3.y), W(But1_3.w),H(But1_3.h),"SnappingEnable");
            if L_But_Snapping == 0 then;
                local state;
                if Toggle_Snapping == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Snapping") end;
                Table.state2=state;
                SetToolTip("Snap enabled "..state,X(But1_3.x),Y(But1_3.y),W(But1_3.w),H(But1_3.h),TOOL_TIP,"L_But_Snapping");
                if Toggle_Snapping == 1 then;
                    gfx.rect(X(But1_3.x)+2,Y(But1_3.y)+2, W(But1_3.w)-4,H(But1_3.h)-4,1);
                else;
                    gfx.rect(X(But1_3.x),Y(But1_3.y), W(But1_3.w),H(But1_3.h),1);
                end; 
                TextByCenterAndResize("S",But1_3.xt,But1_3.yt, But1_3.wt,But1_3.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Snapping == 1 or L_But_Snapping == 2 or Toggle_Snapping == 1 then;
                gfx.rect(X(But1_3.x)+2,Y(But1_3.y)+2, W(But1_3.w)-4,H(But1_3.h)-4,1);
                TextByCenterAndResize("S",But1_3.xt+0.25,But1_3.yt+0.25, But1_3.wt-0.5,But1_3.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Snapping == 2 then;
                    reaper.Main_OnCommand(1157,0);--Toggle snapping
                end;
            end;
            if L_But_Snapping < 0 then; CleanToolTip("L_But_Snapping") end; 
            -------------
            
            
            
            ---- 1.4 ----/Relative Snap/
            local Toggle_Relative = reaper.GetToggleCommandStateEx(0,41054);--Toggle relative grid snap
            local L_But_Relative = LeftMouseButton(X(But1_4.x),Y(But1_4.y), W(But1_4.w),H(But1_4.h),"RelativeEnable");
            if L_But_Relative == 0 then;
                local state;
                if Toggle_Relative == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Relative") end;
                Table.state2=state;
                SetToolTip("Relative snap "..state,X(But1_4.x),Y(But1_4.y),W(But1_4.w),H(But1_4.h),TOOL_TIP,"L_But_Relative");
                if Toggle_Relative == 1 then;
                    gfx.rect(X(But1_4.x)+2,Y(But1_4.y)+2, W(But1_4.w)-4,H(But1_4.h)-4,1);
                else;
                    gfx.rect(X(But1_4.x),Y(But1_4.y), W(But1_4.w),H(But1_4.h),1);
                end;
                TextByCenterAndResize("R",But1_4.xt,But1_4.yt, But1_4.wt,But1_4.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Relative == 1 or L_But_Relative == 2 or Toggle_Relative == 1 then;
                gfx.rect(X(But1_4.x)+2,Y(But1_4.y)+2, W(But1_4.w)-4,H(But1_4.h)-4,1);
                TextByCenterAndResize("R",But1_4.xt+0.25,But1_4.yt+0.25, But1_4.wt-0.5,But1_4.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Relative == 2 then;
                    reaper.Main_OnCommand(41054,0);--Toggle relative grid snap
                end;
            end;
            if L_But_Relative < 0 then; CleanToolTip("L_But_Relative") end;
            -----------
            
            
            
            ---- 1.5 ----(4)
            local L_But_Four = LeftMouseButton(X(But1_5.x),Y(But1_5.y), W(But1_5.w),H(But1_5.h),"L_But_Four");
            local Four4  = compare(divisionF,4);
            local Four4T = compare(divisionF,2.6666666666);
            if L_But_Four == 0 then;
                local state;
                if Four4 then state = "4 (On)" elseif Four4T then state = "4T (On)" else state = "4 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Four") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_5.x),Y(But1_5.y),W(But1_5.w),H(But1_4.h),TOOL_TIP,"L_But_Four");
                if Four4 or Four4T then;
                    gfx.rect(X(But1_5.x)+2,Y(But1_5.y)+2, W(But1_5.w)-4,H(But1_5.h)-4,1);
                else;
                    gfx.rect(X(But1_5.x),Y(But1_5.y), W(But1_5.w),H(But1_5.h),1);
                end;
                TextByCenterAndResize("4",But1_5.xt,But1_5.yt, But1_5.wt,But1_5.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Four >= 1 or Four4 or Four4T then;
                gfx.rect(X(But1_5.x)+2,Y(But1_5.y)+2, W(But1_5.w)-4,H(But1_5.h)-4,1);
                TextByCenterAndResize("4",But1_5.xt+0.25,But1_5.yt+0.25, But1_5.wt-0.5,But1_5.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Four == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,2.6666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,4,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_Four < 0 then; CleanToolTip("L_But_Four") end;
            -------------
            
            
            
            ---- 1.6 ----(2)
            local L_But_Two = LeftMouseButton(X(But1_6.x),Y(But1_6.y), W(But1_6.w),H(But1_6.h),"L_But_Two");
            local Two2  = compare(divisionF,2);
            local Two2T = compare(divisionF,1.3333333333);
            if L_But_Two == 0 then;
                local state;
                if Two2 then state = "2 (On)" elseif Two2T then state = "2T (On)" else state = "2 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Two") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_6.x),Y(But1_6.y),W(But1_6.w),H(But1_6.h),TOOL_TIP,"L_But_Two");
                if Two2 or Two2T then;
                    gfx.rect(X(But1_6.x)+2,Y(But1_6.y)+2, W(But1_6.w)-4,H(But1_6.h)-4,1);
                else;
                    gfx.rect(X(But1_6.x),Y(But1_6.y), W(But1_6.w),H(But1_6.h),1);
                end;
                TextByCenterAndResize("2",But1_6.xt,But1_6.yt, But1_6.wt,But1_6.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Two >= 1 or Two2 or Two2T then;
                gfx.rect(X(But1_6.x)+2,Y(But1_6.y)+2, W(But1_6.w)-4,H(But1_6.h)-4,1);
                TextByCenterAndResize("2",But1_6.xt+0.25,But1_6.yt+0.25, But1_6.wt-0.5,But1_6.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Two == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,1.3333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,2,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_Two < 0 then; CleanToolTip("L_But_Two") end;
            -------------
            
            
            
            ---- 1.7 ----(1)
            local L_But_One = LeftMouseButton(X(But1_7.x),Y(But1_7.y), W(But1_7.w),H(But1_7.h),"L_But_One");
            local One1  = compare(divisionF,1);
            local One1T = compare(divisionF,0.6666666666);
            if L_But_One == 0 then;
                local state;
                if One1 then state = "1 (On)" elseif One1T then state = "1T (On)" else state = "1 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_One") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_7.x),Y(But1_7.y),W(But1_7.w),H(But1_7.h),TOOL_TIP,"L_But_One");
                if One1 or One1T then;
                    gfx.rect(X(But1_7.x)+2,Y(But1_7.y)+2, W(But1_7.w)-4,H(But1_7.h)-4,1);
                else;
                    gfx.rect(X(But1_7.x),Y(But1_7.y), W(But1_7.w),H(But1_7.h),1);
                end;
                TextByCenterAndResize("1",But1_7.xt,But1_7.yt, But1_7.wt,But1_7.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_One >= 1 or One1 or One1T then;
                gfx.rect(X(But1_7.x)+2,Y(But1_7.y)+2, W(But1_7.w)-4,H(But1_7.h)-4,1);
                TextByCenterAndResize("1",But1_7.xt+0.25,But1_7.yt+0.25, But1_7.wt-0.5,But1_7.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_One == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.6666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,1,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_One < 0 then; CleanToolTip("L_But_One") end;
            -------------
            
            
            
            ---- 1.8 ----(1/2)
            local L_But_aHalf = LeftMouseButton(X(But1_8.x),Y(But1_8.y), W(But1_8.w),H(But1_8.h),"L_But_aHalf");
            local aHalf1_2  = compare(divisionF,0.5);
            local aHalf1_2T = compare(divisionF,0.3333333333);
            if L_But_aHalf == 0 then;
                local state;
                if aHalf1_2 then state = "1/2 (On)" elseif aHalf1_2T then state = "1/2T (On)" else state = "1/2 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_aHalf") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_8.x),Y(But1_8.y),W(But1_8.w),H(But1_8.h),TOOL_TIP,"L_But_aHalf");
                if aHalf1_2 or aHalf1_2T then;
                    gfx.rect(X(But1_8.x)+2,Y(But1_8.y)+2, W(But1_8.w)-4,H(But1_8.h)-4,1);
                else;
                    gfx.rect(X(But1_8.x),Y(But1_8.y), W(But1_8.w),H(But1_8.h),1);
                end;
                TextByCenterAndResize("1/2",But1_8.xt,But1_8.yt, But1_8.wt,But1_8.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_aHalf >= 1 or aHalf1_2 or aHalf1_2T then;
                gfx.rect(X(But1_8.x)+2,Y(But1_8.y)+2, W(But1_8.w)-4,H(But1_8.h)-4,1);
                TextByCenterAndResize("1/2",But1_8.xt+0.25,But1_8.yt+0.25, But1_8.wt-0.5,But1_8.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_aHalf == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.3333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.5,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_aHalf < 0 then; CleanToolTip("L_But_aHalf") end;
            -------------
            
            
            
            ---- 1.9 ----(1/4)
            local L_But_oneQuarter = LeftMouseButton(X(But1_9.x),Y(But1_9.y), W(But1_9.w),H(But1_9.h),"L_But_oneQuarter");
            local oneQuarter1_4  = compare(divisionF,0.25);
            local oneQuarter1_4T = compare(divisionF,0.16666666666);
            if L_But_oneQuarter == 0 then;
                local state;
                if oneQuarter1_4 then state = "1/4 (On)" elseif oneQuarter1_4T then state = "1/4T (On)" else state = "1/4 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneQuarter") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_9.x),Y(But1_9.y),W(But1_9.w),H(But1_9.h),TOOL_TIP,"L_But_oneQuarter");
                if oneQuarter1_4 or oneQuarter1_4T then;
                    gfx.rect(X(But1_9.x)+2,Y(But1_9.y)+2, W(But1_9.w)-4,H(But1_9.h)-4,1);
                else;
                    gfx.rect(X(But1_9.x),Y(But1_9.y), W(But1_9.w),H(But1_9.h),1);
                end;
                TextByCenterAndResize("1/4",But1_9.xt,But1_9.yt, But1_9.wt,But1_9.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneQuarter >= 1 or oneQuarter1_4 or oneQuarter1_4T then;
                gfx.rect(X(But1_9.x)+2,Y(But1_9.y)+2, W(But1_9.w)-4,H(But1_9.h)-4,1);
                TextByCenterAndResize("1/4",But1_9.xt+0.25,But1_9.yt+0.25, But1_9.wt-0.5,But1_9.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneQuarter == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.16666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.25,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end; 
                
            end;
            if L_But_oneQuarter < 0 then; CleanToolTip("L_But_oneQuarter") end;
            -------------
            
            
            
            ---- 1.10 ----(1/8)
            local L_But_oneEighth = LeftMouseButton(X(But1_10.x),Y(But1_10.y), W(But1_10.w),H(But1_10.h),"L_But_oneEighth");
            local oneEighth1_8  = compare(divisionF,0.125);
            local oneEighth1_8T = compare(divisionF,0.083333333333);
            if L_But_oneEighth == 0 then;
                local state;
                if oneEighth1_8 then state = "1/8 (On)" elseif oneEighth1_8T then state = "1/8T (On)" else state = "1/8 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneEighth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_10.x),Y(But1_10.y),W(But1_10.w),H(But1_10.h),TOOL_TIP,"L_But_oneEighth");
                if oneEighth1_8 or oneEighth1_8T then;
                    gfx.rect(X(But1_10.x)+2,Y(But1_10.y)+2, W(But1_10.w)-4,H(But1_10.h)-4,1);
                else;
                    gfx.rect(X(But1_10.x),Y(But1_10.y), W(But1_10.w),H(But1_10.h),1);
                end;
                TextByCenterAndResize("1/8",But1_10.xt,But1_10.yt, But1_10.wt,But1_10.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneEighth >= 1 or oneEighth1_8 or oneEighth1_8T then;
                gfx.rect(X(But1_10.x)+2,Y(But1_10.y)+2, W(But1_10.w)-4,H(But1_10.h)-4,1);
                TextByCenterAndResize("1/8",But1_10.xt+0.25,But1_10.yt+0.25, But1_10.wt-0.5,But1_10.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneEighth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.083333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneEighth < 0 then; CleanToolTip("L_But_oneEighth") end;
            -------------
            
            
            
            ---- 1.11 ----(1/16)
            local L_But_oneSixteenth = LeftMouseButton(X(But1_11.x),Y(But1_11.y), W(But1_11.w),H(But1_11.h),"L_But_oneSixteenth");
            local oneSixteenth1_16  = compare(divisionF,0.0625);
            local oneSixteenth1_16T = compare(divisionF,0.04166666666);
            if L_But_oneSixteenth == 0 then;
                local state;
                if oneSixteenth1_16 then state = "1/16 (On)" elseif oneSixteenth1_16T then state = "1/16T (On)" else state = "1/16 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneSixteenth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_11.x),Y(But1_11.y),W(But1_11.w),H(But1_11.h),TOOL_TIP,"L_But_oneSixteenth");
                if oneSixteenth1_16 or oneSixteenth1_16T then;
                    gfx.rect(X(But1_11.x)+2,Y(But1_11.y)+2, W(But1_11.w)-4,H(But1_11.h)-4,1);
                else;
                    gfx.rect(X(But1_11.x),Y(But1_11.y), W(But1_11.w),H(But1_11.h),1);
                end;
                TextByCenterAndResize("1/16",But1_11.xt,But1_11.yt, But1_11.wt,But1_11.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneSixteenth >= 1 or oneSixteenth1_16 or oneSixteenth1_16T then;
                gfx.rect(X(But1_11.x)+2,Y(But1_11.y)+2, W(But1_11.w)-4,H(But1_11.h)-4,1);
                TextByCenterAndResize("1/16",But1_11.xt+0.25,But1_11.yt+0.25, But1_11.wt-0.5,But1_11.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneSixteenth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.04166666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.0625,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneEighth < 0 then; CleanToolTip("L_But_oneEighth") end;
            -------------
            
            
            
            ---- 1.12 ----(1/32)
            local L_But_oneThirtyTwo = LeftMouseButton(X(But1_12.x),Y(But1_12.y), W(But1_12.w),H(But1_12.h),"L_But_oneThirtyTwo");
            local oneThirtyTwo1_32  = compare(divisionF,0.03125);
            local oneThirtyTwo1_32T = compare(divisionF,0.02083333333);
            if L_But_oneThirtyTwo == 0 then;
                local state;
                if oneThirtyTwo1_32 then state = "1/32 (On)" elseif oneThirtyTwo1_32T then state = "1/32T (On)" else state = "1/32 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneThirtyTwo") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_12.x),Y(But1_12.y),W(But1_12.w),H(But1_12.h),TOOL_TIP,"L_But_oneThirtyTwo");
                if oneThirtyTwo1_32 or oneThirtyTwo1_32T then;
                    gfx.rect(X(But1_12.x)+2,Y(But1_12.y)+2, W(But1_12.w)-4,H(But1_12.h)-4,1);
                else;
                    gfx.rect(X(But1_12.x),Y(But1_12.y), W(But1_12.w),H(But1_12.h),1);
                end;
                TextByCenterAndResize("1/32",But1_12.xt,But1_12.yt, But1_12.wt,But1_12.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneThirtyTwo >= 1 or oneThirtyTwo1_32 or oneThirtyTwo1_32T then;
                gfx.rect(X(But1_12.x)+2,Y(But1_12.y)+2, W(But1_12.w)-4,H(But1_12.h)-4,1);
                TextByCenterAndResize("1/32",But1_12.xt+0.25,But1_12.yt+0.25, But1_12.wt-0.5,But1_12.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneThirtyTwo == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.02083333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.03125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneThirtyTwo < 0 then; CleanToolTip("L_But_oneThirtyTwo") end;
            -------------
            
            
            
            ---- 1.13 ----(1/64)
            local L_But_oneSixtyFourth = LeftMouseButton(X(But1_13.x),Y(But1_13.y), W(But1_13.w),H(But1_13.h),"L_But_oneSixtyFourth");
            local oneSixtyFourth1_64  = compare(divisionF,0.015625);
            local oneSixtyFourth1_64T = compare(divisionF,0.01041666666);
            if L_But_oneSixtyFourth == 0 then;
                local state;
                if oneSixtyFourth1_64 then state = "1/64 (On)" elseif oneSixtyFourth1_64T then state = "1/64T (On)" else state = "1/64 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneSixtyFourth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_13.x),Y(But1_13.y),W(But1_13.w),H(But1_13.h),TOOL_TIP,"L_But_oneSixtyFourth");
                if oneSixtyFourth1_64 or oneSixtyFourth1_64T then;
                    gfx.rect(X(But1_13.x)+2,Y(But1_13.y)+2, W(But1_13.w)-4,H(But1_13.h)-4,1);
                else;
                    gfx.rect(X(But1_13.x),Y(But1_13.y), W(But1_13.w),H(But1_13.h),1);
                end;
                TextByCenterAndResize("1/64",But1_13.xt,But1_13.yt, But1_13.wt,But1_13.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneSixtyFourth >= 1 or oneSixtyFourth1_64 or oneSixtyFourth1_64T then;
                gfx.rect(X(But1_13.x)+2,Y(But1_13.y)+2, W(But1_13.w)-4,H(But1_13.h)-4,1);
                TextByCenterAndResize("1/64",But1_13.xt+0.25,But1_13.yt+0.25, But1_13.wt-0.5,But1_13.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneSixtyFourth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.01041666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.015625,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneSixtyFourth < 0 then; CleanToolTip("L_But_oneSixtyFourth") end;
            -------------
            
            
            
            ---- 1.14 ----(1/128)
            local L_But_oneHundredTwentyEighth = LeftMouseButton(X(But1_14.x),Y(But1_14.y), W(But1_14.w),H(But1_14.h),"L_But_oneHundredTwentyEighth");
            local oneHundredTwentyEighth1_128  = compare(divisionF,0.0078125);
            local oneHundredTwentyEighth1_128T = compare(divisionF,0.005208333333);
            if L_But_oneHundredTwentyEighth == 0 then;
                local state;
                if oneHundredTwentyEighth1_128 then state = "1/128 (On)" elseif oneHundredTwentyEighth1_128T then state = "1/128T (On)" else state = "1/128 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneHundredTwentyEighth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But1_14.x),Y(But1_14.y),W(But1_14.w),H(But1_14.h),TOOL_TIP,"L_But_oneHundredTwentyEighth");
                if oneHundredTwentyEighth1_128 or oneHundredTwentyEighth1_128T then;
                    gfx.rect(X(But1_14.x)+2,Y(But1_14.y)+2, W(But1_14.w)-4,H(But1_14.h)-4,1);
                else;
                    gfx.rect(X(But1_14.x),Y(But1_14.y), W(But1_14.w),H(But1_14.h),1);
                end;
                TextByCenterAndResize("1/128",But1_14.xt,But1_14.yt, But1_14.wt,But1_14.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneHundredTwentyEighth >= 1 or oneHundredTwentyEighth1_128 or oneHundredTwentyEighth1_128T then;
                gfx.rect(X(But1_14.x)+2,Y(But1_14.y)+2, W(But1_14.w)-4,H(But1_14.h)-4,1);
                TextByCenterAndResize("1/128",But1_14.xt+0.25,But1_14.yt+0.25, But1_14.wt-0.5,But1_14.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneHundredTwentyEighth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.005208333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.0078125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneHundredTwentyEighth < 0 then; CleanToolTip("L_But_oneHundredTwentyEighth") end;
            -------------
            
            
            
            ---- 1.15 ----/Triplet/  
            local L_But_Triplet = LeftMouseButton(X(But1_15.x),Y(But1_15.y), W(But1_15.w),H(But1_15.h),"L_But_Triplet");
            if L_But_Triplet == 0 then;
                local state;
                if grid_Format_T == true then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Triplet") end;
                Table.state2=state;
                SetToolTip("Triplet "..state,X(But1_15.x),Y(But1_15.y),W(But1_15.w),H(But1_15.h),TOOL_TIP,"L_But_Triplet");
                if grid_Format_T == true then;
                    gfx.rect(X(But1_15.x)+2,Y(But1_15.y)+2, W(But1_15.w)-4,H(But1_15.h)-4,1);
                else;
                    gfx.rect(X(But1_15.x),Y(But1_15.y), W(But1_15.w),H(But1_15.h),1);
                end;
                TextByCenterAndResize("T",But1_15.xt,But1_15.yt, But1_15.wt,But1_15.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Triplet == 1 or L_But_Triplet == 2 or grid_Format_T == true then;
                gfx.rect(X(But1_15.x)+2,Y(But1_15.y)+2, W(But1_15.w)-4,H(But1_15.h)-4,1);
                TextByCenterAndResize("T",But1_15.xt+0.25,But1_15.yt+0.25, But1_15.wt-0.5,But1_15.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Triplet == 2 then;
                    if grid_Format_T == true then;
                        reaper.GetSetProjectGrid(0,1,(divisionF/2) + divisionF,swingmodeF,swingshiftF); -- iz T
                    else;
                       reaper.GetSetProjectGrid(0,1,divisionF-(divisionF/3),swingmodeF,swingshiftF); -- v T
                    end;
                end;
            end;
            if L_But_Triplet < 0 then; CleanToolTip("L_But_Triplet") end;
            --------------
            
        else;
            
            
            ---- 2.1 ----/settings/
            local L_But_Seting = LeftMouseButton(X(But2_1.x),Y(But2_1.y), W(But2_1.w),H(But2_1.h),"Seting");
            if Counter(10,"SkipJS_Find")== 0 then;
                Pcall,ShowGridSettings = pcall(reaper.JS_Window_Find,"Snap/Grid Settings",true);
            end;
            if L_But_Seting == 0 then;
                SetToolTip("Shap/Grig Settings",X(But2_1.x),Y(But2_1.y),W(But2_1.w),H(But2_1.h),TOOL_TIP,"L_But_Seting");
                gfx.rect(X(But2_1.x),Y(But2_1.y), W(But2_1.w),H(But2_1.h),1);
                TextByCenterAndResize("⚙",But2_1.xt,But2_1.yt,But2_1.wt,But2_1.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Seting == 1 or L_But_Seting == 2 or ShowGridSettings and Pcall then;
                gfx.rect(X(But2_1.x)+2,Y(But2_1.y)+2, W(But2_1.w)-4,H(But2_1.h)-4,1);
                TextByCenterAndResize("⚙",But2_1.xt+0.5,But2_1.yt+0.5, But2_1.wt-1,But2_1.ht-1,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Seting == 2 then;
                    reaper.Main_OnCommand(40071,0);--Show snap/grid settings
                end;
            end;
            if L_But_Seting < 0 then; CleanToolTip("L_But_Seting") end;
            -------------
            
            
            
            
            ---- 2.2 ----/Grid lines/
            local Toggle_linesEnable = reaper.GetToggleCommandStateEx(0,40145);--Toggle grid lines
            local L_But_linesEnable = LeftMouseButton(X(But2_2.x),Y(But2_2.y), W(But2_2.w),H(But2_2.h),"linesEnable");
            if L_But_linesEnable == 0 then;
                local state;
                if Toggle_linesEnable == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_linesEnable") end;
                Table.state2=state;
                SetToolTip("Grig lines enabled "..state,X(But2_2.x),Y(But2_2.y),W(But2_2.w),H(But2_2.h),TOOL_TIP,"L_But_linesEnable");
                if Toggle_linesEnable == 1 then;
                    gfx.rect(X(But2_2.x)+2,Y(But2_2.y)+2, W(But2_2.w)-4,H(But2_2.h)-4,1);
                else;
                    gfx.rect(X(But2_2.x),Y(But2_2.y), W(But2_2.w),H(But2_2.h),1);
                end;
                TextByCenterAndResize("L",But2_2.xt,But2_2.yt, But2_2.wt,But2_2.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);   
            elseif L_But_linesEnable == 1 or L_But_linesEnable == 2 or Toggle_linesEnable == 1 then;
                gfx.rect(X(But2_2.x)+2,Y(But2_2.y)+2, W(But2_2.w)-4,H(But2_2.h)-4,1);
                TextByCenterAndResize("L",But2_2.xt+0.5,But2_2.yt+0.5, But2_2.wt-1,But2_2.ht-1,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);  
                if L_But_linesEnable == 2 then;
                    reaper.Main_OnCommand(40145,0);--Toggle grid lines
                end;  
            end;
            if L_But_linesEnable < 0 then; CleanToolTip("L_But_linesEnable") end;
            -------------
            
            
            
            ---- 2.3 ----/Snap Enable/
            local Toggle_Snapping = reaper.GetToggleCommandStateEx(0,1157);--Toggle snapping
            local L_But_Snapping = LeftMouseButton(X(But2_3.x),Y(But2_3.y), W(But2_3.w),H(But2_3.h),"SnappingEnable");
            if L_But_Snapping == 0 then;
                local state;
                if Toggle_Snapping == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Snapping") end;
                Table.state2=state;
                SetToolTip("Snap enabled "..state,X(But2_3.x),Y(But2_3.y),W(But2_3.w),H(But2_3.h),TOOL_TIP,"L_But_Snapping");
                if Toggle_Snapping == 1 then;
                    gfx.rect(X(But2_3.x)+2,Y(But2_3.y)+2, W(But2_3.w)-4,H(But2_3.h)-4,1);
                else;
                    gfx.rect(X(But2_3.x),Y(But2_3.y), W(But2_3.w),H(But2_3.h),1);
                end;
                TextByCenterAndResize("S",But2_3.xt,But2_3.yt, But2_3.wt,But2_3.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Snapping == 1 or L_But_Snapping == 2 or Toggle_Snapping == 1 then;
                gfx.rect(X(But2_3.x)+2,Y(But2_3.y)+2, W(But2_3.w)-4,H(But2_3.h)-4,1);
                TextByCenterAndResize("S",But2_3.xt+0.5,But2_3.yt+0.5, But2_3.wt-1,But2_3.ht-1,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Snapping == 2 then;
                    reaper.Main_OnCommand(1157,0);--Toggle snapping
                end;
            end;
            if L_But_Snapping < 0 then; CleanToolTip("L_But_Snapping") end; 
            -------------
            
            
            
            ---- 2.4 ----/Relative Snap/
            local Toggle_Relative = reaper.GetToggleCommandStateEx(0,41054);--Toggle relative grid snap
            local L_But_Relative = LeftMouseButton(X(But2_4.x),Y(But2_4.y), W(But2_4.w),H(But2_4.h),"RelativeEnable");
            if L_But_Relative == 0 then;
                local state;
                if Toggle_Relative == 1 then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Relative") end;
                Table.state2=state;
                SetToolTip("Relative snap / "..state,X(But2_4.x),Y(But2_4.y),W(But2_4.w),H(But2_4.h),TOOL_TIP,"L_But_Relative");
                if Toggle_Relative == 1 then;
                    gfx.rect(X(But2_4.x)+2,Y(But2_4.y)+2, W(But2_4.w)-4,H(But2_4.h)-4,1);
                else;
                    gfx.rect(X(But2_4.x),Y(But2_4.y), W(But2_4.w),H(But2_4.h),1);
                end;
                TextByCenterAndResize("R",But2_4.xt,But2_4.yt, But2_4.wt,But2_4.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Relative == 1 or L_But_Relative == 2 or Toggle_Relative == 1 then;
                gfx.rect(X(But2_4.x)+2,Y(But2_4.y)+2, W(But2_4.w)-4,H(But2_4.h)-4,1);
                TextByCenterAndResize("R",But2_4.xt+0.5,But2_4.yt+0.5, But2_4.wt-1,But2_4.ht-1,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Relative == 2 then;
                    reaper.Main_OnCommand(41054,0);--Toggle relative grid snap
                end;
            end;
            if L_But_Relative < 0 then; CleanToolTip("L_But_Relative") end;
            -------------
            
            
            
            ---- 2.5 ----(4)
            local L_But_Four = LeftMouseButton(X(But2_5.x),Y(But2_5.y), W(But2_5.w),H(But2_5.h),"L_But_Four");
            local Four4  = compare(divisionF,4);
            local Four4T = compare(divisionF,2.6666666666);
            if L_But_Four == 0 then;
                local state;
                if Four4 then state = "4 (On)" elseif Four4T then state = "4T (On)" else state = "4 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Four") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_5.x),Y(But2_5.y),W(But2_5.w),H(But2_5.h),TOOL_TIP,"L_But_Four");
                if Four4 or Four4T then;
                    gfx.rect(X(But2_5.x)+2,Y(But2_5.y)+2, W(But2_5.w)-4,H(But2_5.h)-4,1);
                else;
                    gfx.rect(X(But2_5.x),Y(But2_5.y), W(But2_5.w),H(But2_5.h),1);
                end;
                TextByCenterAndResize("4",But2_5.xt,But2_5.yt, But2_5.wt,But2_5.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Four >= 1 or Four4 or Four4T then;
                gfx.rect(X(But2_5.x)+2,Y(But2_5.y)+2, W(But2_5.w)-4,H(But2_5.h)-4,1);
                TextByCenterAndResize("4",But2_5.xt+0.25,But2_5.yt+0.25, But2_5.wt-0.5,But2_5.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Four == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,2.6666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,4,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_Four < 0 then; CleanToolTip("L_But_Four") end;
            -------------
            
            
            
            ---- 2.6 ----(2)
            local L_But_Two = LeftMouseButton(X(But2_6.x),Y(But2_6.y), W(But2_6.w),H(But2_6.h),"L_But_Two");
            local Two2  = compare(divisionF,2);
            local Two2T = compare(divisionF,1.3333333333);
            if L_But_Two == 0 then;
                local state;
                if Two2 then state = "2 (On)" elseif Two2T then state = "2T (On)" else state = "2 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Two") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_6.x),Y(But2_6.y),W(But2_6.w),H(But2_6.h),TOOL_TIP,"L_But_Two");
                if Two2 or Two2T then;
                    gfx.rect(X(But2_6.x)+2,Y(But2_6.y)+2, W(But2_6.w)-4,H(But2_6.h)-4,1);
                else;
                    gfx.rect(X(But2_6.x),Y(But2_6.y), W(But2_6.w),H(But2_6.h),1);
                end;
                TextByCenterAndResize("2",But2_6.xt,But2_6.yt, But2_6.wt,But2_6.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Two >= 1 or Two2 or Two2T then;
                gfx.rect(X(But2_6.x)+2,Y(But2_6.y)+2, W(But2_6.w)-4,H(But2_6.h)-4,1);
                TextByCenterAndResize("2",But2_6.xt+0.25,But2_6.yt+0.25, But2_6.wt-0.5,But2_6.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Two == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,1.3333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,2,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_Two < 0 then; CleanToolTip("L_But_Two") end;
            -------------
            
            
            
            ---- 2.7 ----(1)
            local L_But_One = LeftMouseButton(X(But2_7.x),Y(But2_7.y), W(But2_7.w),H(But2_7.h),"L_But_One");
            local One1  = compare(divisionF,1);
            local One1T = compare(divisionF,0.6666666666);
            if L_But_One == 0 then;
                local state;
                if One1 then state = "1 (On)" elseif One1T then state = "1T (On)" else state = "1 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_One") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_7.x),Y(But2_7.y),W(But2_7.w),H(But2_7.h),TOOL_TIP,"L_But_One");
                if One1 or One1T then;
                    gfx.rect(X(But2_7.x)+2,Y(But2_7.y)+2, W(But2_7.w)-4,H(But2_7.h)-4,1);
                else;
                    gfx.rect(X(But2_7.x),Y(But2_7.y), W(But2_7.w),H(But2_7.h),1);
                end;
                TextByCenterAndResize("1",But2_7.xt,But2_7.yt, But2_7.wt,But2_7.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_One >= 1 or One1 or One1T then;
                gfx.rect(X(But2_7.x)+2,Y(But2_7.y)+2, W(But2_7.w)-4,H(But2_7.h)-4,1);
                TextByCenterAndResize("1",But2_7.xt+0.25,But2_7.yt+0.25, But2_7.wt-0.5,But2_7.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_One == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.6666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,1,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_One < 0 then; CleanToolTip("L_But_One") end;
            -------------
            
            
            
            ---- 2.8 ----(1/2)
            local L_But_aHalf = LeftMouseButton(X(But2_8.x),Y(But2_8.y), W(But2_8.w),H(But2_8.h),"L_But_aHalf");
            local aHalf1_2  = compare(divisionF,0.5);
            local aHalf1_2T = compare(divisionF,0.3333333333);
            if L_But_aHalf == 0 then;
                local state;
                if aHalf1_2 then state = "1/2 (On)" elseif aHalf1_2T then state = "1/2T (On)" else state = "1/2 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_aHalf") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_8.x),Y(But2_8.y),W(But2_8.w),H(But2_8.h),TOOL_TIP,"L_But_aHalf");
                if aHalf1_2 or aHalf1_2T then;
                    gfx.rect(X(But2_8.x)+2,Y(But2_8.y)+2, W(But2_8.w)-4,H(But2_8.h)-4,1);
                else;
                    gfx.rect(X(But2_8.x),Y(But2_8.y), W(But2_8.w),H(But2_8.h),1);
                end;
                TextByCenterAndResize("1/2",But2_8.xt,But2_8.yt, But2_8.wt,But2_8.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_aHalf >= 1 or aHalf1_2 or aHalf1_2T then;
                gfx.rect(X(But2_8.x)+2,Y(But2_8.y)+2, W(But2_8.w)-4,H(But2_8.h)-4,1);
                TextByCenterAndResize("1/2",But2_8.xt+0.25,But2_8.yt+0.25, But2_8.wt-0.5,But2_8.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_aHalf == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.3333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.5,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end;
            if L_But_aHalf < 0 then; CleanToolTip("L_But_aHalf") end;
            -------------
            
            
            
            ---- 2.9 ----(1/4)
            local L_But_oneQuarter = LeftMouseButton(X(But2_9.x),Y(But2_9.y), W(But2_9.w),H(But2_9.h),"L_But_oneQuarter");
            local oneQuarter1_4  = compare(divisionF,0.25);
            local oneQuarter1_4T = compare(divisionF,0.16666666666);
            if L_But_oneQuarter == 0 then;
                local state;
                if oneQuarter1_4 then state = "1/4 (On)" elseif oneQuarter1_4T then state = "1/4T (On)" else state = "1/4 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneQuarter") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_9.x),Y(But2_9.y),W(But2_9.w),H(But2_9.h),TOOL_TIP,"L_But_oneQuarter");
                if oneQuarter1_4 or oneQuarter1_4T then;
                    gfx.rect(X(But2_9.x)+2,Y(But2_9.y)+2, W(But2_9.w)-4,H(But2_9.h)-4,1);
                else;
                    gfx.rect(X(But2_9.x),Y(But2_9.y), W(But2_9.w),H(But2_9.h),1);
                end;
                TextByCenterAndResize("1/4",But2_9.xt,But2_9.yt, But2_9.wt,But2_9.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneQuarter >= 1 or oneQuarter1_4 or oneQuarter1_4T then;
                gfx.rect(X(But2_9.x)+2,Y(But2_9.y)+2, W(But2_9.w)-4,H(But2_9.h)-4,1);
                TextByCenterAndResize("1/4",But2_9.xt+0.25,But2_9.yt+0.25, But2_9.wt-0.5,But2_9.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneQuarter == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.16666666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.25,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
                
            end;
            if L_But_oneQuarter < 0 then; CleanToolTip("L_But_oneQuarter") end;
            -------------
            
            
            
            ---- 2.10 ----(1/8)
            local L_But_oneEighth = LeftMouseButton(X(But2_10.x),Y(But2_10.y), W(But2_10.w),H(But2_10.h),"L_But_oneEighth");
            local oneEighth1_8  = compare(divisionF,0.125);
            local oneEighth1_8T = compare(divisionF,0.083333333333);
            if L_But_oneEighth == 0 then;
                local state;
                if oneEighth1_8 then state = "1/8 (On)" elseif oneEighth1_8T then state = "1/8T (On)" else state = "1/8 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneEighth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_10.x),Y(But2_10.y),W(But2_10.w),H(But2_10.h),TOOL_TIP,"L_But_oneEighth");
                if oneEighth1_8 or oneEighth1_8T then;
                    gfx.rect(X(But2_10.x)+2,Y(But2_10.y)+2, W(But2_10.w)-4,H(But2_10.h)-4,1);
                else;
                    gfx.rect(X(But2_10.x),Y(But2_10.y), W(But2_10.w),H(But2_10.h),1);
                end;
                TextByCenterAndResize("1/8",But2_10.xt,But2_10.yt, But2_10.wt,But2_10.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneEighth >= 1 or oneEighth1_8 or oneEighth1_8T then;
                gfx.rect(X(But2_10.x)+2,Y(But2_10.y)+2, W(But2_10.w)-4,H(But2_10.h)-4,1);
                TextByCenterAndResize("1/8",But2_10.xt+0.25,But2_10.yt+0.25, But2_10.wt-0.5,But2_10.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneEighth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.083333333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneEighth < 0 then; CleanToolTip("L_But_oneEighth") end;
            -------------
            
            
            
            ---- 2.11 ----(1/16)
            local L_But_oneSixteenth = LeftMouseButton(X(But2_11.x),Y(But2_11.y), W(But2_11.w),H(But2_11.h),"L_But_oneSixteenth");
            local oneSixteenth1_16  = compare(divisionF,0.0625);
            local oneSixteenth1_16T = compare(divisionF,0.04166666666);
            if L_But_oneSixteenth == 0 then;
                local state;
                if oneSixteenth1_16 then state = "1/16 (On)" elseif oneSixteenth1_16T then state = "1/16T (On)" else state = "1/16 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneSixteenth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_11.x),Y(But2_11.y),W(But2_11.w),H(But2_11.h),TOOL_TIP,"L_But_oneSixteenth");
                if oneSixteenth1_16 or oneSixteenth1_16T then;
                    gfx.rect(X(But2_11.x)+2,Y(But2_11.y)+2, W(But2_11.w)-4,H(But2_11.h)-4,1);
                else;
                    gfx.rect(X(But2_11.x),Y(But2_11.y), W(But2_11.w),H(But2_11.h),1);
                end;
                TextByCenterAndResize("1/16",But2_11.xt,But2_11.yt, But2_11.wt,But2_11.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneSixteenth >= 1 or oneSixteenth1_16 or oneSixteenth1_16T then;
                gfx.rect(X(But2_11.x)+2,Y(But2_11.y)+2, W(But2_11.w)-4,H(But2_11.h)-4,1);
                TextByCenterAndResize("1/16",But2_11.xt+0.25,But2_11.yt+0.25, But2_11.wt-0.5,But2_11.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneSixteenth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.04166666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.0625,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneEighth < 0 then; CleanToolTip("L_But_oneEighth") end;
            -------------
            
            
            
            ---- 2.12 ----(1/32)
            local L_But_oneThirtyTwo = LeftMouseButton(X(But2_12.x),Y(But2_12.y), W(But2_12.w),H(But2_12.h),"L_But_oneThirtyTwo");
            local oneThirtyTwo1_32  = compare(divisionF,0.03125);
            local oneThirtyTwo1_32T = compare(divisionF,0.02083333333);
            if L_But_oneThirtyTwo == 0 then;
                local state;
                if oneThirtyTwo1_32 then state = "1/32 (On)" elseif oneThirtyTwo1_32T then state = "1/32T (On)" else state = "1/32 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneThirtyTwo") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_12.x),Y(But2_12.y),W(But2_12.w),H(But2_12.h),TOOL_TIP,"L_But_oneThirtyTwo");
                if oneThirtyTwo1_32 or oneThirtyTwo1_32T then;
                    gfx.rect(X(But2_12.x)+2,Y(But2_12.y)+2, W(But2_12.w)-4,H(But2_12.h)-4,1);
                else;
                    gfx.rect(X(But2_12.x),Y(But2_12.y), W(But2_12.w),H(But2_12.h),1);
                end;
                TextByCenterAndResize("1/32",But2_12.xt,But2_12.yt, But2_12.wt,But2_12.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneThirtyTwo >= 1 or oneThirtyTwo1_32 or oneThirtyTwo1_32T then;
                gfx.rect(X(But2_12.x)+2,Y(But2_12.y)+2, W(But2_12.w)-4,H(But2_12.h)-4,1);
                TextByCenterAndResize("1/32",But2_12.xt+0.25,But2_12.yt+0.25, But2_12.wt-0.5,But2_12.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneThirtyTwo == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.02083333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.03125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneThirtyTwo < 0 then; CleanToolTip("L_But_oneThirtyTwo") end;
            -------------
            
            
            
            ---- 2.13 ----(1/64)
            local L_But_oneSixtyFourth = LeftMouseButton(X(But2_13.x),Y(But2_13.y), W(But2_13.w),H(But2_13.h),"L_But_oneSixtyFourth");
            local oneSixtyFourth1_64  = compare(divisionF,0.015625);
            local oneSixtyFourth1_64T = compare(divisionF,0.01041666666);
            if L_But_oneSixtyFourth == 0 then;
                local state;
                if oneSixtyFourth1_64 then state = "1/64 (On)" elseif oneSixtyFourth1_64T then state = "1/64T (On)" else state = "1/64 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneSixtyFourth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_13.x),Y(But2_13.y),W(But2_13.w),H(But2_13.h),TOOL_TIP,"L_But_oneSixtyFourth");
                if oneSixtyFourth1_64 or oneSixtyFourth1_64T then;
                    gfx.rect(X(But2_13.x)+2,Y(But2_13.y)+2, W(But2_13.w)-4,H(But2_13.h)-4,1);
                else;
                    gfx.rect(X(But2_13.x),Y(But2_13.y), W(But2_13.w),H(But2_13.h),1);
                end;
                TextByCenterAndResize("1/64",But2_13.xt,But2_13.yt, But2_13.wt,But2_13.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneSixtyFourth >= 1 or oneSixtyFourth1_64 or oneSixtyFourth1_64T then;
                gfx.rect(X(But2_13.x)+2,Y(But2_13.y)+2, W(But2_13.w)-4,H(But2_13.h)-4,1);
                TextByCenterAndResize("1/64",But2_13.xt+0.25,But2_13.yt+0.25, But2_13.wt-0.5,But2_13.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneSixtyFourth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.01041666666,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.015625,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneSixtyFourth < 0 then; CleanToolTip("L_But_oneSixtyFourth") end;
            -------------
            
            
            
            ---- 2.14 ----(1/128)
            local L_But_oneHundredTwentyEighth = LeftMouseButton(X(But2_14.x),Y(But2_14.y), W(But2_14.w),H(But2_14.h),"L_But_oneHundredTwentyEighth");
            local oneHundredTwentyEighth1_128  = compare(divisionF,0.0078125);
            local oneHundredTwentyEighth1_128T = compare(divisionF,0.005208333333);
            if L_But_oneHundredTwentyEighth == 0 then;
                local state;
                if oneHundredTwentyEighth1_128 then state = "1/128 (On)" elseif oneHundredTwentyEighth1_128T then state = "1/128T (On)" else state = "1/128 (Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_oneHundredTwentyEighth") end;
                Table.state2=state;
                SetToolTip("Grid: "..state.."\n"..("-"):rep(5).."\n"..str4F..str3F..str2F..str1F,X(But2_14.x),Y(But2_14.y),W(But2_14.w),H(But2_14.h),TOOL_TIP,"L_But_oneHundredTwentyEighth");
                if oneHundredTwentyEighth1_128 or oneHundredTwentyEighth1_128T then;
                    gfx.rect(X(But2_14.x)+2,Y(But2_14.y)+2, W(But2_14.w)-4,H(But2_14.h)-4,1);
                else;
                    gfx.rect(X(But2_14.x),Y(But2_14.y), W(But2_14.w),H(But2_14.h),1);
                end;
                TextByCenterAndResize("1/128",But2_14.xt,But2_14.yt, But2_14.wt,But2_14.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_oneHundredTwentyEighth >= 1 or oneHundredTwentyEighth1_128 or oneHundredTwentyEighth1_128T then;
                gfx.rect(X(But2_14.x)+2,Y(But2_14.y)+2, W(But2_14.w)-4,H(But2_14.h)-4,1);
                TextByCenterAndResize("1/128",But2_14.xt+0.25,But2_14.yt+0.25, But2_14.wt-0.5,But2_14.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_oneHundredTwentyEighth == 2 then;
                    if grid_Format_T then;
                        reaper.GetSetProjectGrid(0,1,0.005208333333,swingmodeF,swingshiftF);
                    else;
                        reaper.GetSetProjectGrid(0,1,0.0078125,swingmodeF,swingshiftF);
                    end;
                    ---
                    if CLICK_BUT_CLOSE_WIN == 1 and gfx.dock(-1)&1==0 then reaper.atexit(exit)return end;
                    ---
                end;
            end; 
            if L_But_oneHundredTwentyEighth < 0 then; CleanToolTip("L_But_oneHundredTwentyEighth") end;
            -------------
            
            
            
            ---- 2.15 ----/Triplet/
            local L_But_Triplet = LeftMouseButton(X(But2_15.x),Y(But2_15.y), W(But2_15.w),H(But2_15.h),"L_But_Triplet");
            if L_But_Triplet == 0 then;
                local state;
                if grid_Format_T == true then state = "(On)" else state = "(Off)" end;
                if Table.state2~=state then CleanToolTip("L_But_Triplet") end;
                Table.state2=state;
                SetToolTip("Triplet "..state,X(But2_15.x),Y(But2_15.y),W(But2_15.w),H(But2_15.h),TOOL_TIP,"L_But_Triplet");
                if grid_Format_T == true then;
                    gfx.rect(X(But2_15.x)+2,Y(But2_15.y)+2, W(But2_15.w)-4,H(But2_15.h)-4,1);
                else;
                    gfx.rect(X(But2_15.x),Y(But2_15.y), W(But2_15.w),H(But2_15.h),1);
                end;
                TextByCenterAndResize("T",But2_15.xt,But2_15.yt, But2_15.wt,But2_15.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            elseif L_But_Triplet == 1 or L_But_Triplet == 2 or grid_Format_T == true then;
                gfx.rect(X(But2_15.x)+2,Y(But2_15.y)+2, W(But2_15.w)-4,H(But2_15.h)-4,1);
                TextByCenterAndResize("T",But2_15.xt+0.25,But2_15.yt+0.25, But2_15.wt-0.5,But2_15.ht-0.5,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                if L_But_Triplet == 2 then;
                    if grid_Format_T == true then;
                        reaper.GetSetProjectGrid(0,1,(divisionF/2) + divisionF,swingmodeF,swingshiftF); -- iz T
                    else;
                       reaper.GetSetProjectGrid(0,1,divisionF-(divisionF/3),swingmodeF,swingshiftF); -- v T
                    end;
                end;
            end;
            if L_But_Triplet < 0 then; CleanToolTip("L_But_Triplet") end;
            --------------
            
            
        end;
        -- body_end --
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
            
            local checkBold;
            if TextBoldNorm == 98 then checkBold = "!" else checkBold = "" end;
            
            local checkZoomInOn;
            if FontSize ~= 0 then checkZoomInOn = "!" else checkZoomInOn = "" end;
            
            local grayedLClose;
            local checkedLClose;
            if FOCUS_LOST_CLOSE == 1 then checkedLClose = "!" else checkedLClose = "" end;
            if Dock&1 ~= 0 then grayedLClose  = "#" else grayedLClose = "" end;
            
            local grayedButWClose;
            local checkedButWClose;
            if CLICK_BUT_CLOSE_WIN == 1 then checkedButWClose = "!" else checkedButWClose = "" end;
            if Dock&1 ~= 0 then grayedButWClose  = "#" else grayedButWClose = "" end;
            
            local checkRemFocWin;
            if RemFocusWin == 1 then checkRemFocWin = "!" else checkRemFocWin = "" end;
            
            local checkedTTip;
            if TOOL_TIP == 1 then checkedTTip = "!" else checkedTTip = "" end;
            
            local grayedPTop;
            local checkedPTop;
            if PIN_ON_TOP == 1 then checkedPTop = "!" else checkedPTop = "" end;
            if Dock&1 ~= 0 then grayedPTop  = "#" else grayedPTop = "" end;
            
            local
            showmenu = gfx.showmenu(--[[ 1]]checkedDock.."Dock Grid switch in Docker||"..
                                    --[[ 2]]"⚙ Snap / Grid Settings|"..
                                    --[[ 3]]checkedTTip.."Tool Tip|"..
                                    --[[ 4]]grayedPTop..checkedPTop.."pin on top|"..
                                    --[[ 5]]"# #|"..
                                    --[[ 6]]"# #||"..
                                    --[[->]]">Window|"..
                                    --[[ 7]]"#Close Window||"..
                                    --[[ 8]]grayedLClose..checkedLClose.."Close window when focus is lost|"..
                                    --[[ 9]]grayedButWClose..checkedButWClose.."When click button close window||"..
                                    --[[10]]"<"..checkRemFocWin.."Remove focus from window (useful when switching Screenset)|"..
                                    --[[->]]">View|"..
                                    --[[->]]">Color|"..
                                    --[[11]]"Customize text color...|"..
                                    --[[12]]"Default text color||"..
                                    --[[13]]"Customize background color|"..
                                    --[[14]]"Default background color||"..
                                    --[[15]]"Customize Gui color|"..
                                    --[[16]]"Default Gui color||"..
                                    --[[17]]"<Default All color|"..
                                    --[[18]]checkBold.."Text: Normal / Bold|"..
                                    --[[19]]"<"..checkZoomInOn.."Font Size|"..
                                    --[[->]]">Default|"..
                                    --[[20]]"Default All color|"..
                                    --[[21]]"<Default Script|"..
                                    --[[->]]">Support project|"..
                                    --[[22]]"Dodate||"..
                                    --[[23]]"Bug report (Of site forum)|"..
                                    --[[24]]"< Bug report (Rmm forum)||"..
                                    --[[25]]"Close Grid switch window");
            
            
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
                reaper.Main_OnCommand(40071,0);--Show snap/grid settings
                ----
            elseif showmenu == 3 then;
                ----
                if TOOL_TIP == 1 then TOOL_TIP = 0 else TOOL_TIP = 1 end;
                reaper.SetExtState(section,"TOOL_TIP",TOOL_TIP,true);
                ----
            elseif showmenu == 4 then;
                ----
                if PIN_ON_TOP == 1 then PIN_ON_TOP = 0 else PIN_ON_TOP = 1 end;
                reaper.SetExtState(section,"PIN_ON_TOP",PIN_ON_TOP,true);
                --
                exit(); 
                dofile(filename:gsub('\\','/'));
                return;
                ----
            elseif showmenu == 5 then;
                ----
                
                ----
            elseif showmenu == 6 then;
                ----
                
                ----
            elseif showmenu == 7 then;
                ----
                
                ----
            elseif showmenu == 8 then;
                ----
                if FOCUS_LOST_CLOSE == 1 then FOCUS_LOST_CLOSE = 0 else FOCUS_LOST_CLOSE = 1 end;
                reaper.SetExtState(section,"FOCUS_LOST_CLOSE",FOCUS_LOST_CLOSE,true);
                if FOCUS_LOST_CLOSE == 1 then;
                    reaper.SetExtState(section,"RemFocusWin",0,true);RemFocusWin=0;
                end;
                ----
            elseif showmenu == 9 then;---
                ----
                if CLICK_BUT_CLOSE_WIN == 1 then CLICK_BUT_CLOSE_WIN = 0 else CLICK_BUT_CLOSE_WIN = 1 end;
                reaper.SetExtState(section,"CLICK_BUT_CLOSE_WIN",CLICK_BUT_CLOSE_WIN,true);
                ----
            elseif showmenu == 10 then;
                ----
                if RemFocusWin == 1 then RemFocusWin = 0 else RemFocusWin = 1 end;
                reaper.SetExtState(section,"RemFocusWin",RemFocusWin,true);
                if RemFocusWin == 1 then;
                    reaper.SetExtState(section,"FOCUS_LOST_CLOSE",0,true);FOCUS_LOST_CLOSE=0;
                end;
                ----
            elseif showmenu == 11 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Text","R"..r.."G"..g.."B"..b,true);
                    R_Text,G_Text,B_Text = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 12 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                Start_GUI();
                ----
            elseif showmenu == 13 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Background","R"..r.."G"..g.."B"..b,true);
                    R_Back,G_Back,B_Back = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 14 then;
                ----
                reaper.DeleteExtState(section,"Color_Background",true);
                R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                Start_GUI();
                ----
            elseif showmenu == 15 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Gui","R"..r.."G"..g.."B"..b,true);
                    R_Gui,G_Gui,B_Gui = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 16 then;
                ----
                reaper.DeleteExtState(section,"Color_Gui",true);
                R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                Start_GUI();
                ----
            elseif showmenu == 17 then;
                ----
                local MB = reaper.MB("Eng:\nSet all colors to default ?\n\nRus:\nУстановить все цвета по умолчанию ?","Default Color",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"Color_Text",true);
                    R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                    reaper.DeleteExtState(section,"Color_Background",true);
                    R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                    reaper.DeleteExtState(section,"Color_Gui",true);
                    R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 18 then;
                ----
                if TextBoldNorm == 98 then TextBoldNorm = 0 else TextBoldNorm = 98 end;
                reaper.SetExtState(section,"TextBoldNorm",TextBoldNorm,true);
                Start_GUI();
                ----
            elseif showmenu == 19 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("font size",1,"Size: -- < Default = 0 > ++ ",FontSize or 0);
                if retval and tonumber(retvals_csv) then;
                    reaper.SetExtState(section,"FontSize",retvals_csv,true);
                    FontSize = tonumber(retvals_csv);
                    Start_GUI();
                end;
                ----
            elseif showmenu == 20 then;
                ----
                local MB = reaper.MB("Eng:\nSet all colors to default ?\n\nRus:\nУстановить все цвета по умолчанию ?","Default Color",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"Color_Text",true);
                    R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                    reaper.DeleteExtState(section,"Color_Background",true);
                    R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                    reaper.DeleteExtState(section,"Color_Gui",true);
                    R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 21 then;
                ----
                local MB = reaper.MB("Eng:\nDo you really want to delete all saved settings ?\n\nRus:\nВы действительно хотите удалить все сохраненные настройки ?","Default Script",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"TOOL_TIP",true);
                    reaper.DeleteExtState(section,"FOCUS_LOST_CLOSE",true);
                    reaper.DeleteExtState(section,"CLICK_BUT_CLOSE_WIN",true);
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
                end;
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
            end;
        end;
        ----< End Show Menu >----
        
        ------------------------------
        
        --body--
        
        ------------------------------
        if gfx.getchar() >= 0 then reaper.defer(loop);else;reaper.atexit(exit)return;end;
    end;
    ----< End function loop(); >----
    
    
    
    ---------
    function exit();
        reaper.SetToggleCommandState(sectionID,cmdID,0);
        reaper.RefreshToolbar2(sectionID,cmdID);
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