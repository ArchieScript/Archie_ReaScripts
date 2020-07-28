--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Gui
   * Description: Color switch
   * Author:      Archie
   * Version:     1.04
   * Описание:    Переключатель цвета
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   ---(---)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [06.12.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ---- / Default Color / ----
    local R_Back_Default =  50;
    local G_Back_Default =  50;
    local B_Back_Default =  50;

    local R_Text_Default = 30;
    local G_Text_Default = 30;
    local B_Text_Default = 30;

    local R_Gui__Default = 170;
    local G_Gui__Default = 170;
    local B_Gui__Default = 170;
    ---------------------------


    -----------/ всплывающая подсказка /------------
    local
    T_Tip = {
             Btn1  = "Track: Set to custom color"           ,
             Btn2  = "Track: Set to random color"           ,
             Btn3  = "Track: Set to one random color"       ,
             Btn4  = "Track: Set to default color"          ,
             Btn5  = "Item: Set to custom color"            ,
             Btn6  = "Item: Set to random colors"           ,
             Btn7  = "Item: Set to one random color"        ,
             Btn8  = "Item: Set to default color"           ,
             Btn9  = "Take: Set active take to custom color",
             Btn10 = "Take: Set active take to default color"
            };
     ------------------------------------------------



    -----------/ градиент - цвет кнопок /-----------
    local gradBut = {nil,
                     nil,
                     {{.1,.1,1},{.4,1,1},{.1,.1,1}},
                     {{.3,.3,.3},{1,1,1},{.3,.3,.3}},
                     nil,
                     nil,
                     {{.1,.1,1},{.4,1,1},{.1,.1,1}},
                     {{.3,.3,.3},{1,1,1},{.3,.3,.3}},
                     nil,
                     {{.3,.3,.3},{1,1,1},{.3,.3,.3}}
                    };
    ------------------------------------------------


    ---------------/ Координаты кнопок /--------------------------------------------------------
    local B_1_1G  = {x=1   , y=10, w=9.5, h=80,   xt=2   , yt=11, wt=7.5, ht=78,   txt="Tr  c"};
    local B_1_2G  = {x=11.5, y=10, w=9.5, h=80,   xt=12.5, yt=11, wt=7.5, ht=78,   txt="Tr  ?"};
    local B_1_3G  = {x=22  , y=10, w=9.5, h=80,   xt=23  , yt=11, wt=7.5, ht=78,   txt="Tr  ?"};
    local B_1_4G  = {x=32.5, y=10, w=9.5, h=80,   xt=33.5, yt=11, wt=7.5, ht=78,   txt="Tr  *"};
    local B_1_5G  = {x=43  , y=10, w=9.5, h=80,   xt=44  , yt=11, wt=7.5, ht=78,   txt="It  c"};
    local B_1_6G  = {x=53.5, y=10, w=9.5, h=80,   xt=54.5, yt=11, wt=7.5, ht=78,   txt="It  ?"};
    local B_1_7G  = {x=64  , y=10, w=9.5, h=80,   xt=65  , yt=11, wt=7.5, ht=78,   txt="It  ?"};
    local B_1_8G  = {x=74.5, y=10, w=9.5, h=80,   xt=75.5, yt=11, wt=7.5, ht=78,   txt="It  *"};
    local B_1_9G  = {x=85  , y=10, w=6.5, h=80,   xt=86  , yt=11, wt=4.5, ht=78,   txt="Tk c" };
    local B_1_10G = {x=92.5, y=10, w=6.5, h=80,   xt=93.5, yt=11, wt=4.5, ht=78,   txt="Tk *" };

    local B_2_G = {y=5, h=40, yt=6, ht=38};
    -----
    local B_1_1V  = {x=10, y=1   , w=80, h=9.5,   xt=11, yt=2   , wt=78, ht=7.5,   txt="Tr  c"};
    local B_1_2V  = {x=10, y=11.5, w=80, h=9.5,   xt=11, yt=12.5, wt=78, ht=7.5,   txt="Tr  ?"};
    local B_1_3V  = {x=10, y=22  , w=80, h=9.5,   xt=11, yt=23  , wt=78, ht=7.5,   txt="Tr  ?"};
    local B_1_4V  = {x=10, y=32.5, w=80, h=9.5,   xt=11, yt=33.5, wt=78, ht=7.5,   txt="Tr  *"};
    local B_1_5V  = {x=10, y=43  , w=80, h=9.5,   xt=11, yt=44  , wt=78, ht=7.5,   txt="It  c"};
    local B_1_6V  = {x=10, y=53.5, w=80, h=9.5,   xt=11, yt=54.5, wt=78, ht=7.5,   txt="It  ?"};
    local B_1_7V  = {x=10, y=64  , w=80, h=9.5,   xt=11, yt=65  , wt=78, ht=7.5,   txt="It  ?"};
    local B_1_8V  = {x=10, y=74.5, w=80, h=9.5,   xt=11, yt=75.5, wt=78, ht=7.5,   txt="It  *"};
    local B_1_9V  = {x=10, y=85  , w=80, h=6.5,   xt=11, yt=86  , wt=78, ht=4.5,   txt="Tk c" };
    local B_1_10V = {x=10, y=92.5, w=80, h=6.5,   xt=11, yt=93.5, wt=78, ht=4.5,   txt="Tk *" };

    local B_2_V = {x=5, w=50, xt=6, wt=48};
    -----
    --------------------------------------------------------------------------------------------


    ---------------/ Координаты градиент /------------------------------------------------------
    local fade_vG = {w=15,h=15};--ширина слайд
    local Grd_clG = {col=nil};--град цвет{...}
    --------------------------------------------------------------------------------------------


    local GRD_Bright,GRD_Bright2;

    --========================================
    ----/ Конвертируем в проценты /----
    local function W(w);
        return (gfx.w/100*w);
    end;
    local X = W;
    local function H(h);
        return (gfx.h/100*h);
    end;
    local Y = H;
    --========================================



    --========================================
    local function OpenWebSite(path);
        local OS,cmd = reaper.GetOS();
        if OS == "OSX32" or OS == "OSX64" then;
            os.execute('open "'..path..'"');
        else;
            os.execute('start "" '..path);
        end;
    end;
    --========================================



    --=======================================
    local function SetColorRGB(r,g,b,a,mode);
        gfx.set(r/256,g/256,b/256,a,mode);
    end;
    --=======================================




    --=======================================
    local function gfxSaveScrin_buf(buf,w,h);
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
    --=======================================




    --================================================================================================
    --- / Всплывающая подсказка / -----------
    local ToolTip = {};
    local function SetToolTip(Str,x,y,w,h,showTip,buf);
        if showTip == 1 or showTip < 0 then;
            ToolTip.timeToShow = 10; -- time until display tooltip in number of loop
            if gfx.mouse_x > x and  gfx.mouse_y > y and gfx.mouse_x < x+w and gfx.mouse_y < y+h then;
                if gfx.mouse_x == ToolTip.x_tip and gfx.mouse_y == ToolTip.y_tip then ToolTip.tip=(ToolTip.tip or 0)+1 else ToolTip.tip=0 end;
                ToolTip.x_tip, ToolTip.y_tip = gfx.mouse_x, gfx.mouse_y;
                if ToolTip.tip == ToolTip.timeToShow then;
                    if showTip > 0 then;
                        local x,y = gfx.clienttoscreen(gfx.mouse_x,gfx.mouse_y);
                        reaper.TrackCtl_SetToolTip(Str,x+20,y+10,true);
                        ToolTip.tipClean = {};
                        ToolTip.tipClean[buf] = true;
                    end;
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
    --================================================================================================





    --================================================================================================
    local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags,r,g,b,x_pix,y_pix,w_pix,h_pix);
        local gfx_x,gfx_y = gfx.x,gfx.y;
        local gfx_w = gfx.w/100*w;
        local gfx_h = gfx.h/100*h;
        if tonumber(w_pix)then gfx_w = math.abs(w_pix)end;
        if tonumber(h_pix)then gfx_h = math.abs(h_pix)end;

        gfx.setfont(1,"Arial",10000);
        local lengthFontW,heightFontH = gfx.measurestr(string);

        local F_sizeW = gfx_w/lengthFontW*gfx.texth;
        local F_sizeH = gfx_h/heightFontH*gfx.texth;
        local F_size = math.min(F_sizeW+ZoomInOn,F_sizeH+ZoomInOn);
        if F_size < 1 then F_size = 1 end;
        gfx.setfont(1,"Arial",F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117

        local lengthFont,heightFont = gfx.measurestr(string);
        if tonumber(x_pix) then;
            gfx.x = math.abs(x_pix) + (gfx_w - lengthFont)/2;
        else;
            gfx.x = gfx.w/100*x + (gfx_w - lengthFont)/2;
        end;
        if tonumber(y_pix) then;
            gfx.y = math.abs(y_pix) + (gfx_h - heightFont )/2;
        else;
           gfx.y = gfx.h/100*y + (gfx_h - heightFont )/2;
        end;
        gfx.set(r/256,g/256,b/256,1);
        gfx.drawstr(string);
        gfx.x,gfx.y = gfx_x,gfx_y;
    end;
    --===================================================================



    --====================================================================
    ---/ Клик мыши /---
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
    --====================================================================



    --====================================================================
    local dcFT = {dblCl=0};
    local function doubleClick(x,y,w,h,delay);
        delay = delay / 1000
        local cl = LeftMouseButton(x, y, w, h, 8192);
        dcFT.dblCl=dcFT.dblCl;
        if dcFT.time and dcFT.time+delay < os.clock() and cl <= 0 then dcFT.time = false dcFT.dblCl = 0  end;
        local msx,msy = gfx.mouse_x, gfx.mouse_y;
        if msx < x or msx > x+w or msy < y or msy > y+h then cl=0 dcFT.time = false dcFT.dblCl = 0  end;
        if not dcFT.time and cl == 1 then dcFT.time = os.clock() end;
        if dcFT.time and cl == 2 then dcFT.dblCl = dcFT.dblCl + 1 end;
        if dcFT.dblCl >= 2 then;
            if dcFT.time+delay>=os.clock()then dcFT.time=false dcFT.dblCl=0 return true end;
            dcFT.time = false dcFT.dblCl = 0;
       end;
       return false;
    end;
    --====================================================================



    --====================================================================
    --- / Счетчик для пропуска / ---
    local function Counter();
        local t={};return function(x,b)b=b or 1 t[b]=(t[b]or 0)+1 if t[b]>(x or math.huge)then t[b]=0 end return t[b]end;
    end;Counter = Counter(); -- Counter(x,buf); x=reset
    --====================================================================



    --====================================================================
    -- Сравните два числа с учетом погрешности плавающей запятой --
    local function compare(x,y);
        if not tonumber(x)or not tonumber(y)then return false end;
        return math.abs(x-y) < 0.0000001;
    end;
    ----------------------------------------------------------------------



    --====================================================================================
    local function gradient(buf,vertically,x,y,w,h,white,black,alfa,col,brightness,frame,UnColGrd);
        if h <= 5 then h = 0 end;
        if w <= 5 then w = 0 end;
        buf = tonumber(buf)or 948;if buf<0 then buf=0 end;if buf>1023 then buf=1023 end;
        local b = brightness;
        if b < -1 then b = -1 elseif b > 1 then b = 1 end;
        alfa = tonumber(alfa)or 1;
        if alfa < 0 then alfa = 0 elseif alfa > 1 then alfa = 1 end;
        if type(col) ~= "table" or type(col[1])~= "table" then;
            col =  {{1,1,1},{1,1,1},{1,.9,.9},{1,.8,.8},{1,.7,.7},{1,.6,.6},{1,.5,.5},{1,.4,.4},{1,.3,.3},{1,.2,.2},{1,.1,.1},
                   {1,0,0},{1,.1,0},{1,.2,0},{1,.3,0},{1,.4,0},{1,.5,0},{1,.6,0},{1,.7,0},{1,.8,0},{1,.9,0},
                   {1,1,0},{.9,1,0},{.8,1,0},{.7,1,0},{.6,1,0},{.5,1,0},{.4,1,0},{.3,1,0},{.2,1,0},{.1,1,0},
                   {0,1,0},{0,1,.1},{0,1,.2},{0,1,.3},{0,1,.4},{0,1,.5},{0,1,.6},{0,1,.7},{0,1,.8},{0,1,.9},
                   {0,1,1},{0,.9,1},{0,.8,1},{0,.7,1},{0,.6,1},{0,.5,1},{0,.4,1},{0,.3,1},{0,.2,1},{0,.1,1},
                   {0,0,1},{.1,0,1},{.2,0,1},{.3,0,1},{.4,0,1},{.5,0,1},{.6,0,1},{.7,0,1},{.8,0,1},{.9,0,1},
                   {1,0,1},{1,0,.9},{1,0,.8},{1,0,.7},{1,0,.6},{1,0,.5},{1,0,.4},{1,0,.3},{1,0,.2},{1,0,.1},
                   {1,0,0},{.9,0,0},{.8,0,0},{.7,0,0},{.6,0,0},{.5,0,0},{.4,0,0},{.3,0,0},{.2,0,0},{.1,0,0},{0,0,0},{0,0,0}};
        end;
        if #col == 1 then col[2] = col[1] end;
        -----
        local gfx_r,gfx_g,gfx_b,gfx_a = gfx.r,gfx.g,gfx.b,gfx.a;
        gfx.dest = buf;
        gfx.setimgdim(buf,-1,-1);
        local x_s,y_s,w_s,h_s;
        if vertically == true then;
            w_s,h_s = 200,10*(#col-1);
        else;
            w_s,h_s=10*(#col-1),200;
        end;
        gfx.setimgdim(buf,w_s,h_s);
        gfx.a = 1;
        -----
        if vertically ~= true then;
            ----
            for i = 1,#col-1 do;
                gfx.gradrect(0+10*(i-1), 0, 10, 200,
                             col[i][1],col[i][2],col[i][3], 1,
                             ((col[i+1][1])-(col[i][1])) / 10,
                             ((col[i+1][2])-(col[i][2])) / 10,
                             ((col[i+1][3])-(col[i][3])) / 10,
                             0);
            end;
            -----
            -----
            if white == true then;
                local rw = b+1;
                if rw > 1 then rw = 1 elseif rw < 0 then rw = 0 end;
                gfx.gradrect(0,0,(#col-1)*10,5, rw,rw,rw,1);
                gfx.gradrect(0,5,(#col-1)*10,95, rw,rw,rw,1, 0,0,0,0, 0,0,0,(0-1)/(95));
            end;
            if black == true then;
                local rb = b;
                if rb > 1 then rb = 1 elseif rb < 0 then rb = 0 end;
                gfx.gradrect(0,195,(#col-1)*10,5, rb,rb,rb,1);
                gfx.gradrect(0,100,(#col-1)*10,95, rb,rb,rb,0, 0,0,0,0, 0,0,0,1/(95));
            end;
            ----
            local rwa = b;
            if white == true then rwa = rwa*2-1 end;
            if rwa < 0 then rwa = 0 elseif rwa > 1 then rwa = 1 end;
            gfx.gradrect(0,0,(#col-1)*10,200,1,1,1,rwa);
            ----
            local rba = b-b*2;
            if black == true then rba = (rba*2-1)end;
            if rba < 0 then rba = 0 elseif rba > 1 then rba = 1 end;
            gfx.gradrect(0,0,(#col-1)*10,200,0,0,0,rba);
            -----
            if UnColGrd == true then;
                gfx.gradrect(0,0,(#col-1)*10,200, rba,rba,rba,rba,
                             -1/((#col-1)*10),-1/((#col-1)*10),-1/((#col-1)*10),0,
                             -1/(200),-1/(200),-1/(200),0);
                local clr = (b-b*2)+1;
                if clr < 0 then clr = 0 elseif clr > 1 then clr = 1 end;
                gfx.gradrect(0,0,(#col-1)*10,200,clr,clr,clr,rwa,
                             1/((#col-1)*10),1/((#col-1)*10),1/((#col-1)*10),0,
                             1/(200),1/(200),1/(200),0);
            end;
            -----
        else;
            -----
            for i = 1,#col-1 do;
                gfx.gradrect(0,10*(i-1),200,10,
                             col[i][1],col[i][2],col[i][3],1, 0,0,0,0,
                             ((col[i+1][1])-(col[i][1])) / 10,
                             ((col[i+1][2])-(col[i][2])) / 10,
                             ((col[i+1][3])-(col[i][3])) / 10, 0);
            end;
            ----
            if white == true then;
                local rw = b+1;
                if rw < 0 then rw = 0 elseif rw > 1 then rw = 1 end;
                gfx.gradrect(195,0,5,(#col-1)*10, rw,rw,rw,1);
                gfx.gradrect(100,0,95,(#col-1)*10, rw,rw,rw,0, 0,0,0,1/95, 0,0,0,0);
            end;
            if black == true then;
                local rb = b;
                if rb > 1 then rb = 1 elseif rb < 0 then rb = 0 end;
                gfx.gradrect(0,0,5,(#col-1)*10, rb,rb,rb,1);
                gfx.gradrect(0,0,95,(#col-1)*10, rb,rb,rb,1, 0,0,0,(0-1)/95, 0,0,0,0);
            end;
            ----
            local rwa = b;
            if white == true then rwa = rwa*2-1 end;
            if rwa < 0 then rwa = 0 elseif rwa > 1 then rwa = 1 end;
            gfx.gradrect(0,0,200,(#col-1)*10,1,1,1,rwa);
            ----
            local rba = b-b*2;
            if black == true then rba = (rba*2-1)end;
            if rba < 0 then rba = 0 elseif rba > 1 then rba = 1 end;
            gfx.gradrect(0,0,200,(#col-1)*10,0,0,0,rba);
            ----
            if UnColGrd == true then;
                local clr = (b-b*2)+1;
                if clr < 0 then clr = 0 elseif clr > 1 then clr = 1 end;
                gfx.gradrect(0,0,200,(#col-1)*10, clr,clr,clr,rwa,
                             1/200,1/200,1/200,0,
                             1/((#col-1)*10),1/((#col-1)*10),1/((#col-1)*10),0);
                gfx.gradrect(0,0,200,(#col-1)*10,rba,rba,rba,rba,
                             -1/200,-1/200,-1/200,0,
                             -1/((#col-1)*10),-1/((#col-1)*10),-1/((#col-1)*10),0);
            end;
            ----
        end;
        gfx.dest = -1;
        gfx.a = alfa;
        if vertically == true then;
            x_s,y_s,w_s,h_s = 1,0,198,10*(#col-1);
        else;
            x_s,y_s,w_s,h_s = 0,1,10*(#col-1),198;
        end;

        local rgb = (b+1)/2;
        gfx.gradrect(x,y,w,h, rgb,rgb,rgb,alfa);

        gfx.blit(buf,1,0, x_s,y_s,w_s,h_s, x,y,w,h, 0,0);
        ----
        if type(frame)~="table" then frame = {} end;
        gfx.r,gfx.g,gfx.b,gfx.a = frame[2]or 0,frame[3]or 0,frame[4]or 0,frame[5]or 0;
        gfx.a = math.min(math.max(0,gfx.a),1);
        for i = 1,(frame[1]or 1) do;
            gfx.roundrect( x+(i-1) , y+(i-1), w-((i-1)*2) , h-((i-1)*2), 1);
        end;
        ---
        gfx.r,gfx.g,gfx.b,gfx.a = gfx_r,gfx_g,gfx_b,gfx_a;
    end;
    --====================================================================



    --=====================================================================
    --- / slider Horizontally / ---
    local sldF;
    local function sliderG(block,x,y,w,h,value,slowCtrl,mode,hide,r);
        if w <= 5 then return value end;
        if w <= 10 then hide = true end;
        local function slidG(x,y,w,h,val);
            -----------
            gfx.gradrect(x,y+1,w,h-2, 0,0,0,1, 1/w,1/w,1/w,0, 0,0,0,0);
            gfx.gradrect(x+(w/2),y-1,1,h+2 ,1,0.8,0.8,.5 );
            -----
            if type(r)~="table" then r = {-1} end;
            if r[1]>0 then;
                local gfx_r,gfx_g,gfx_b,gfx_a = gfx.r,gfx.g,gfx.b,gfx.a;
                gfx.r,gfx.g,gfx.b,gfx.a = r[2],r[3],r[4],r[5];
                gfx.roundrect(x,y+1,w,h-3,1);
                gfx.r,gfx.g,gfx.b,gfx.a = gfx_r,gfx_g,gfx_b,gfx_a;
            end;
            ------------
            local yy = y;
            local hh = h;
            local ww = (w/100*10);
            if ww <= 10 then ww = 10 end;
            local xx = x+(w*val)-(ww/2);
            if xx < x then xx = x end;
            if xx+ww > x+w then xx = x+w-ww+2 end;
            ----------------------
            if hide ~= true then;
                gfx.gradrect(xx,yy ,ww, hh,1,1,1,1 );
                gfx.gradrect(xx+1,yy+1 ,ww-2, hh-2, 0.3,0.3,0.3,1);

                gfx.gradrect(xx+(ww/4)   , yy+5, 1, hh-10   ,1,1,1,1 );
                gfx.gradrect(xx+(ww/1.333), yy+5, 1, hh-10   ,1,1,1,1 );

                gfx.gradrect(xx+(ww/2), yy      ,1 , 5  ,1,1,1,1 );
                gfx.gradrect(xx+(ww/2), yy+hh-5 , 1, 5  ,1,1,1,1 );
            end;
            --======================
        end;
        ------
        if block == true or block == 1 then;gfx.rect(x, y, w, h,0)end;--block
        ------
        sldF=sldF or {};
        sldF.value = value;

        if mode == 1 then; sldF.value = (sldF.value+1)/2; end;

        if sldF.pull and gfx.mouse_cap&5~=5 then sldF.resistor=false end;
        if sldF.pull and gfx.mouse_cap&5==5 then sldF.resistor=true end;
        if gfx.mouse_cap&1~=1 and gfx.mouse_cap&5~=5 then sldF.pull=false end;

        local Mouse =
        gfx.mouse_x>=x and gfx.mouse_x<(x+w)and
        gfx.mouse_y>=y and gfx.mouse_y<(y+h);

        if Mouse and gfx.mouse_cap == 0 then sldF.resistor = true end;

        if gfx.mouse_cap&1 == 1 and gfx.mouse_cap&5 ~= 5 and sldF.resistor then;
            sldF.value = (gfx.mouse_x-x)/w;
        elseif gfx.mouse_cap&1 == 1 and gfx.mouse_cap&5 == 5 and sldF.resistor then;
            if not sldF.pull then sldF.pull = true;
                sldF.gfx__mouse_x = gfx.mouse_x;
                sldF.value = (gfx.mouse_x-x)/w;
                sldF.value2 = sldF.value;
            else;
               sldF.value=sldF.value2-(sldF.gfx__mouse_x-gfx.mouse_x)/(1000*(slowCtrl or 1));
            end;
        elseif gfx.mouse_cap == 0 and not Mouse then;
            sldF.resistor = false;
            sldF.pull=false;
        end
           if sldF.value < 0 then sldF.value = 0 end;
           if sldF.value > 1 then sldF.value = 1 end;
        slidG(x,y,w,h,sldF.value);

        if mode == 1 then;sldF.value = (sldF.value-.5)*2; end;
        return tonumber(string.format("%.3f", sldF.value));
    end;
    --=====================================================================



    --=====================================================================
    --- / slider Verticaly / ---
    local sldF;
    local function sliderV(block,x,y,w,h,value,slowCtrl,mode,hide,r);
        if h <= 5 then return value end;
        if h <= 10 then hide = true end;
        local function slidV(x,y,w,h,val);
            -----------
            gfx.gradrect(x+1,y,w-2,h, 1,1,1,1, 0,0,0,0,  (0-1)/h,(0-1)/h,(0-1)/h, 0);
            gfx.gradrect(x-1,y+(h/2) ,w+2, 1   ,1,0.8,0.8,.5 );
            -----
            if type(r)~="table" then r = {-1} end;
            if r[1]>0 then;
                local gfx_r,gfx_g,gfx_b,gfx_a = gfx.r,gfx.g,gfx.b,gfx.a;
                gfx.r,gfx.g,gfx.b,gfx.a = r[2],r[3],r[4],r[5];
                gfx.roundrect( x+1,y,w-3,h-1, 1);
                gfx.r,gfx.g,gfx.b,gfx.a = gfx_r,gfx_g,gfx_b,gfx_a;
            end
            ------------
            local xx = x;
            local ww = w;
            local hh = (h/100*10);
            if hh <= 10 then hh = 10 end;
            local yy = (h+y)-(h*val)-hh/2;
            if yy < y then yy = y end;
            if yy+hh > y+h then yy = y+h-hh+1 end;
            --------------------
            if hide ~= true then;
                gfx.gradrect(xx,yy ,ww, hh,1,1,1,1 );
                gfx.gradrect(xx+1,yy+1 ,ww-2, hh-2, 0.3,0.3,0.3,1);

                gfx.gradrect(xx+5, yy+(hh)/4 ,ww-10, 1   ,1,1,1,1 );
                gfx.gradrect(xx+5, yy+(hh)/1.35 ,ww-10, 1   ,1,1,1,1 );

                gfx.gradrect(xx, yy+(hh)/2 ,5, 1   ,1,1,1,1 );
                gfx.gradrect(xx+ww-5, yy+(hh)/2 ,5, 1   ,1,1,1,1 );
            end;
            ----
        end;
        ------
        if block == true or block == 1 then;gfx.rect(x, y, w, h,0)end;--block
        ------
        sldF=sldF or {};
        sldF.value = value;

        if mode == 1 then; sldF.value = (sldF.value+1)/2; end;

        if sldF.pull and gfx.mouse_cap&5~=5 then sldF.resistor=false end;
        if sldF.pull and gfx.mouse_cap&5==5 then sldF.resistor=true end;
        if gfx.mouse_cap&1~=1 and gfx.mouse_cap&5~=5 then sldF.pull=false end;

        local Mouse =
        gfx.mouse_x>=x and gfx.mouse_x<(x+w)and
        gfx.mouse_y>=y and gfx.mouse_y<(y+h);

        if Mouse and gfx.mouse_cap == 0 then sldF.resistor = true end;

        if gfx.mouse_cap&1 == 1 and gfx.mouse_cap&5 ~= 5 and sldF.resistor then;
            sldF.value = ((y+h)-gfx.mouse_y)/h;
        elseif gfx.mouse_cap&1 == 1 and gfx.mouse_cap&5 == 5 and sldF.resistor then;
            if not sldF.pull then sldF.pull = true;
                sldF.gfx__mouse_y = gfx.mouse_y;
                sldF.value = (((y+h)-gfx.mouse_y)/h);
                sldF.value2 = sldF.value;
            else;
                sldF.value=sldF.value2+(sldF.gfx__mouse_y-gfx.mouse_y)/(1000*(slowCtrl or 1));
            end;
        elseif gfx.mouse_cap == 0 and not Mouse then;
            sldF.resistor = false;
            sldF.pull=false;
        end
           if sldF.value < 0 then sldF.value = 0 end;
           if sldF.value > 1 then sldF.value = 1 end;
        slidV(x,y,w,h,sldF.value);

        if mode == 1 then;sldF.value = (sldF.value-.5)*2; end;

        return tonumber(string.format("%.3f", sldF.value));
    end;
    --========================================================================




    --========================================================================
    --- / default color all Track / --------------------------
    local function default_Color_All_Track();
        local CountTrack = reaper.CountTracks(0);
        if CountTrack > 0 then;
            reaper.Undo_BeginBlock();
            for tr = 1,CountTrack do;
                local Track = reaper.GetTrack(0,tr-1);
                reaper.SetMediaTrackInfo_Value(Track,"I_CUSTOMCOLOR",0);
            end;
            reaper.Undo_EndBlock("default color all Track",-1);
        end;
    end;
    ----------------------------------------------------------
    --========================================================================




    --========================================================================
    --- / default color all Item / Take / --------------------
    local function default_Color_All_Item_Take();
        local CountItem = reaper.CountMediaItems(0);
        if CountItem > 0 then;
            reaper.Undo_BeginBlock();
            for it = 1,CountItem do;
                local Item = reaper.GetMediaItem(0,it-1);
                reaper.SetMediaItemInfo_Value(Item,"I_CUSTOMCOLOR",0);
                ----
                local CountTake = reaper.CountTakes(Item);
                for tk = 1,CountTake do;
                    local take = reaper.GetMediaItemTake(Item,tk-1);
                    reaper.SetMediaItemTakeInfo_Value(take,"I_CUSTOMCOLOR",0);
                end;
            end;
            reaper.Undo_EndBlock("default color all Item / Take",-1);
        end;
        reaper.UpdateArrange();
    end;
    ----------------------------------------------------------
    --========================================================================



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
    local FOCUS_LOST_CLOSE = tonumber(reaper.GetExtState(section,"FOCUS_LOST_CLOSE"))or 1;
    -----


    -----
    local But_Bright = tonumber(reaper.GetExtState(section,"But_Bright"))or 0;
    -----


    -----
    local But_Transp = tonumber(reaper.GetExtState(section,"But_Transp"))or 1;
    -----


    -----
    local Frame_Transp = tonumber(reaper.GetExtState(section,"Frame_Transp"))or 1;
    -----


    -----
    local Frame_Thickness = tonumber(reaper.GetExtState(section,"Frame_Thickness"))or 1;
    -----


    -----
    local TOOLTIP_GRDNT = tonumber(reaper.GetExtState(section,"TOOLTIP_GRDNT"))or 1;
    -----


    -----
    local TOOL_TIP = tonumber(reaper.GetExtState(section,"TOOL_TIP"))or 1;
    -----


    -----
    local BACKLIGHT_BTN = tonumber(reaper.GetExtState(section,"BACKLIGHT_BTN"))or 1;
    -----


    -----
    local COL_PREV_GRAD = tonumber(reaper.GetExtState(section,"COL_PREV_GRAD"))or 1;
    -----


    -----
    local CLICK_BUT_CLOSE_WIN = tonumber(reaper.GetExtState(section,"CLICK_BUT_CLOSE_WIN"))or 1;
    -----


    -----
    local CLICK_GRD_CLOSE_WIN = tonumber(reaper.GetExtState(section,"CLICK_GRD_CLOSE_WIN"))or 1;
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


    function ret_flam_Grd_szG();
        local flam = {Frame_Thickness,R_Gui/255,G_Gui/255,B_Gui/255,Frame_Transp};
        local Grd_szG = {x=X(1), y=(B_2_G.y+B_2_G.h+5), w=W(98)-fade_vG.w-5, h=(gfx.h-(B_2_G.y+B_2_G.h+10))};
        local Grd_szV = {x=(B_2_V.x+B_2_V.w+5), y=Y(1), h=H(98)-fade_vG.h-5, w=(gfx.w-(B_2_V.x+B_2_V.w+10))};
        local flam_grd = {table.unpack(flam)};
        if flam_grd[1]>0 then flam_grd[1] = 1 end;
        return flam,flam_grd,Grd_szG,Grd_szV;
    end;



    local titleWind = "Color switch";
    local _,_, scr_x,scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,1);
    scr_x = (scr_x / 2)-(550/2);
    scr_y = (scr_y / 2.5)-(35 /2);
    gfx.init(titleWind,SizeW or 550,SizeH or 35,PositionDock,PosX or scr_x,PosY or scr_y);
    local PcallWindScr,ShowWindScr = pcall(reaper.JS_Window_Find,titleWind,true);
    if PcallWindScr and type(ShowWindScr)=="userdata" then reaper.JS_Window_AttachTopmostPin(ShowWindScr)end;






    ---- / Рисуем основу / ----
    local function Start_GUI();

        local flam ,flam_grd, Grd_szG, Grd_szV = ret_flam_Grd_szG();

        gfx.gradrect(0,0,gfx.w,gfx.h,R_Back/256,G_Back/256,B_Back/256,1);--background


        if gfx.w > gfx.h and gfx.h <= 50 then;
            ------B_1_X_G---------------------------------------------------------------------------------------------------------
            gradient(nil,false,X(B_1_1G.x),Y(B_1_1G.y),W(B_1_1G.w),H(B_1_1G.h),false,false,But_Transp,gradBut[1],But_Bright,flam);
            TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt,B_1_1G.yt,B_1_1G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_2G.x),Y(B_1_2G.y),W(B_1_2G.w),H(B_1_2G.h),false,false,But_Transp,gradBut[2],But_Bright,flam);
            TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt,B_1_2G.yt,B_1_2G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_3G.x),Y(B_1_3G.y),W(B_1_3G.w),H(B_1_3G.h),false,false,But_Transp,gradBut[3],But_Bright,flam);
            TextByCenterAndResize(B_1_3G.txt,B_1_3G.xt,B_1_3G.yt,B_1_3G.wt,B_1_3G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_4G.x),Y(B_1_4G.y),W(B_1_4G.w),H(B_1_4G.h),false,false,But_Transp,gradBut[4],But_Bright,flam);
            TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt,B_1_4G.yt,B_1_4G.wt,B_1_4G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_5G.x),Y(B_1_5G.y),W(B_1_5G.w),H(B_1_5G.h),false,false,But_Transp,gradBut[5],But_Bright,flam);
            TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt,B_1_5G.yt,B_1_5G.wt,B_1_5G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_6G.x),Y(B_1_6G.y),W(B_1_6G.w),H(B_1_6G.h),false,false,But_Transp,gradBut[6],But_Bright,flam);
            TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt,B_1_6G.yt,B_1_6G.wt,B_1_6G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_7G.x),Y(B_1_7G.y),W(B_1_7G.w),H(B_1_7G.h),false,false,But_Transp,gradBut[7],But_Bright,flam);
            TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt,B_1_7G.yt,B_1_7G.wt,B_1_7G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_8G.x),Y(B_1_8G.y),W(B_1_8G.w),H(B_1_8G.h),false,false,But_Transp,gradBut[8],But_Bright,flam);
            TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt,B_1_8G.yt,B_1_8G.wt,B_1_8G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_9G.x),Y(B_1_9G.y),W(B_1_9G.w),H(B_1_9G.h),false,false,But_Transp,gradBut[9],But_Bright,flam);
            TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt,B_1_9G.yt,B_1_9G.wt,B_1_9G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_10G.x),Y(B_1_10G.y),W(B_1_10G.w),H(B_1_10G.h),false,false,But_Transp,gradBut[10],But_Bright,flam);
            TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt,B_1_10G.yt,B_1_10G.wt,B_1_10G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            --------------------------------------------------------------------------------------------------------------------------
        elseif gfx.w > gfx.h and gfx.h > 50 then;
            ------B_1_X_G---------------------------------------------------------------------------------------------------------
            gradient(nil,false,X(B_1_1G.x),B_2_G.y,W(B_1_1G.w),B_2_G.h,false,false,But_Transp,gradBut[1],But_Bright,flam);
            TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt,B_1_1G.yt,B_1_1G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_2G.x),B_2_G.y,W(B_1_2G.w),B_2_G.h,false,false,But_Transp,gradBut[2],But_Bright,flam);
            TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt,B_1_2G.yt,B_1_2G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_3G.x),B_2_G.y,W(B_1_3G.w),B_2_G.h,false,false,But_Transp,gradBut[3],But_Bright,flam);
            TextByCenterAndResize(B_1_3G.txt,B_1_3G.xt,B_1_3G.yt,B_1_3G.wt,B_1_3G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_4G.x),B_2_G.y,W(B_1_4G.w),B_2_G.h,false,false,But_Transp,gradBut[4],But_Bright,flam);
            TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt,B_1_4G.yt,B_1_4G.wt,B_1_4G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_5G.x),B_2_G.y,W(B_1_5G.w),B_2_G.h,false,false,But_Transp,gradBut[5],But_Bright,flam);
            TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt,B_1_5G.yt,B_1_5G.wt,B_1_5G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_6G.x),B_2_G.y,W(B_1_6G.w),B_2_G.h,false,false,But_Transp,gradBut[6],But_Bright,flam);
            TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt,B_1_6G.yt,B_1_6G.wt,B_1_6G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_7G.x),B_2_G.y,W(B_1_7G.w),B_2_G.h,false,false,But_Transp,gradBut[7],But_Bright,flam);
            TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt,B_1_7G.yt,B_1_7G.wt,B_1_7G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_8G.x),B_2_G.y,W(B_1_8G.w),B_2_G.h,false,false,But_Transp,gradBut[8],But_Bright,flam);
            TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt,B_1_8G.yt,B_1_8G.wt,B_1_8G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_9G.x),B_2_G.y,W(B_1_9G.w),B_2_G.h,false,false,But_Transp,gradBut[9],But_Bright,flam);
            TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt,B_1_9G.yt,B_1_9G.wt,B_1_9G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false,X(B_1_10G.x),B_2_G.y,W(B_1_10G.w),B_2_G.h,false,false,But_Transp,gradBut[10],But_Bright,flam);
            TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt,B_1_10G.yt,B_1_10G.wt,B_1_10G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);

            gradient(nil,false, Grd_szG.x, Grd_szG.y, Grd_szG.w, Grd_szG.h, true,true,1,Grd_clG.col,GRD_Bright or 0,flam_grd,true);

            sliderV(0,X(99)-fade_vG.w , Grd_szG.y, fade_vG.w, Grd_szG.h,  GRD_Bright or 0,2,1,true_,flam);
            --------------------------------------------------------------------------------------------------------------------------
        elseif gfx.w < gfx.h and gfx.w <= 60 then;
            ------B_1_X_V---------------------------------------------------------------------------------------------------------
            gradient(nil,false,X(B_1_1V.x),Y(B_1_1V.y),W(B_1_1V.w),H(B_1_1V.h),false,false,But_Transp,gradBut[1],But_Bright,flam);
            TextByCenterAndResize(B_1_1V.txt,B_1_1V.xt,B_1_1V.yt,B_1_1V.wt,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_2V.x),Y(B_1_2V.y),W(B_1_2V.w),H(B_1_2V.h),false,false,But_Transp,gradBut[2],But_Bright,flam);
            TextByCenterAndResize(B_1_2V.txt,B_1_2V.xt,B_1_2V.yt,B_1_2V.wt,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_3V.x),Y(B_1_3V.y),W(B_1_3V.w),H(B_1_3V.h),false,false,But_Transp,gradBut[3],But_Bright,flam);
            TextByCenterAndResize(B_1_3V.txt,B_1_3V.xt,B_1_3V.yt,B_1_3V.wt,B_1_3V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_4V.x),Y(B_1_4V.y),W(B_1_4V.w),H(B_1_4V.h),false,false,But_Transp,gradBut[4],But_Bright,flam);
            TextByCenterAndResize(B_1_4V.txt,B_1_4V.xt,B_1_4V.yt,B_1_4V.wt,B_1_4V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_5V.x),Y(B_1_5V.y),W(B_1_5V.w),H(B_1_5V.h),false,false,But_Transp,gradBut[5],But_Bright,flam);
            TextByCenterAndResize(B_1_5V.txt,B_1_5V.xt,B_1_5V.yt,B_1_5V.wt,B_1_5V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_6V.x),Y(B_1_6V.y),W(B_1_6V.w),H(B_1_6V.h),false,false,But_Transp,gradBut[6],But_Bright,flam);
            TextByCenterAndResize(B_1_6V.txt,B_1_6V.xt,B_1_6V.yt,B_1_6V.wt,B_1_6V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_7V.x),Y(B_1_7V.y),W(B_1_7V.w),H(B_1_7V.h),false,false,But_Transp,gradBut[7],But_Bright,flam);
            TextByCenterAndResize(B_1_7V.txt,B_1_7V.xt,B_1_7V.yt,B_1_7V.wt,B_1_7V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_8V.x),Y(B_1_8V.y),W(B_1_8V.w),H(B_1_8V.h),false,false,But_Transp,gradBut[8],But_Bright,flam);
            TextByCenterAndResize(B_1_8V.txt,B_1_8V.xt,B_1_8V.yt,B_1_8V.wt,B_1_8V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_9V.x),Y(B_1_9V.y),W(B_1_9V.w),H(B_1_9V.h),false,false,But_Transp,gradBut[9],But_Bright,flam);
            TextByCenterAndResize(B_1_9V.txt,B_1_9V.xt,B_1_9V.yt,B_1_9V.wt,B_1_9V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);

            gradient(nil,false,X(B_1_10V.x),Y(B_1_10V.y),W(B_1_10V.w),H(B_1_10V.h),false,false,But_Transp,gradBut[10],But_Bright,flam);
            TextByCenterAndResize(B_1_10V.txt,B_1_10V.xt,B_1_10V.yt,B_1_10V.wt,B_1_10V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
            --------------------------------------------------------------------------------------------------------------------------
        elseif gfx.w < gfx.h and gfx.w > 60 then;
            ------B_1_X_V-------------------------------------------------------------------------------------------------------------
            gradient(nil,false, B_2_V.x,Y(B_1_1V.y),B_2_V.w,H(B_1_1V.h) ,false,false,But_Transp,gradBut[1],But_Bright,flam);
            TextByCenterAndResize(B_1_1V.txt,0,B_1_1V.yt,0,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text,B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_2V.y),B_2_V.w,H(B_1_2V.h) ,false,false,But_Transp,gradBut[2],But_Bright,flam);
            TextByCenterAndResize(B_1_2V.txt,0,B_1_2V.yt,0,B_1_2V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_3V.y),B_2_V.w,H(B_1_3V.h) ,false,false,But_Transp,gradBut[3],But_Bright,flam);
            TextByCenterAndResize(B_1_3V.txt,0,B_1_3V.yt,0,B_1_3V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_4V.y),B_2_V.w,H(B_1_4V.h)  ,false,false,But_Transp,gradBut[4],But_Bright,flam);
            TextByCenterAndResize(B_1_4V.txt,0,B_1_4V.yt,0,B_1_4V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_5V.y),B_2_V.w,H(B_1_5V.h)  ,false,false,But_Transp,gradBut[5],But_Bright,flam);
            TextByCenterAndResize(B_1_5V.txt,0,B_1_5V.yt,0,B_1_5V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_6V.y),B_2_V.w,H(B_1_6V.h)  ,false,false,But_Transp,gradBut[6],But_Bright,flam);
            TextByCenterAndResize(B_1_6V.txt,0,B_1_6V.yt,0,B_1_6V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_7V.y),B_2_V.w,H(B_1_7V.h)  ,false,false,But_Transp,gradBut[7],But_Bright,flam);
            TextByCenterAndResize(B_1_7V.txt,0,B_1_7V.yt,0,B_1_7V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_8V.y),B_2_V.w,H(B_1_8V.h)  ,false,false,But_Transp,gradBut[8],But_Bright,flam);
            TextByCenterAndResize(B_1_8V.txt,0,B_1_8V.yt,0,B_1_8V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_9V.y),B_2_V.w,H(B_1_9V.h)  ,false,false,But_Transp,gradBut[9],But_Bright,flam);
            TextByCenterAndResize(B_1_9V.txt,0,B_1_9V.yt,0,B_1_9V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,false, B_2_V.x,Y(B_1_10V.y),B_2_V.w,H(B_1_10V.h)  ,false,false,But_Transp,gradBut[10],But_Bright,flam);
            TextByCenterAndResize(B_1_10V.txt,0,B_1_10V.yt,0,B_1_10V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);

            gradient(nil,true, Grd_szV.x, Grd_szV.y, Grd_szV.w, Grd_szV.h, true,true,1,Grd_clG.col,GRD_Bright or 0,flam_grd,true);

            sliderG(0, Grd_szV.x, Y(99)-fade_vG.h, Grd_szV.w, fade_vG.h,  GRD_Bright or 0,  0,1,   true_, flam);
            ----------------------------------------------------------------------------------------------------------------------
        end;


        gfxSaveScrin_buf(0,gfx.w,gfx.h);
        gfx.blit(-1,1,0, 0,0,gfx.w,gfx.h,0,0,gfx.w,gfx.h,0,0);
        gfxRestScrin_buf(0,0,0,gfx.w,gfx.h);
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
        ----/ Удалить Фокус с Окна /----
        RemoveFocusWindow(RemFocusWin);
        ---/ Закрыть окно при потере фокуса / ---
        if FOCUS_LOST_CLOSE == 1 and Counter(5,"focus_lost_close")== 0 then;
            if gfx.getchar(65536)&2 ~= 2 then reaper.atexit(exit) return end;
        end;
        --------------------------------------------------------
        --------------------------------------------------------
        --------------------------------------------------------
        --------------------------------------------------------



        local flam ,flam_grd, Grd_szG, Grd_szV = ret_flam_Grd_szG();
        gfxRestScrin_buf(0,0,0,gfx.w,gfx.h);

        if not tonumber(GRD_Bright) then;
            GRD_Bright = tonumber(reaper.GetExtState(section,"GRD_Bright"))or 0;
        end;


        --====================================================================================
        if gfx.w > gfx.h and gfx.h <= 50 then;--==============================================
        --====================================================================================
            -----
            -----
            -----
            local L_Click_Tr1 = LeftMouseButton(X(B_1_1G.x),Y(B_1_1G.y),W(B_1_1G.w),H(B_1_1G.h),"L_Click_Tr1");
            if L_Click_Tr1 == 0 or L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                gfx.gradrect(X(B_1_1G.x)-1,Y(B_1_1G.y)-1,W(B_1_1G.w)+2,H(B_1_1G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_1G.x-1),Y(B_1_1G.y-10),W(B_1_1G.w+2),H(B_1_1G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tr1 == 0 then;
                    gradient(nil,false,X(B_1_1G.x)-1,Y(B_1_1G.y)-1,W(B_1_1G.w)+2,H(B_1_1G.h)+2,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt,B_1_1G.yt,B_1_1G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn1, X(B_1_1G.x),Y(B_1_1G.y),W(B_1_1G.w),H(B_1_1G.h),TOOL_TIP,"L_Click_Tr1");
                end;

                if L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                    SetToolTip(T_Tip.Btn1, X(B_1_1G.x),Y(B_1_1G.y),W(B_1_1G.w),H(B_1_1G.h),-1,"L_Click_Tr1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_1G.x),Y(B_1_1G.y),W(B_1_1G.w),H(B_1_1G.h),false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt+1,B_1_1G.yt+1,B_1_1G.wt-2,B_1_1G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr1 == 2 then;
                    reaper.Main_OnCommand(40357,0);
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr1 < 0 then; CleanToolTip("L_Click_Tr1") end;
            -----
            -----
            -----
            local L_Click_Tr2 = LeftMouseButton(X(B_1_2G.x),Y(B_1_2G.y),W(B_1_2G.w),H(B_1_2G.h),"L_Click_Tr2");
            if L_Click_Tr2 == 0 or L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                gfx.gradrect(X(B_1_2G.x)-1,Y(B_1_2G.y)-1,W(B_1_2G.w)+2,H(B_1_2G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_2G.x-1),Y(B_1_2G.y-10),W(B_1_2G.w+2),H(B_1_2G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tr2 == 0 then;
                    gradient(nil,false,X(B_1_2G.x)-1,Y(B_1_2G.y)-1,W(B_1_2G.w)+2,H(B_1_2G.h)+2,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt,B_1_2G.yt,B_1_2G.wt,B_1_2G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn2, X(B_1_2G.x),Y(B_1_2G.y),W(B_1_2G.w),H(B_1_2G.h),TOOL_TIP,"L_Click_Tr2");
                end;

                if L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                    SetToolTip(T_Tip.Btn2,X(B_1_2G.x),Y(B_1_2G.y),W(B_1_2G.w),H(B_1_2G.h),-1,"L_Click_Tr2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_2G.x),Y(B_1_2G.y),W(B_1_2G.w),H(B_1_2G.h),false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt+1,B_1_2G.yt+1,B_1_2G.wt-2,B_1_2G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr2 == 2 then;
                    reaper.Main_OnCommand(40358,0);--Track: Set to random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr2 < 0 then; CleanToolTip("L_Click_Tr2") end;
            -----
            -----
            -----
            local L_Click_Tr3 = LeftMouseButton(X(B_1_3G.x),Y(B_1_3G.y),W(B_1_3G.w),H(B_1_3G.h),"L_Click_Tr3");
            if L_Click_Tr3 == 0 or L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                gfx.gradrect(X(B_1_3G.x)-1,Y(B_1_3G.y)-1,W(B_1_3G.w)+2,H(B_1_3G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_3G.x-1),Y(B_1_3G.y-10),W(B_1_3G.w+2),H(B_1_3G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tr3 == 0 then;
                    gradient(nil,false,X(B_1_3G.x)-1,Y(B_1_3G.y)-1,W(B_1_3G.w)+2,H(B_1_3G.h)+2,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_3G.xt,B_1_3G.yt,B_1_3G.wt,B_1_3G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn3, X(B_1_3G.x),Y(B_1_3G.y),W(B_1_3G.w),H(B_1_3G.h),TOOL_TIP,"L_Click_Tr3");
                end;

                if L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                    SetToolTip(T_Tip.Btn3,X(B_1_3G.x),Y(B_1_3G.y),W(B_1_3G.w),H(B_1_3G.h),-1,"L_Click_Tr3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_3G.x),Y(B_1_3G.y),W(B_1_3G.w),H(B_1_3G.h),false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_3G.xt+1,B_1_3G.yt+1,B_1_3G.wt-2,B_1_3G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr3 == 2 then;
                    reaper.Main_OnCommand(40360,0);--Track: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr3 < 0 then; CleanToolTip("L_Click_Tr3") end;
            -----
            -----
            -----
            local L_Click_Tr4 = LeftMouseButton(X(B_1_4G.x),Y(B_1_4G.y),W(B_1_4G.w),H(B_1_4G.h),"L_Click_Tr4");
            if L_Click_Tr4 == 0 or L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                gfx.gradrect(X(B_1_4G.x)-1,Y(B_1_4G.y)-1,W(B_1_4G.w)+2,H(B_1_4G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_4G.x-1),Y(B_1_4G.y-10),W(B_1_4G.w+2),H(B_1_4G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tr4 == 0 then;
                    gradient(nil,false,X(B_1_4G.x)-1,Y(B_1_4G.y)-1,W(B_1_4G.w)+2,H(B_1_4G.h)+2,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt,B_1_4G.yt,B_1_4G.wt,B_1_4G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn4, X(B_1_4G.x),Y(B_1_4G.y),W(B_1_4G.w),H(B_1_4G.h),TOOL_TIP,"L_Click_Tr4");
                end;

                if L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                    SetToolTip(T_Tip.Btn4, X(B_1_4G.x),Y(B_1_4G.y),W(B_1_4G.w),H(B_1_4G.h),-1,"L_Click_Tr4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_4G.x),Y(B_1_4G.y),W(B_1_4G.w),H(B_1_4G.h),false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt+1,B_1_4G.yt+1,B_1_4G.wt-2,B_1_4G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr4 == 2 then;
                    reaper.Main_OnCommand(40359,0);--Track: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr4 < 0 then; CleanToolTip("L_Click_Tr4") end;
            -----
            -----
            -----
            local L_Click_It1 = LeftMouseButton(X(B_1_5G.x),Y(B_1_5G.y),W(B_1_5G.w),H(B_1_5G.h),"L_Click_It1");
            if L_Click_It1 == 0 or L_Click_It1 == 1 or L_Click_It1 == 2 then;
                gfx.gradrect(X(B_1_5G.x)-1,Y(B_1_5G.y)-1,W(B_1_5G.w)+2,H(B_1_5G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_5G.x-1),Y(B_1_5G.y-10),W(B_1_5G.w+2),H(B_1_5G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_It1 == 0 then;
                    gradient(nil,false,X(B_1_5G.x)-1,Y(B_1_5G.y)-1,W(B_1_5G.w)+2,H(B_1_5G.h)+2,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt,B_1_5G.yt,B_1_5G.wt,B_1_5G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn5, X(B_1_5G.x),Y(B_1_5G.y),W(B_1_5G.w),H(B_1_5G.h),TOOL_TIP,"L_Click_It1");
                end;

                if L_Click_It1 == 1 or L_Click_It1 == 2 then;
                    SetToolTip(T_Tip.Btn5, X(B_1_5G.x),Y(B_1_5G.y),W(B_1_5G.w),H(B_1_5G.h),-1,"L_Click_It1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_5G.x),Y(B_1_5G.y),W(B_1_5G.w),H(B_1_5G.h),false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt+1,B_1_5G.yt+1,B_1_5G.wt-2,B_1_5G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It1 == 2 then;
                    reaper.Main_OnCommand(40704,0);--Item: Set to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It1 < 0 then; CleanToolTip("L_Click_It1") end;
            -----
            -----
            -----
            local L_Click_It2 = LeftMouseButton(X(B_1_6G.x),Y(B_1_6G.y),W(B_1_6G.w),H(B_1_6G.h),"L_Click_It2");
            if L_Click_It2 == 0 or L_Click_It2 == 1 or L_Click_It2 == 2 then;
                gfx.gradrect(X(B_1_6G.x)-1,Y(B_1_6G.y)-1,W(B_1_6G.w)+2,H(B_1_6G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_6G.x-1),Y(B_1_6G.y-10),W(B_1_6G.w+2),H(B_1_6G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_It2 == 0 then;
                    gradient(nil,false,X(B_1_6G.x)-1,Y(B_1_6G.y)-1,W(B_1_6G.w)+2,H(B_1_6G.h)+2,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt,B_1_6G.yt,B_1_6G.wt,B_1_6G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn6, X(B_1_6G.x),Y(B_1_6G.y),W(B_1_6G.w),H(B_1_6G.h),TOOL_TIP,"L_Click_It2");
                end;

                if L_Click_It2 == 1 or L_Click_It2 == 2 then;
                    SetToolTip(T_Tip.Btn6, X(B_1_6G.x),Y(B_1_6G.y),W(B_1_6G.w),H(B_1_6G.h),-1,"L_Click_It2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_6G.x),Y(B_1_6G.y),W(B_1_6G.w),H(B_1_6G.h),false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt+1,B_1_6G.yt+1,B_1_6G.wt-2,B_1_6G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It2 == 2 then;
                    reaper.Main_OnCommand(40705,0);--Item: Set to random colors
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It2 < 0 then; CleanToolTip("L_Click_It2") end;
            -----
            -----
            -----
            local L_Click_It3 = LeftMouseButton(X(B_1_7G.x),Y(B_1_7G.y),W(B_1_7G.w),H(B_1_7G.h),"L_Click_It3");
            if L_Click_It3 == 0 or L_Click_It3 == 1 or L_Click_It3 == 2 then;
                gfx.gradrect(X(B_1_7G.x)-1,Y(B_1_7G.y)-1,W(B_1_7G.w)+2,H(B_1_7G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_7G.x-1),Y(B_1_7G.y-10),W(B_1_7G.w+2),H(B_1_7G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_It3 == 0 then;
                    gradient(nil,false,X(B_1_7G.x)-1,Y(B_1_7G.y)-1,W(B_1_7G.w)+2,H(B_1_7G.h)+2,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt,B_1_7G.yt,B_1_7G.wt,B_1_7G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn7, X(B_1_7G.x),Y(B_1_7G.y),W(B_1_7G.w),H(B_1_7G.h),TOOL_TIP,"L_Click_It3");
                end;

                if L_Click_It3 == 1 or L_Click_It3 == 2 then;
                    SetToolTip(T_Tip.Btn7, X(B_1_7G.x),Y(B_1_7G.y),W(B_1_7G.w),H(B_1_7G.h),-1,"L_Click_It3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_7G.x),Y(B_1_7G.y),W(B_1_7G.w),H(B_1_7G.h),false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt+1,B_1_7G.yt+1,B_1_7G.wt-2,B_1_7G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It3 == 2 then;
                    reaper.Main_OnCommand(40706,0);--Item: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It3 < 0 then; CleanToolTip("L_Click_It3") end;
            -----
            -----
            -----
            local L_Click_It4 = LeftMouseButton(X(B_1_8G.x),Y(B_1_8G.y),W(B_1_8G.w),H(B_1_8G.h),"L_Click_It4");
            if L_Click_It4 == 0 or L_Click_It4 == 1 or L_Click_It4 == 2 then;
                gfx.gradrect(X(B_1_8G.x)-1,Y(B_1_8G.y)-1,W(B_1_8G.w)+2,H(B_1_8G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_8G.x-1),Y(B_1_8G.y-10),W(B_1_8G.w+2),H(B_1_8G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_It4 == 0 then;
                    gradient(nil,false,X(B_1_8G.x)-1,Y(B_1_8G.y)-1,W(B_1_8G.w)+2,H(B_1_8G.h)+2,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt,B_1_8G.yt,B_1_8G.wt,B_1_8G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn8,X(B_1_8G.x),Y(B_1_8G.y),W(B_1_8G.w),H(B_1_8G.h),TOOL_TIP,"L_Click_It4");
                end;

                if L_Click_It4 == 1 or L_Click_It4 == 2 then;
                    SetToolTip(T_Tip.Btn8, X(B_1_8G.x),Y(B_1_8G.y),W(B_1_8G.w),H(B_1_8G.h),-1,"L_Click_It4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_8G.x),Y(B_1_8G.y),W(B_1_8G.w),H(B_1_8G.h),false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt+1,B_1_8G.yt+1,B_1_8G.wt-2,B_1_8G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It4 == 2 then;
                    reaper.Main_OnCommand(40707,0);--Item: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It4 < 0 then; CleanToolTip("L_Click_It4") end;
            -----
            -----
            -----
            local L_Click_Tk1 = LeftMouseButton(X(B_1_9G.x),Y(B_1_9G.y),W(B_1_9G.w),H(B_1_9G.h),"L_Click_Tk1");
            if L_Click_Tk1 == 0 or L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                gfx.gradrect(X(B_1_9G.x)-1,Y(B_1_9G.y)-1,W(B_1_9G.w)+2,H(B_1_9G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_9G.x-1),Y(B_1_9G.y-10),W(B_1_9G.w+2),H(B_1_9G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tk1 == 0 then;
                    gradient(nil,false,X(B_1_9G.x)-1,Y(B_1_9G.y)-1,W(B_1_9G.w)+2,H(B_1_9G.h)+2,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt,B_1_9G.yt,B_1_9G.wt,B_1_9G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn9,X(B_1_9G.x),Y(B_1_9G.y),W(B_1_9G.w),H(B_1_9G.h),TOOL_TIP,"L_Click_Tk1");
                end;

                if L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                    SetToolTip(T_Tip.Btn9,X(B_1_9G.x),Y(B_1_9G.y),W(B_1_9G.w),H(B_1_9G.h),TOOL_TIP,"L_Click_Tk1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_9G.x),Y(B_1_9G.y),W(B_1_9G.w),H(B_1_9G.h),false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt+1,B_1_9G.yt+1,B_1_9G.wt-2,B_1_9G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tk1 == 2 then;
                    reaper.Main_OnCommand(41331,0);--Take: Set active take to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk1 < 0 then; CleanToolTip("L_Click_Tk1") end;
            -----
            -----
            -----
            local L_Click_Tk2 = LeftMouseButton(X(B_1_10G.x),Y(B_1_10G.y),W(B_1_10G.w),H(B_1_10G.h),"L_Click_Tk2");
            if L_Click_Tk2 == 0 or L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                gfx.gradrect(X(B_1_10G.x)-1,Y(B_1_10G.y)-1,W(B_1_10G.w)+2,H(B_1_10G.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_10G.x-1),Y(B_1_10G.y-10),W(B_1_10G.w+2),H(B_1_10G.h+20), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;

                if L_Click_Tk2 == 0 then;
                    gradient(nil,false,X(B_1_10G.x)-1,Y(B_1_10G.y)-1,W(B_1_10G.w)+2,H(B_1_10G.h)+2,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt,B_1_10G.yt,B_1_10G.wt,B_1_10G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn10, X(B_1_10G.x),Y(B_1_10G.y),W(B_1_10G.w),H(B_1_10G.h),TOOL_TIP,"L_Click_Tk2");
                end;

                if L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                    SetToolTip(T_Tip.Btn10, X(B_1_10G.x),Y(B_1_10G.y),W(B_1_10G.w),H(B_1_10G.h),-1,"L_Click_Tk2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_10G.x),Y(B_1_10G.y),W(B_1_10G.w),H(B_1_10G.h),false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt+1,B_1_10G.yt+1,B_1_10G.wt-2,B_1_10G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tk2 == 2 then;
                    reaper.Main_OnCommand(41333,0);--Take: Set active take to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk2 < 0 then; CleanToolTip("L_Click_Tk2") end;
            -----
            -----
            -----
        --====================================================================================
        elseif gfx.w > gfx.h and gfx.h > 50 then;--===========================================
        --====================================================================================
            -----
            -----
            -----
            local dblClick = doubleClick(X(99)-fade_vG.w,Grd_szG.y,fade_vG.w,Grd_szG.h,500);
            if dblClick then GRD_Bright = 0 end;

            GRD_Bright = sliderV(0,X(99)-fade_vG.w,Grd_szG.y,fade_vG.w,Grd_szG.h, GRD_Bright,2,1,true_,flam);
            if GRD_Bright ~= GRD_Bright2 then;
                GRD_Bright2 = GRD_Bright;
                Start_GUI();
                reaper.SetExtState(section,"GRD_Bright",GRD_Bright,true);
            end;
            -----
            -----
            -----
            local L_Click_Grd = LeftMouseButton(Grd_szG.x, Grd_szG.y, Grd_szG.w, Grd_szG.h,"GRDNT_G");
            if L_Click_Grd == 1 then;
                if gfx.mouse_x > Grd_szG.x and gfx.mouse_x < Grd_szG.x + Grd_szG.w and
                   gfx.mouse_y > Grd_szG.y and gfx.mouse_y < Grd_szG.y + Grd_szG.h then;
                    ---
                    local Context = reaper.GetCursorContext2(true);
                    local Str;
                    if Context == 1 then;
                        local CountSelItem = reaper.CountSelectedMediaItems(0);
                        if CountSelItem == 0 then;
                            Str = "ITEM / No items selected!"
                        else;
                            Str = "ITEM"
                        end;
                    else;
                        local CountSelTrack = reaper.CountSelectedTracks(0);
                        if CountSelTrack == 0 then;
                            Str = "TRACK / No track selected !";
                        else;
                            Str = "Track";
                        end;
                    end;

                    if COL_PREV_GRAD == 1 then;
                        if #Str < 10 then;
                            gfx.x,gfx.y = gfx.mouse_x, gfx.mouse_y;
                            local rp,gp,bp = gfx.getpixel();
                            gradient(nil,false,X(1),B_2_G.y,W(98),B_2_G.h,false,false,1,{{rp,gp,bp}},0,flam_grd);
                        end;
                    end;


                    if TOOLTIP_GRDNT == 1 then;
                        local lengthFont,heightFont = gfx.measurestr(Str);
                        if gfx.mouse_x > gfx.w / 2 then;
                            gfx.x = gfx.mouse_x - lengthFont-30;
                        else;
                            gfx.x = gfx.mouse_x + 30;
                        end;
                        if gfx.mouse_y > gfx.h / 2 then;
                            gfx.y = gfx.mouse_y - 30;
                        else;
                            gfx.y = gfx.mouse_y + 30;
                        end;

                        gfx.setfont(1,"Arial",16,0);--BOLD=98,ITALIC=105,UNDERLINE=117
                        gfx.gradrect(gfx.x-3,gfx.y-1,lengthFont+6,heightFont+2, .7,.7,.7,.5);
                        gfx.set(.2,.2,.2,.6);
                        gfx.roundrect(gfx.x-4,gfx.y-1,lengthFont+7,heightFont+2,2);
                        gfx.set(.1);
                        gfx.drawstr(Str);
                    end;
                end;
                ----
            elseif L_Click_Grd == 2 then;
                ----
                local Context = reaper.GetCursorContext2(true);
                gfx.x,gfx.y = gfx.mouse_x, gfx.mouse_y;
                local rp,gp,bp = gfx.getpixel();
                local custonColor = reaper.ColorToNative(rp*255,gp*255,bp*255)|0x1000000;
                if Context == 1 then;--ITEM
                    local CountSelItem = reaper.CountSelectedMediaItems(0);
                    if CountSelItem > 0 then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        for i = 1,CountSelItem do;
                            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
                            reaper.SetMediaItemInfo_Value(SelItem,"I_CUSTOMCOLOR",custonColor);
                        end;
                        reaper.PreventUIRefresh(-1);
                        reaper.Undo_EndBlock("Set item color",-1);
                    end;
                else;
                    local CountSelTrack = reaper.CountSelectedTracks(0);
                    if CountSelTrack > 0 then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        for i = 1,CountSelTrack do;
                            local SelTrack = reaper.GetSelectedTrack(0,i-1);
                            reaper.SetMediaTrackInfo_Value(SelTrack,"I_CUSTOMCOLOR",custonColor);
                        end;
                        reaper.PreventUIRefresh(-1);
                        reaper.Undo_EndBlock("Set track color",-1);
                    end;
                end;
                reaper.UpdateArrange();
                if CLICK_GRD_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
            end;
            -----
            -----
            -----
            local L_Click_Tr1 = LeftMouseButton(X(B_1_1G.x),B_2_G.y,W(B_1_1G.w),B_2_G.h,"L_Click_Tr1");
            if L_Click_Tr1 == 0 or L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                gfx.gradrect(X(B_1_1G.x)-1,B_2_G.y-1,W(B_1_1G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_1G.x-1),B_2_G.y-5,W(B_1_1G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr1 == 0 then;
                    gradient(nil,false,X(B_1_1G.x)-1,B_2_G.y-1,W(B_1_1G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt,B_1_1G.yt,B_1_1G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn1,X(B_1_1G.x),B_2_G.y,W(B_1_1G.w),B_2_G.h,TOOL_TIP,"L_Click_Tr1");
                end;

                if L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                    SetToolTip(T_Tip.Btn1,X(B_1_1G.x),B_2_G.y,W(B_1_1G.w),B_2_G.h,-1,"L_Click_Tr1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_1G.x),B_2_G.y,W(B_1_1G.w),B_2_G.h,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1G.txt,B_1_1G.xt+1,B_1_1G.yt+1,B_1_1G.wt-2,B_1_1G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt+1,nil,B_2_G.ht-2);
                end;

                if L_Click_Tr1 == 2 then;
                    reaper.Main_OnCommand(40357,0);
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr1 < 0 then; CleanToolTip("L_Click_Tr1") end;
            -----
            -----
            -----
            local L_Click_Tr2 = LeftMouseButton(X(B_1_2G.x),B_2_G.y,W(B_1_2G.w),B_2_G.h,"L_Click_Tr2");
            if L_Click_Tr2 == 0 or L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                gfx.gradrect(X(B_1_2G.x)-1,B_2_G.y-1,W(B_1_2G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_2G.x-1),B_2_G.y-5,W(B_1_2G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr2 == 0 then;
                    gradient(nil,false,X(B_1_2G.x)-1,B_2_G.y-1,W(B_1_2G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt,B_1_2G.yt,B_1_2G.wt,B_1_1G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn2,X(B_1_2G.x),B_2_G.y,W(B_1_2G.w),B_2_G.h,TOOL_TIP,"L_Click_Tr2");
                end;

                if L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                    SetToolTip(T_Tip.Btn2,X(B_1_2G.x),B_2_G.y,W(B_1_2G.w),B_2_G.h,-1,"L_Click_Tr2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_2G.x),B_2_G.y,W(B_1_2G.w),B_2_G.h,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2G.txt,B_1_2G.xt+1,B_1_2G.yt+1,B_1_2G.wt-2,B_1_1G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_Tr2 == 2 then;
                    reaper.Main_OnCommand(40358,0);--Track: Set to random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr2 < 0 then; CleanToolTip("L_Click_Tr2") end;
            -----
            -----
            -----
            local L_Click_Tr3 = LeftMouseButton(X(B_1_3G.x),B_2_G.y,W(B_1_3G.w),B_2_G.h,"L_Click_Tr3");
            if L_Click_Tr3 == 0 or L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                gfx.gradrect(X(B_1_3G.x)-1,B_2_G.y-1,W(B_1_3G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_3G.x-1),B_2_G.y-5,W(B_1_3G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr3 == 0 then;
                    gradient(nil,false,X(B_1_3G.x)-1,B_2_G.y-1,W(B_1_3G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3G.txt,B_1_3G.xt,B_1_3G.yt,B_1_3G.wt,B_1_3G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn3,X(B_1_3G.x),B_2_G.y,W(B_1_3G.w),B_2_G.h,TOOL_TIP,"L_Click_Tr3");
                end;

                if L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                    SetToolTip(T_Tip.Btn3,X(B_1_3G.x),B_2_G.y,W(B_1_3G.w),B_2_G.h,-1,"L_Click_Tr3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_3G.x),B_2_G.y,W(B_1_3G.w),B_2_G.h,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3G.txt,B_1_3G.xt+1,B_1_3G.yt+1,B_1_3G.wt-2,B_1_3G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_Tr3 == 2 then;
                    reaper.Main_OnCommand(40360,0);--Track: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr3 < 0 then; CleanToolTip("L_Click_Tr3") end;
            -----
            -----
            -----
            local L_Click_Tr4 = LeftMouseButton(X(B_1_4G.x),B_2_G.y,W(B_1_4G.w),B_2_G.h,"L_Click_Tr4");
            if L_Click_Tr4 == 0 or L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                gfx.gradrect(X(B_1_4G.x)-1,B_2_G.y-1,W(B_1_4G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_4G.x-1),B_2_G.y-5,W(B_1_4G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr4 == 0 then;
                    gradient(nil,false,X(B_1_4G.x)-1,B_2_G.y-1,W(B_1_4G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt,B_1_4G.yt,B_1_4G.wt,B_1_4G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn4,X(B_1_4G.x),B_2_G.y,W(B_1_4G.w),B_2_G.h,TOOL_TIP,"L_Click_Tr4");
                end;

                if L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                    SetToolTip(T_Tip.Btn4,X(B_1_4G.x),B_2_G.y,W(B_1_4G.w),B_2_G.h,-1,"L_Click_Tr4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_4G.x),B_2_G.y,W(B_1_4G.w),B_2_G.h,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4G.txt,B_1_4G.xt+1,B_1_4G.yt+1,B_1_4G.wt-2,B_1_4G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_Tr4 == 2 then;
                    reaper.Main_OnCommand(40359,0);--Track: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr4 < 0 then; CleanToolTip("L_Click_Tr4") end;
            -----
            -----
            -----
            local L_Click_It1 = LeftMouseButton(X(B_1_5G.x),B_2_G.y,W(B_1_5G.w),B_2_G.h,"L_Click_It1");
            if L_Click_It1 == 0 or L_Click_It1 == 1 or L_Click_It1 == 2 then;
                gfx.gradrect(X(B_1_5G.x)-1,B_2_G.y-1,W(B_1_5G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_5G.x-1),B_2_G.y-5,W(B_1_5G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It1 == 0 then;
                    gradient(nil,false,X(B_1_5G.x)-1,B_2_G.y-1,W(B_1_5G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt,B_1_5G.yt,B_1_5G.wt,B_1_5G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn5,X(B_1_5G.x),B_2_G.y,W(B_1_5G.w),B_2_G.h,TOOL_TIP,"L_Click_It1");
                end;

                if L_Click_It1 == 1 or L_Click_It1 == 2 then;
                    SetToolTip(T_Tip.Btn5,X(B_1_5G.x),B_2_G.y,W(B_1_5G.w),B_2_G.h,-1,"L_Click_It1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_5G.x),B_2_G.y,W(B_1_5G.w),B_2_G.h,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5G.txt,B_1_5G.xt+1,B_1_5G.yt+1,B_1_5G.wt-2,B_1_5G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_It1 == 2 then;
                    reaper.Main_OnCommand(40704,0);--Item: Set to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It1 < 0 then; CleanToolTip("L_Click_It1") end;
            -----
            -----
            -----
            local L_Click_It2 = LeftMouseButton(X(B_1_6G.x),B_2_G.y,W(B_1_6G.w),B_2_G.h,"L_Click_It2");
            if L_Click_It2 == 0 or L_Click_It2 == 1 or L_Click_It2 == 2 then;
                gfx.gradrect(X(B_1_6G.x)-1,B_2_G.y-1,W(B_1_6G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_6G.x-1),B_2_G.y-5,W(B_1_6G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It2 == 0 then;
                    gradient(nil,false,X(B_1_6G.x)-1,B_2_G.y-1,W(B_1_6G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt,B_1_6G.yt,B_1_6G.wt,B_1_6G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn6,X(B_1_6G.x),B_2_G.y,W(B_1_6G.w),B_2_G.h,TOOL_TIP,"L_Click_It2");
                end;

                if L_Click_It2 == 1 or L_Click_It2 == 2 then;
                    SetToolTip(T_Tip.Btn6,X(B_1_6G.x),B_2_G.y,W(B_1_6G.w),B_2_G.h,-1,"L_Click_It2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_6G.x),B_2_G.y,W(B_1_6G.w),B_2_G.h,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6G.txt,B_1_6G.xt+1,B_1_6G.yt+1,B_1_6G.wt-2,B_1_6G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_It2 == 2 then;
                    reaper.Main_OnCommand(40705,0);--Item: Set to random colors
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It2 < 0 then; CleanToolTip("L_Click_It2") end;
            -----
            -----
            -----
            local L_Click_It3 = LeftMouseButton(X(B_1_7G.x),B_2_G.y,W(B_1_7G.w),B_2_G.h,"L_Click_It3");
            if L_Click_It3 == 0 or L_Click_It3 == 1 or L_Click_It3 == 2 then;
                gfx.gradrect(X(B_1_7G.x)-1,B_2_G.y-1,W(B_1_7G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_7G.x-1),B_2_G.y-5,W(B_1_7G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It3 == 0 then;
                    gradient(nil,false,X(B_1_7G.x)-1,B_2_G.y-1,W(B_1_7G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt,B_1_7G.yt,B_1_7G.wt,B_1_7G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn7,X(B_1_7G.x),B_2_G.y,W(B_1_7G.w),B_2_G.h,TOOL_TIP,"L_Click_It3");
                end;

                if L_Click_It3 == 1 or L_Click_It3 == 2 then;
                    SetToolTip(T_Tip.Btn7,X(B_1_7G.x),B_2_G.y,W(B_1_7G.w),B_2_G.h,-1,"L_Click_It3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_7G.x),B_2_G.y,W(B_1_7G.w),B_2_G.h,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7G.txt,B_1_7G.xt+1,B_1_7G.yt+1,B_1_7G.wt-2,B_1_7G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_It3 == 2 then;
                    reaper.Main_OnCommand(40706,0);--Item: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It3 < 0 then; CleanToolTip("L_Click_It3") end;
            -----
            -----
            -----
            local L_Click_It4 = LeftMouseButton(X(B_1_8G.x),B_2_G.y,W(B_1_8G.w),B_2_G.h,"L_Click_It4");
            if L_Click_It4 == 0 or L_Click_It4 == 1 or L_Click_It4 == 2 then;
                gfx.gradrect(X(B_1_8G.x)-1,B_2_G.y-1,W(B_1_8G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_8G.x-1),B_2_G.y-5,W(B_1_8G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It4 == 0 then;
                    gradient(nil,false,X(B_1_8G.x)-1,B_2_G.y-1,W(B_1_8G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt,B_1_8G.yt,B_1_8G.wt,B_1_8G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn8,X(B_1_8G.x),B_2_G.y,W(B_1_8G.w),B_2_G.h,TOOL_TIP,"L_Click_It4");
                end;

                if L_Click_It4 == 1 or L_Click_It4 == 2 then;
                    SetToolTip(T_Tip.Btn8,X(B_1_8G.x),B_2_G.y,W(B_1_8G.w),B_2_G.h,-1,"L_Click_It4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_8G.x),B_2_G.y,W(B_1_8G.w),B_2_G.h,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8G.txt,B_1_8G.xt+1,B_1_8G.yt+1,B_1_8G.wt-2,B_1_8G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_It4 == 2 then;
                    reaper.Main_OnCommand(40707,0);--Item: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It4 < 0 then; CleanToolTip("L_Click_It4") end;
            -----
            -----
            -----
            local L_Click_Tk1 = LeftMouseButton(X(B_1_9G.x),B_2_G.y,W(B_1_9G.w),B_2_G.h,"L_Click_Tk1");
            if L_Click_Tk1 == 0 or L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                gfx.gradrect(X(B_1_9G.x)-1,B_2_G.y-1,W(B_1_9G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_9G.x-1),B_2_G.y-5,W(B_1_9G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk1 == 0 then;
                    gradient(nil,false,X(B_1_9G.x)-1,B_2_G.y-1,W(B_1_9G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt,B_1_9G.yt,B_1_9G.wt,B_1_9G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn9,X(B_1_9G.x),B_2_G.y,W(B_1_9G.w),B_2_G.h,TOOL_TIP,"L_Click_Tk1");
                end;

                if L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                    SetToolTip(T_Tip.Btn9,X(B_1_9G.x),B_2_G.y,W(B_1_9G.w),B_2_G.h,-1,"L_Click_Tk1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_9G.x),B_2_G.y,W(B_1_9G.w),B_2_G.h,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9G.txt,B_1_9G.xt+1,B_1_9G.yt+1,B_1_9G.wt-2,B_1_9G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_Tk1 == 2 then;
                    reaper.Main_OnCommand(41331,0);--Take: Set active take to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk1 < 0 then; CleanToolTip("L_Click_Tk1") end;
            -----
            -----
            -----
            local L_Click_Tk2 = LeftMouseButton(X(B_1_10G.x),B_2_G.y,W(B_1_10G.w),B_2_G.h,"L_Click_Tk2");
            if L_Click_Tk2 == 0 or L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                gfx.gradrect(X(B_1_10G.x)-1,B_2_G.y-1,W(B_1_10G.w)+2,B_2_G.h+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_10G.x-1),B_2_G.y-5,W(B_1_10G.w+2),B_2_G.h+10, R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk2 == 0 then;
                    gradient(nil,false,X(B_1_10G.x)-1,B_2_G.y-1,W(B_1_10G.w)+2,B_2_G.h+2,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt,B_1_10G.yt,B_1_10G.wt,B_1_10G.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                    SetToolTip(T_Tip.Btn10, X(B_1_10G.x),B_2_G.y,W(B_1_10G.w),B_2_G.h,TOOL_TIP,"L_Click_Tk2");
                end;

                if L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                    SetToolTip(T_Tip.Btn10, X(B_1_10G.x),B_2_G.y,W(B_1_10G.w),B_2_G.h,-1,"L_Click_Tk2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_10G.x),B_2_G.y,W(B_1_10G.w),B_2_G.h,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10G.txt,B_1_10G.xt+1,B_1_10G.yt+1,B_1_10G.wt-2,B_1_10G.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, nil,B_2_G.yt,nil,B_2_G.ht);
                end;

                if L_Click_Tk2 == 2 then;
                    reaper.Main_OnCommand(41333,0);--Take: Set active take to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk2 < 0 then; CleanToolTip("L_Click_Tk2") end;
            -----
            -----
            -----
        --====================================================================================
        elseif gfx.w < gfx.h and gfx.w <= 60 then;--==========================================
        --====================================================================================
            -----
            -----
            -----
            local L_Click_Tr1 = LeftMouseButton(X(B_1_1V.x),Y(B_1_1V.y),W(B_1_1V.w),H(B_1_1V.h),"L_Click_Tr1");
            if L_Click_Tr1 == 0 or L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                gfx.gradrect(X(B_1_1V.x)-1,Y(B_1_1V.y)-1,W(B_1_1V.w)+2,H(B_1_1V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_1V.x-10),Y(B_1_1V.y-1),W(B_1_1V.w+20),H(B_1_1V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr1 == 0 then;
                    gradient(nil,false,X(B_1_1V.x)-1,Y(B_1_1V.y)-1,W(B_1_1V.w)+2,H(B_1_1V.h)+2,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1V.txt,B_1_1V.xt,B_1_1V.yt,B_1_1V.wt,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn1, X(B_1_1V.x),Y(B_1_1V.y),W(B_1_1V.w),H(B_1_1V.h),TOOL_TIP,"L_Click_Tr1");
                end;

                if L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                    SetToolTip(T_Tip.Btn1, X(B_1_1V.x),Y(B_1_1V.y),W(B_1_1V.w),H(B_1_1V.h),-1,"L_Click_Tr1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_1V.x),Y(B_1_1V.y),W(B_1_1V.w),H(B_1_1V.h),false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1V.txt,B_1_1V.xt+2,B_1_1V.yt+1,B_1_1V.wt-4,B_1_1V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr1 == 2 then;
                   reaper.Main_OnCommand(40357,0);
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;

            end;
            if L_Click_Tr1 < 0 then; CleanToolTip("L_Click_Tr1") end;
            -----
            -----
            -----
            local L_Click_Tr2 = LeftMouseButton(X(B_1_2V.x),Y(B_1_2V.y),W(B_1_2V.w),H(B_1_2V.h),"L_Click_Tr2");
            if L_Click_Tr2 == 0 or L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                gfx.gradrect(X(B_1_2V.x)-1,Y(B_1_2V.y)-1,W(B_1_2V.w)+2,H(B_1_2V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_2V.x-10),Y(B_1_2V.y-1),W(B_1_2V.w+20),H(B_1_2V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr2 == 0 then;
                    gradient(nil,false,X(B_1_2V.x)-1,Y(B_1_2V.y)-1,W(B_1_2V.w)+2,H(B_1_2V.h)+2,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2V.txt,B_1_2V.xt,B_1_2V.yt,B_1_2V.wt,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn2, X(B_1_2V.x),Y(B_1_2V.y),W(B_1_2V.w),H(B_1_2V.h),TOOL_TIP,"L_Click_Tr2");
                end;

                if L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                    SetToolTip(T_Tip.Btn2, X(B_1_2V.x),Y(B_1_2V.y),W(B_1_2V.w),H(B_1_2V.h),-1,"L_Click_Tr2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_2V.x),Y(B_1_2V.y),W(B_1_2V.w),H(B_1_2V.h),false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2V.txt,B_1_2V.xt+2,B_1_2V.yt+1,B_1_2V.wt-4,B_1_1V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr2 == 2 then;
                   reaper.Main_OnCommand(40358,0);--Track: Set to random color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr2 < 0 then; CleanToolTip("L_Click_Tr2") end;
            -----
            -----
            -----
            local L_Click_Tr3 = LeftMouseButton(X(B_1_3V.x),Y(B_1_3V.y),W(B_1_3V.w),H(B_1_3V.h),"L_Click_Tr3");
            if L_Click_Tr3 == 0 or L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                gfx.gradrect(X(B_1_3V.x)-1,Y(B_1_3V.y)-1,W(B_1_3V.w)+2,H(B_1_3V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_3V.x-10),Y(B_1_3V.y-1),W(B_1_3V.w+20),H(B_1_3V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr3 == 0 then;
                    gradient(nil,false,X(B_1_3V.x)-1,Y(B_1_3V.y)-1,W(B_1_3V.w)+2,H(B_1_3V.h)+2,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3V.txt,B_1_3V.xt,B_1_3V.yt,B_1_3V.wt,B_1_3V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn3, X(B_1_3V.x),Y(B_1_3V.y),W(B_1_3V.w),H(B_1_3V.h),TOOL_TIP,"L_Click_Tr3");
                end;

                if L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                    SetToolTip(T_Tip.Btn3, X(B_1_3V.x),Y(B_1_3V.y),W(B_1_3V.w),H(B_1_3V.h),-1,"L_Click_Tr3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_3V.x),Y(B_1_3V.y),W(B_1_3V.w),H(B_1_3V.h),false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3V.txt,B_1_3V.xt+2,B_1_3V.yt+1,B_1_3V.wt-4,B_1_3V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr3 == 2 then;
                   reaper.Main_OnCommand(40360,0);--Track: Set to one random color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr3 < 0 then; CleanToolTip("L_Click_Tr3") end;
            -----
            -----
            -----
            local L_Click_Tr4 = LeftMouseButton(X(B_1_4V.x),Y(B_1_4V.y),W(B_1_4V.w),H(B_1_4V.h),"L_Click_Tr4");
            if L_Click_Tr4 == 0 or L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                gfx.gradrect(X(B_1_4V.x)-1,Y(B_1_4V.y)-1,W(B_1_4V.w)+2,H(B_1_4V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_4V.x-10),Y(B_1_4V.y-1),W(B_1_4V.w+20),H(B_1_4V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr4 == 0 then;
                    gradient(nil,false,X(B_1_4V.x)-1,Y(B_1_4V.y)-1,W(B_1_4V.w)+2,H(B_1_4V.h)+2,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4V.txt,B_1_4V.xt,B_1_4V.yt,B_1_4V.wt,B_1_4V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn4, X(B_1_4V.x),Y(B_1_4V.y),W(B_1_4V.w),H(B_1_4V.h),TOOL_TIP,"L_Click_Tr4");
                end;

                if L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                    SetToolTip(T_Tip.Btn4, X(B_1_4V.x),Y(B_1_4V.y),W(B_1_4V.w),H(B_1_4V.h),-1,"L_Click_Tr4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_4V.x),Y(B_1_4V.y),W(B_1_4V.w),H(B_1_4V.h),false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4V.txt,B_1_4V.xt+2,B_1_4V.yt+1,B_1_4V.wt-4,B_1_4V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tr4 == 2 then;
                   reaper.Main_OnCommand(40359,0);--Track: Set to default color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr4 < 0 then; CleanToolTip("L_Click_Tr4") end;
            -----
            -----
            -----
            local L_Click_It1 = LeftMouseButton(X(B_1_5V.x),Y(B_1_5V.y),W(B_1_5V.w),H(B_1_5V.h),"L_Click_It1");
            if L_Click_It1 == 0 or L_Click_It1 == 1 or L_Click_It1 == 2 then;
                gfx.gradrect(X(B_1_5V.x)-1,Y(B_1_5V.y)-1,W(B_1_5V.w)+2,H(B_1_5V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_5V.x-10),Y(B_1_5V.y-1),W(B_1_5V.w+20),H(B_1_5V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It1 == 0 then;
                    gradient(nil,false,X(B_1_5V.x)-1,Y(B_1_5V.y)-1,W(B_1_5V.w)+2,H(B_1_5V.h)+2,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5V.txt,B_1_5V.xt,B_1_5V.yt,B_1_5V.wt,B_1_5V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn5, X(B_1_5V.x),Y(B_1_5V.y),W(B_1_5V.w),H(B_1_5V.h),TOOL_TIP,"L_Click_It1");
                end;

                if L_Click_It1 == 1 or L_Click_It1 == 2 then;
                    SetToolTip(T_Tip.Btn5, X(B_1_5V.x),Y(B_1_5V.y),W(B_1_5V.w),H(B_1_5V.h),-1,"L_Click_It1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_5V.x),Y(B_1_5V.y),W(B_1_5V.w),H(B_1_5V.h),false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5V.txt,B_1_5V.xt+2,B_1_5V.yt+1,B_1_5V.wt-4,B_1_5V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It1 == 2 then;
                   reaper.Main_OnCommand(40704,0);--Item: Set to custom color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;

            end;
            if L_Click_It1 < 0 then; CleanToolTip("L_Click_It1") end;
            -----
            -----
            -----
            local L_Click_It2 = LeftMouseButton(X(B_1_6V.x),Y(B_1_6V.y),W(B_1_6V.w),H(B_1_6V.h),"L_Click_It2");
            if L_Click_It2 == 0 or L_Click_It2 == 1 or L_Click_It2 == 2 then;
                gfx.gradrect(X(B_1_6V.x)-1,Y(B_1_6V.y)-1,W(B_1_6V.w)+2,H(B_1_6V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_6V.x-10),Y(B_1_6V.y-1),W(B_1_6V.w+20),H(B_1_6V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It2 == 0 then;
                    gradient(nil,false,X(B_1_6V.x)-1,Y(B_1_6V.y)-1,W(B_1_6V.w)+2,H(B_1_6V.h)+2,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6V.txt,B_1_6V.xt,B_1_6V.yt,B_1_6V.wt,B_1_6V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn6, X(B_1_6V.x),Y(B_1_6V.y),W(B_1_6V.w),H(B_1_6V.h),TOOL_TIP,"L_Click_It2");
                end;

                if L_Click_It2 == 1 or L_Click_It2 == 2 then;
                    SetToolTip(T_Tip.Btn6, X(B_1_6V.x),Y(B_1_6V.y),W(B_1_6V.w),H(B_1_6V.h),-1,"L_Click_It2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_6V.x),Y(B_1_6V.y),W(B_1_6V.w),H(B_1_6V.h),false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6V.txt,B_1_6V.xt+2,B_1_6V.yt+1,B_1_6V.wt-4,B_1_6V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It2 == 2 then;
                   reaper.Main_OnCommand(40705,0);--Item: Set to random colors
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It2 < 0 then; CleanToolTip("L_Click_It2") end;
            -----
            -----
            -----
            local L_Click_It3 = LeftMouseButton(X(B_1_7V.x),Y(B_1_7V.y),W(B_1_7V.w),H(B_1_7V.h),"L_Click_It3");
            if L_Click_It3 == 0 or L_Click_It3 == 1 or L_Click_It3 == 2 then;
                gfx.gradrect(X(B_1_7V.x)-1,Y(B_1_7V.y)-1,W(B_1_7V.w)+2,H(B_1_7V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_7V.x-10),Y(B_1_7V.y-1),W(B_1_7V.w+20),H(B_1_7V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It3 == 0 then;
                    gradient(nil,false,X(B_1_7V.x)-1,Y(B_1_7V.y)-1,W(B_1_7V.w)+2,H(B_1_7V.h)+2,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7V.txt,B_1_7V.xt,B_1_7V.yt,B_1_7V.wt,B_1_7V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn7, X(B_1_7V.x),Y(B_1_7V.y),W(B_1_7V.w),H(B_1_7V.h),TOOL_TIP,"L_Click_It3");
                end;

                if L_Click_It3 == 1 or L_Click_It3 == 2 then;
                    SetToolTip(T_Tip.Btn7, X(B_1_7V.x),Y(B_1_7V.y),W(B_1_7V.w),H(B_1_7V.h),-1,"L_Click_It3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_7V.x),Y(B_1_7V.y),W(B_1_7V.w),H(B_1_7V.h),false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7V.txt,B_1_7V.xt+2,B_1_7V.yt+1,B_1_7V.wt-4,B_1_7V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It3 == 2 then;
                   reaper.Main_OnCommand(40706,0);--Item: Set to one random color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It3 < 0 then; CleanToolTip("L_Click_It3") end;
            -----
            -----
            -----
            local L_Click_It4 = LeftMouseButton(X(B_1_8V.x),Y(B_1_8V.y),W(B_1_8V.w),H(B_1_8V.h),"L_Click_It4");
            if L_Click_It4 == 0 or L_Click_It4 == 1 or L_Click_It4 == 2 then;
                gfx.gradrect(X(B_1_8V.x)-1,Y(B_1_8V.y)-1,W(B_1_8V.w)+2,H(B_1_8V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_8V.x-10),Y(B_1_8V.y-1),W(B_1_8V.w+20),H(B_1_8V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It4 == 0 then;
                    gradient(nil,false,X(B_1_8V.x)-1,Y(B_1_8V.y)-1,W(B_1_8V.w)+2,H(B_1_8V.h)+2,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8V.txt,B_1_8V.xt,B_1_8V.yt,B_1_8V.wt,B_1_8V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn8, X(B_1_8V.x),Y(B_1_8V.y),W(B_1_8V.w),H(B_1_8V.h),TOOL_TIP,"L_Click_It4");
                end;

                if L_Click_It4 == 1 or L_Click_It4 == 2 then;
                    SetToolTip(T_Tip.Btn8, X(B_1_8V.x),Y(B_1_8V.y),W(B_1_8V.w),H(B_1_8V.h),-1,"L_Click_It4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_8V.x),Y(B_1_8V.y),W(B_1_8V.w),H(B_1_8V.h),false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8V.txt,B_1_8V.xt+2,B_1_8V.yt+1,B_1_8V.wt-4,B_1_8V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_It4 == 2 then;
                   reaper.Main_OnCommand(40707,0);--Item: Set to default color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It4 < 0 then; CleanToolTip("L_Click_It4") end;
            -----
            -----
            -----
            local L_Click_Tk1 = LeftMouseButton(X(B_1_9V.x),Y(B_1_9V.y),W(B_1_9V.w),H(B_1_9V.h),"L_Click_Tk1");
            if L_Click_Tk1 == 0 or L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                gfx.gradrect(X(B_1_9V.x)-1,Y(B_1_9V.y)-1,W(B_1_9V.w)+2,H(B_1_9V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_9V.x-10),Y(B_1_9V.y-1),W(B_1_9V.w+20),H(B_1_9V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk1 == 0 then;
                    gradient(nil,false,X(B_1_9V.x)-1,Y(B_1_9V.y)-1,W(B_1_9V.w)+2,H(B_1_9V.h)+2,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9V.txt,B_1_9V.xt,B_1_9V.yt,B_1_9V.wt,B_1_9V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn9, X(B_1_9V.x),Y(B_1_9V.y),W(B_1_9V.w),H(B_1_9V.h),TOOL_TIP,"L_Click_Tk1");
                end;

                if L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                    SetToolTip(T_Tip.Btn9, X(B_1_9V.x),Y(B_1_9V.y),W(B_1_9V.w),H(B_1_9V.h),-1,"L_Click_Tk1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_9V.x),Y(B_1_9V.y),W(B_1_9V.w),H(B_1_9V.h),false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9V.txt,B_1_9V.xt+2,B_1_9V.yt+1,B_1_9V.wt-4,B_1_9V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tk1 == 2 then;
                   reaper.Main_OnCommand(41331,0);--Take: Set active take to custom color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk1 < 0 then; CleanToolTip("L_Click_Tk1") end;
            -----
            -----
            -----
            local L_Click_Tk2 = LeftMouseButton(X(B_1_10V.x),Y(B_1_10V.y),W(B_1_10V.w),H(B_1_10V.h),"L_Click_Tk2");
            if L_Click_Tk2 == 0 or L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                gfx.gradrect(X(B_1_10V.x)-1,Y(B_1_10V.y)-1,W(B_1_10V.w)+2,H(B_1_10V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(X(B_1_10V.x-10),Y(B_1_10V.y-1),W(B_1_10V.w+20),H(B_1_10V.h+2),R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk2 == 0 then;
                    gradient(nil,false,X(B_1_10V.x)-1,Y(B_1_10V.y)-1,W(B_1_10V.w)+2,H(B_1_10V.h)+2,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10V.txt,B_1_10V.xt,B_1_10V.yt,B_1_10V.wt,B_1_10V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                    SetToolTip(T_Tip.Btn10, X(B_1_10V.x),Y(B_1_10V.y),W(B_1_10V.w),H(B_1_10V.h),TOOL_TIP,"L_Click_Tk2");
                end;

                if L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                    SetToolTip(T_Tip.Btn10, X(B_1_10V.x),Y(B_1_10V.y),W(B_1_10V.w),H(B_1_10V.h),-1,"L_Click_Tk2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false,X(B_1_10V.x),Y(B_1_10V.y),W(B_1_10V.w),H(B_1_10V.h),false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10V.txt,B_1_10V.xt+2,B_1_10V.yt+1,B_1_10V.wt-4,B_1_10V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text);
                end;

                if L_Click_Tk2 == 2 then;
                   reaper.Main_OnCommand(41333,0);--Take: Set active take to default color
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk2 < 0 then; CleanToolTip("L_Click_Tk2") end;
            -----
            -----
            -----
        --====================================================================================
        elseif gfx.w < gfx.h and gfx.w > 60 then;--===========================================
        --====================================================================================
            -----
            -----
            -----
            local dblClick = doubleClick(Grd_szV.x,Y(99)-fade_vG.h,Grd_szV.w,fade_vG.h,500);
            if dblClick then GRD_Bright = 0 end;

            GRD_Bright = sliderG(0,Grd_szV.x,Y(99)-fade_vG.h,Grd_szV.w,fade_vG.h, GRD_Bright or 0,  0,1,   true_, flam);
            if GRD_Bright ~= GRD_Bright2 then;
                GRD_Bright2 = GRD_Bright;
                Start_GUI();
                reaper.SetExtState(section,"GRD_Bright",GRD_Bright,true);
            end;
            -----
            -----
            -----
            local L_Click_Grd = LeftMouseButton(Grd_szV.x, Grd_szV.y, Grd_szV.w, Grd_szV.h,"GRDNT_V");
            if L_Click_Grd == 1 then;
            ----
                if gfx.mouse_x > Grd_szV.x and gfx.mouse_x < Grd_szV.x + Grd_szV.w and
                   gfx.mouse_y > Grd_szV.y and gfx.mouse_y < Grd_szV.y + Grd_szV.h then;

                   ---
                   local Context = reaper.GetCursorContext2(true);
                   local Str;
                   if Context == 1 then;
                       local CountSelItem = reaper.CountSelectedMediaItems(0);
                       if CountSelItem == 0 then;
                           Str = "ITEM / No items selected!"
                       else;
                           Str = "ITEM"
                       end;
                   else;
                       local CountSelTrack = reaper.CountSelectedTracks(0);
                       if CountSelTrack == 0 then;
                           Str = "TRACK / No track selected !";
                       else;
                           Str = "Track";
                       end;
                   end;

                   if COL_PREV_GRAD == 1 then;
                       if #Str < 10 then;
                           gfx.x,gfx.y = gfx.mouse_x, gfx.mouse_y;
                           local rp,gp,bp = gfx.getpixel();
                           gradient(nil,false,B_2_V.x ,Y(1),B_2_V.w ,H(98),false,false,1,{{rp,gp,bp}},0,flam_grd);
                       end;
                   end;

                   if TOOLTIP_GRDNT == 1 then;
                       local lengthFont,heightFont = gfx.measurestr(Str);
                       if gfx.mouse_x > gfx.w / 2 then;
                           gfx.x = gfx.mouse_x - lengthFont-30;
                       else;
                           gfx.x = gfx.mouse_x + 30;
                       end;
                       if gfx.mouse_y > gfx.h / 2 then;
                           gfx.y = gfx.mouse_y - 30;
                       else;
                           gfx.y = gfx.mouse_y + 30;
                       end;

                       gfx.setfont(1,"Arial",16,0);--BOLD=98,ITALIC=105,UNDERLINE=117
                       gfx.gradrect(gfx.x-3,gfx.y-1,lengthFont+6,heightFont+2, .7,.7,.7,.5);
                       gfx.set(.2,.2,.2,.6);
                       gfx.roundrect(gfx.x-4,gfx.y-1,lengthFont+7,heightFont+2,2);
                       gfx.set(.1);
                       gfx.drawstr(Str);
                    end;
                end;
                ----
            elseif L_Click_Grd == 2 then;
                ----
                local Context = reaper.GetCursorContext2(true);
                gfx.x,gfx.y = gfx.mouse_x, gfx.mouse_y;
                local rp,gp,bp = gfx.getpixel();
                local custonColor = reaper.ColorToNative(rp*255,gp*255,bp*255)|0x1000000;
                if Context == 1 then;--ITEM
                    local CountSelItem = reaper.CountSelectedMediaItems(0);
                    if CountSelItem > 0 then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        for i = 1,CountSelItem do;
                            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
                            reaper.SetMediaItemInfo_Value(SelItem,"I_CUSTOMCOLOR",custonColor);
                        end;
                        reaper.PreventUIRefresh(-1);
                        reaper.Undo_EndBlock("Set item color",-1);
                    end;
                else;
                    local CountSelTrack = reaper.CountSelectedTracks(0);
                    if CountSelTrack > 0 then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        for i = 1,CountSelTrack do;
                            local SelTrack = reaper.GetSelectedTrack(0,i-1);
                            reaper.SetMediaTrackInfo_Value(SelTrack,"I_CUSTOMCOLOR",custonColor);
                        end;
                        reaper.PreventUIRefresh(-1);
                        reaper.Undo_EndBlock("Set track color",-1);
                    end;
                end;
                reaper.UpdateArrange();
                if CLICK_GRD_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
            end;
            -----
            -----
            -----
            local L_Click_Tr1 = LeftMouseButton(B_2_V.x,Y(B_1_1V.y),B_2_V.w,H(B_1_1V.h),"L_Click_Tr1");
            if L_Click_Tr1 == 0 or L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_1V.y)-1,B_2_V.w+2,H(B_1_1V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(0,Y(B_1_1V.y-1),B_2_V.w+10,H(B_1_1V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end
                if L_Click_Tr1 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_1V.y)-1,B_2_V.w+2,H(B_1_1V.h)+2 ,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1V.txt,0,B_1_1V.yt,0,B_1_1V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text,B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn1,B_2_V.x,Y(B_1_1V.y),B_2_V.w,H(B_1_1V.h),TOOL_TIP,"L_Click_Tr1");
                end;

                if L_Click_Tr1 == 1 or L_Click_Tr1 == 2 then;
                    SetToolTip(T_Tip.Btn1,B_2_V.x,Y(B_1_1V.y),B_2_V.w,H(B_1_1V.h),-1,"L_Click_Tr1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_1V.y),B_2_V.w,H(B_1_1V.h) ,false,false,But_Transp,gradBut[1],But_Bright,flam);
                    TextByCenterAndResize(B_1_1V.txt,0,B_1_1V.yt+1,0,B_1_1V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text,B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tr1 == 2 then;
                   reaper.Main_OnCommand(40357,0);
                   if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr1 < 0 then; CleanToolTip("L_Click_Tr1") end;
            -----
            -----
            -----
            local L_Click_Tr2 = LeftMouseButton(B_2_V.x,Y(B_1_2V.y),B_2_V.w,H(B_1_2V.h),"L_Click_Tr2");
            if L_Click_Tr2 == 0 or L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_2V.y)-1,B_2_V.w+2,H(B_1_2V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_2V.y-1),B_2_V.w+10,H(B_1_2V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end
                if L_Click_Tr2 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_2V.y)-1,B_2_V.w+2,H(B_1_2V.h)+2 ,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2V.txt,0,B_1_2V.yt,0,B_1_2V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn2,B_2_V.x,Y(B_1_2V.y),B_2_V.w,H(B_1_2V.h),TOOL_TIP,"L_Click_Tr2");
                end;

                if L_Click_Tr2 == 1 or L_Click_Tr2 == 2 then;
                    SetToolTip(T_Tip.Btn2,B_2_V.x,Y(B_1_2V.y),B_2_V.w,H(B_1_2V.h),-1,"L_Click_Tr2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_2V.y),B_2_V.w,H(B_1_2V.h) ,false,false,But_Transp,gradBut[2],But_Bright,flam);
                    TextByCenterAndResize(B_1_2V.txt,0,B_1_2V.yt+1,0,B_1_2V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tr2 == 2 then;
                    reaper.Main_OnCommand(40358,0);--Track: Set to random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr2 < 0 then; CleanToolTip("L_Click_Tr2") end;
            -----
            -----
            -----
            local L_Click_Tr3 = LeftMouseButton(B_2_V.x,Y(B_1_3V.y),B_2_V.w,H(B_1_3V.h),"L_Click_Tr3");
            if L_Click_Tr3 == 0 or L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_3V.y)-1,B_2_V.w+2,H(B_1_3V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_3V.y-1),B_2_V.w+10,H(B_1_3V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr3 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_3V.y)-1,B_2_V.w+2,H(B_1_3V.h)+2 ,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3V.txt,0,B_1_3V.yt,0,B_1_3V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn3,B_2_V.x,Y(B_1_3V.y),B_2_V.w,H(B_1_3V.h),TOOL_TIP,"L_Click_Tr3");
                end;

                if L_Click_Tr3 == 1 or L_Click_Tr3 == 2 then;
                    SetToolTip(T_Tip.Btn3,B_2_V.x,Y(B_1_3V.y),B_2_V.w,H(B_1_3V.h),-1,"L_Click_Tr3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_3V.y),B_2_V.w,H(B_1_3V.h) ,false,false,But_Transp,gradBut[3],But_Bright,flam);
                    TextByCenterAndResize(B_1_3V.txt,0,B_1_3V.yt+1,0,B_1_3V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tr3 == 2 then;
                    reaper.Main_OnCommand(40360,0);--Track: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr3 < 0 then; CleanToolTip("L_Click_Tr3") end;
            -----
            -----
            -----
            local L_Click_Tr4 = LeftMouseButton(B_2_V.x,Y(B_1_4V.y),B_2_V.w,H(B_1_4V.h),"L_Click_Tr4");
            if L_Click_Tr4 == 0 or L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_4V.y)-1,B_2_V.w+2,H(B_1_4V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_4V.y-1),B_2_V.w+10,H(B_1_4V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tr4 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_4V.y)-1,B_2_V.w+2,H(B_1_4V.h)+2  ,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4V.txt,0,B_1_4V.yt,0,B_1_4V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn4,B_2_V.x,Y(B_1_4V.y),B_2_V.w,H(B_1_4V.h),TOOL_TIP,"L_Click_Tr4");
                end;

                if L_Click_Tr4 == 1 or L_Click_Tr4 == 2 then;
                    SetToolTip(T_Tip.Btn4,B_2_V.x,Y(B_1_4V.y),B_2_V.w,H(B_1_4V.h),-1,"L_Click_Tr4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_4V.y),B_2_V.w,H(B_1_4V.h)  ,false,false,But_Transp,gradBut[4],But_Bright,flam);
                    TextByCenterAndResize(B_1_4V.txt,0,B_1_4V.yt+1,0,B_1_4V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tr4 == 2 then;
                    reaper.Main_OnCommand(40359,0);--Track: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tr4 < 0 then; CleanToolTip("L_Click_Tr4") end;
            -----
            -----
            -----
            local L_Click_It1 = LeftMouseButton(B_2_V.x,Y(B_1_5V.y),B_2_V.w,H(B_1_5V.h),"L_Click_It1");
            if L_Click_It1 == 0 or L_Click_It1 == 1 or L_Click_It1 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_5V.y)-1,B_2_V.w+2,H(B_1_5V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_5V.y-1),B_2_V.w+10,H(B_1_5V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It1 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_5V.y)-1,B_2_V.w+2,H(B_1_5V.h)+2  ,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5V.txt,0,B_1_5V.yt,0,B_1_5V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn5,B_2_V.x,Y(B_1_5V.y),B_2_V.w,H(B_1_5V.h),TOOL_TIP,"L_Click_It1");
                end;

                if L_Click_It1 == 1 or L_Click_It1 == 2 then;
                    SetToolTip(T_Tip.Btn5,B_2_V.x,Y(B_1_5V.y),B_2_V.w,H(B_1_5V.h),-1,"L_Click_It1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_5V.y),B_2_V.w,H(B_1_5V.h)  ,false,false,But_Transp,gradBut[5],But_Bright,flam);
                    TextByCenterAndResize(B_1_5V.txt,0,B_1_5V.yt+1,0,B_1_5V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_It1 == 2 then;
                    reaper.Main_OnCommand(40704,0);--Item: Set to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It1 < 0 then; CleanToolTip("L_Click_It1") end;
            -----
            -----
            -----
            local L_Click_It2 = LeftMouseButton(B_2_V.x,Y(B_1_6V.y),B_2_V.w,H(B_1_6V.h),"L_Click_It2");
            if L_Click_It2 == 0 or L_Click_It2 == 1 or L_Click_It2 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_6V.y)-1,B_2_V.w+2,H(B_1_6V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_6V.y-1),B_2_V.w+10,H(B_1_6V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It2 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_6V.y)-1,B_2_V.w+2,H(B_1_6V.h)+2  ,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6V.txt,0,B_1_6V.yt,0,B_1_6V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn6,B_2_V.x,Y(B_1_6V.y),B_2_V.w,H(B_1_6V.h),TOOL_TIP,"L_Click_It2");
                end;

                if L_Click_It2 == 1 or L_Click_It2 == 2 then;
                    SetToolTip(T_Tip.Btn6,B_2_V.x,Y(B_1_6V.y),B_2_V.w,H(B_1_6V.h),-1,"L_Click_It2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_6V.y),B_2_V.w,H(B_1_6V.h)  ,false,false,But_Transp,gradBut[6],But_Bright,flam);
                    TextByCenterAndResize(B_1_6V.txt,0,B_1_6V.yt+1,0,B_1_6V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_It2 == 2 then;
                    reaper.Main_OnCommand(40705,0);--Item: Set to random colors
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It2 < 0 then; CleanToolTip("L_Click_It2") end;
            -----
            -----
            -----
            local L_Click_It3 = LeftMouseButton(B_2_V.x,Y(B_1_7V.y),B_2_V.w,H(B_1_7V.h),"L_Click_It3");
            if L_Click_It3 == 0 or L_Click_It3 == 1 or L_Click_It3 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_7V.y)-1,B_2_V.w+2,H(B_1_7V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_7V.y-1),B_2_V.w+10,H(B_1_7V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It3 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_7V.y)-1,B_2_V.w+2,H(B_1_7V.h)+2  ,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7V.txt,0,B_1_7V.yt,0,B_1_7V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn7,B_2_V.x,Y(B_1_7V.y),B_2_V.w,H(B_1_7V.h),TOOL_TIP,"L_Click_It3");
                end;

                if L_Click_It3 == 1 or L_Click_It3 == 2 then;
                    SetToolTip(T_Tip.Btn7,B_2_V.x,Y(B_1_7V.y),B_2_V.w,H(B_1_7V.h),-1,"L_Click_It3");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_7V.y),B_2_V.w,H(B_1_7V.h)  ,false,false,But_Transp,gradBut[7],But_Bright,flam);
                    TextByCenterAndResize(B_1_7V.txt,0,B_1_7V.yt+1,0,B_1_7V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_It3 == 2 then;
                    reaper.Main_OnCommand(40706,0);--Item: Set to one random color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It3 < 0 then; CleanToolTip("L_Click_It3") end;
            -----
            -----
            -----
            local L_Click_It4 = LeftMouseButton(B_2_V.x,Y(B_1_8V.y),B_2_V.w,H(B_1_8V.h),"L_Click_It4");
            if L_Click_It4 == 0 or L_Click_It4 == 1 or L_Click_It4 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_8V.y)-1,B_2_V.w+2,H(B_1_8V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_8V.y-1),B_2_V.w+10,H(B_1_8V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_It4 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_8V.y)-1,B_2_V.w+2,H(B_1_8V.h)+2  ,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8V.txt,0,B_1_8V.yt,0,B_1_8V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn8,B_2_V.x,Y(B_1_8V.y),B_2_V.w,H(B_1_8V.h),TOOL_TIP,"L_Click_It4");
                end;

                if L_Click_It4 == 1 or L_Click_It4 == 2 then;
                    SetToolTip(T_Tip.Btn8,B_2_V.x,Y(B_1_8V.y),B_2_V.w,H(B_1_8V.h),-1,"L_Click_It4");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_8V.y),B_2_V.w,H(B_1_8V.h)  ,false,false,But_Transp,gradBut[8],But_Bright,flam);
                    TextByCenterAndResize(B_1_8V.txt,0,B_1_8V.yt+1,0,B_1_8V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_It4 == 2 then;
                    reaper.Main_OnCommand(40707,0);--Item: Set to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_It4 < 0 then; CleanToolTip("L_Click_It4") end;
            -----
            -----
            -----
            local L_Click_Tk1 = LeftMouseButton(B_2_V.x,Y(B_1_9V.y),B_2_V.w,H(B_1_9V.h),"L_Click_Tk1");
            if L_Click_Tk1 == 0 or L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_9V.y)-1,B_2_V.w+2,H(B_1_9V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_9V.y-1),B_2_V.w+10,H(B_1_9V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk1 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_9V.y)-1,B_2_V.w+2,H(B_1_9V.h)+2  ,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9V.txt,0,B_1_9V.yt,0,B_1_9V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn9,B_2_V.x,Y(B_1_9V.y),B_2_V.w,H(B_1_9V.h),TOOL_TIP,"L_Click_Tk1");
                end;

                if L_Click_Tk1 == 1 or L_Click_Tk1 == 2 then;
                    SetToolTip(T_Tip.Btn9,B_2_V.x,Y(B_1_9V.y),B_2_V.w,H(B_1_9V.h),-1,"L_Click_Tk1");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_9V.y),B_2_V.w,H(B_1_9V.h)  ,false,false,But_Transp,gradBut[9],But_Bright,flam);
                    TextByCenterAndResize(B_1_9V.txt,0,B_1_9V.yt+1,0,B_1_9V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tk1 == 2 then;
                    reaper.Main_OnCommand(41331,0);--Take: Set active take to custom color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk1 < 0 then; CleanToolTip("L_Click_Tk1") end;
            -----
            -----
            -----
            local L_Click_Tk2 = LeftMouseButton(B_2_V.x,Y(B_1_10V.y),B_2_V.w,H(B_1_10V.h),"L_Click_Tk2");
            if L_Click_Tk2 == 0 or L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                gfx.gradrect(B_2_V.x-1,Y(B_1_10V.y)-1,B_2_V.w+2,H(B_1_10V.h)+2, R_Back/255,G_Back/255,B_Back/255, 1);
                if BACKLIGHT_BTN == 1 then;
                    gfx.gradrect(B_2_V.x-5,Y(B_1_10V.y-1),B_2_V.w+10,H(B_1_10V.h+2), R_Gui/255,G_Gui/255,B_Gui/255, .4);
                end;
                if L_Click_Tk2 == 0 then;
                    gradient(nil,false, B_2_V.x-1,Y(B_1_10V.y)-1,B_2_V.w+2,H(B_1_10V.h)+2  ,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10V.txt,0,B_1_10V.yt,0,B_1_10V.ht,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt,nil,B_2_V.wt);
                    SetToolTip(T_Tip.Btn10,B_2_V.x,Y(B_1_10V.y),B_2_V.w,H(B_1_10V.h),TOOL_TIP,"L_Click_Tk2");
                end;

                if L_Click_Tk2 == 1 or L_Click_Tk2 == 2 then;
                    SetToolTip(T_Tip.Btn10,B_2_V.x,Y(B_1_10V.y),B_2_V.w,H(B_1_10V.h),-1,"L_Click_Tk2");
                    flam[1] = flam[1]+1;
                    flam[5] = 1;
                    gradient(nil,false, B_2_V.x,Y(B_1_10V.y),B_2_V.w,H(B_1_10V.h)  ,false,false,But_Transp,gradBut[10],But_Bright,flam);
                    TextByCenterAndResize(B_1_10V.txt,0,B_1_10V.yt+1,0,B_1_10V.ht-2,FontSize,TextBoldNorm,R_Text,G_Text,B_Text, B_2_V.xt+1,nil,B_2_V.wt-2);
                end;

                if L_Click_Tk2 == 2 then;
                    reaper.Main_OnCommand(41333,0);--Take: Set active take to default color
                    if CLICK_BUT_CLOSE_WIN == 1 then reaper.atexit(exit)return end;
                end;
            end;
            if L_Click_Tk2 < 0 then; CleanToolTip("L_Click_Tk2") end;
            -----
            -----
            -----
        end;--================================================================================
        --====================================================================================
        --====================================================================================
        --====================================================================================


        --gfxRestScrin_buf(0,0,0,gfx.w,gfx.h);
        --local flam ,Grd_szG = ret_flam_Grd_szG();
        --GRD_Bright =  sliderV(0,X(99)-fade_vG.w,Grd_szG.y,fade_vG.w,Grd_szG.h,GRD_Bright or 0,2,1,flam);
        --body-- / Рисуем функциональность (горящие кнопочки и т.д.)


        --------------------------------------------------------
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

            local checkRemFocWin;
            if RemFocusWin == 1 then checkRemFocWin = "!" else checkRemFocWin = "" end;

            local checkedButWClose;
            if CLICK_BUT_CLOSE_WIN == 1 then checkedButWClose = "!" else checkedButWClose = "" end;

            local checkedGrdWClose;
            if CLICK_GRD_CLOSE_WIN == 1 then checkedGrdWClose = "!" else checkedGrdWClose = "" end;

            local checkedLClose;
            if FOCUS_LOST_CLOSE == 1 then checkedLClose = "!" else checkedLClose = "" end;


            local checkTtip_grdnt;
            if TOOLTIP_GRDNT == 1 then checkTtip_grdnt = "!" else checkTtip_grdnt = "" end;


            local checkedTTip;
            if TOOL_TIP == 1 then checkedTTip = "!" else checkedTTip = "" end;

            local check_BACKLIGHT;
            if BACKLIGHT_BTN == 1 then check_BACKLIGHT = "!" else check_BACKLIGHT = "" end;

            local check_COLPREV;
            if COL_PREV_GRAD == 1 then check_COLPREV = "!" else check_COLPREV = "" end;

            local
            showmenu = gfx.showmenu(--[[ 1]]checkedDock.."Dock Color switch in Docker||"..
                                    --[[->]]">Tip|"..
                                    --[[ 2]]checkedTTip.."Tool Tip|"..
                                    --[[ 3]]checkTtip_grdnt.."Show tooltip on gradient|"..
                                    --[[ 4]]"<"..check_COLPREV.."Color preview / gradient||"..
                                    --[[ 5]]"Default color all Track|"..
                                    --[[ 6]]"Default color all Item / Take|"..
                                    --[[ 7]]"Default color all Track / Item / Take||"..
                                    --[[->]]">Settings|"..
                                    --[[->]]">Window|"..
                                    --[[ 8]]"# #||"..
                                    --[[ 9]]checkedGrdWClose.."When click gradient close window|"..
                                    --[[ 10]]checkedButWClose.."When click button close window|"..
                                    --[[ 11]]checkedLClose.."Close window when focus is lost||"..
                                    --[[ 12]]"<"..checkRemFocWin.."Remove focus from window (useful when switching Screenset)|"..
                                    --[[->]]">View|"..
                                    --[[->]]">Color|"..
                                    --[[13]]"Customize text color...|"..
                                    --[[14]]"Default text color||"..
                                    --[[15]]"Customize background color|"..
                                    --[[16]]"Default background color||"..
                                    --[[17]]"Customize Gui color|"..
                                    --[[18]]"Default Gui color||"..
                                    --[[19]]"<Default All color|"..
                                    --[[20]]checkBold.."Text: Normal / Bold|"..
                                    --[[21]]checkZoomInOn.."Font Size||"..
                                    --[[ >]]">Button|"..
                                    --[[22]]"# #||"..
                                    --[[23]]"Button: Brightness  (white-black)|"..
                                    --[[24]]"Button: Transparency (alpha)|"..
                                    --[[25]]"Frame: Transparency (alpha)|"..
                                    --[[26]]"Frame: Frame Thickness|"..
                                    --[[27]]check_BACKLIGHT.."Backlight||"..
                                    --[[28]]"<Default: Transparency / Brightness / Backlight|<|"..
                                    --[[->]]">Default|"..
                                    --[[29]]"Default All color Gui|"..
                                    --[[30]]"<Default Script|<|"..
                                    --[[->]]">Support project |"..
                                    --[[31]]"Dodate ||"..
                                    --[[32]]"Bug report (Of site forum)|"..
                                    --[[33]]"<Bug report (Rmm forum)||"..
                                    --[[34]]"Close Color switch window");


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
                if TOOL_TIP == 1 then TOOL_TIP = 0 else TOOL_TIP = 1 end;
                reaper.SetExtState(section,"TOOL_TIP",TOOL_TIP,true);
                ----
            elseif showmenu == 3 then;
                ----
                if TOOLTIP_GRDNT == 1 then TOOLTIP_GRDNT = 0 else TOOLTIP_GRDNT = 1 end;
                reaper.SetExtState(section,"TOOLTIP_GRDNT",TOOLTIP_GRDNT,true);
                ----
            elseif showmenu == 4 then;
                ----
                if COL_PREV_GRAD == 1 then COL_PREV_GRAD = 0 else COL_PREV_GRAD = 1 end;
                reaper.SetExtState(section,"COL_PREV_GRAD",COL_PREV_GRAD,true);
                ----
            elseif showmenu == 5 then;
                ----
                default_Color_All_Track();
                ----
            elseif showmenu == 6 then;
                ----
                default_Color_All_Item_Take();
                ----
            elseif showmenu == 7 then;
                ----
                local CountItem = reaper.CountMediaItems(0);
                local CountTrack = reaper.CountTracks(0);
                if CountItem > 0 or CountTrack > 0 then;
                    reaper.Undo_BeginBlock();
                    default_Color_All_Track();
                    default_Color_All_Item_Take();
                    reaper.Undo_EndBlock("Default color all Track / Item / Take",-1);
                end;
                ----
            elseif showmenu == 8 then;
                ----
            elseif showmenu == 9 then;
                ----
                if CLICK_GRD_CLOSE_WIN == 1 then CLICK_GRD_CLOSE_WIN = 0 else CLICK_GRD_CLOSE_WIN = 1 end;
                reaper.SetExtState(section,"CLICK_GRD_CLOSE_WIN",CLICK_GRD_CLOSE_WIN,true);
                ----
            elseif showmenu == 10 then;
                ----
                if CLICK_BUT_CLOSE_WIN == 1 then CLICK_BUT_CLOSE_WIN = 0 else CLICK_BUT_CLOSE_WIN = 1 end;
                reaper.SetExtState(section,"CLICK_BUT_CLOSE_WIN",CLICK_BUT_CLOSE_WIN,true);
                ----
            elseif showmenu == 11 then;
                ----
                if FOCUS_LOST_CLOSE == 1 then FOCUS_LOST_CLOSE = 0 else FOCUS_LOST_CLOSE = 1 end;
                reaper.SetExtState(section,"FOCUS_LOST_CLOSE",FOCUS_LOST_CLOSE,true);
                if FOCUS_LOST_CLOSE == 1 then;
                    reaper.SetExtState(section,"RemFocusWin",0,true);RemFocusWin=0;
                end;
                ----
            elseif showmenu == 12 then;
                ----
                if RemFocusWin == 1 then RemFocusWin = 0 else RemFocusWin = 1 end;
                reaper.SetExtState(section,"RemFocusWin",RemFocusWin,true);
                if RemFocusWin == 1 then;
                    reaper.SetExtState(section,"FOCUS_LOST_CLOSE",0,true);FOCUS_LOST_CLOSE=0;
                end;
                ----
            elseif showmenu == 13 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Text","R"..r.."G"..g.."B"..b,true);
                    R_Text,G_Text,B_Text = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 14 then;
                ----
                reaper.DeleteExtState(section,"Color_Text",true);
                R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                Start_GUI();
                ----
            elseif showmenu == 15 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Background","R"..r.."G"..g.."B"..b,true);
                    R_Back,G_Back,B_Back = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 16 then;
                ----
                reaper.DeleteExtState(section,"Color_Background",true);
                R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                Start_GUI();
                ----
            elseif showmenu == 17 then;
                ----
                local retval, color = reaper.GR_SelectColor();
                if retval > 0 then;
                    local r, g, b = reaper.ColorFromNative(color);
                    reaper.SetExtState(section,"Color_Gui","R"..r.."G"..g.."B"..b,true);
                    R_Gui,G_Gui,B_Gui = r, g, b;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 18 then;
                ----
                reaper.DeleteExtState(section,"Color_Gui",true);
                R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                Start_GUI();
                ----
            elseif showmenu == 19 then;
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
            elseif showmenu == 20 then;
                ----
                if TextBoldNorm == 98 then TextBoldNorm = 0 else TextBoldNorm = 98 end;
                reaper.SetExtState(section,"TextBoldNorm",TextBoldNorm,true);
                Start_GUI();
                ----
            elseif showmenu == 21 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("font size",1,"Size: -- < Default = 0 > ++ ",FontSize or 0);
                if retval and tonumber(retvals_csv) then;
                    reaper.SetExtState(section,"FontSize",retvals_csv,true);
                    FontSize = tonumber(retvals_csv);
                    Start_GUI();
                end;
                ----
            elseif showmenu == 22 then;
                ----

                ----
            elseif showmenu == 23 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("Button Brightness",1,"Value: -1 ... 0 ... 1 ",But_Bright or 0);
                retvals_csv = tonumber(retvals_csv);
                if retval and retvals_csv then;
                    retvals_csv = math.min(math.max(-1,retvals_csv),1);
                    reaper.SetExtState(section,"But_Bright",retvals_csv,true);
                    But_Bright = retvals_csv;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 24 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("But Transparency (alpha)",1,"Value:  0 ... 1 ",But_Transp or 1);
                retvals_csv = tonumber(retvals_csv);
                if retval and retvals_csv then;
                    retvals_csv = math.min(math.max(0,retvals_csv),1);
                    reaper.SetExtState(section,"But_Transp",retvals_csv,true);
                    But_Transp = retvals_csv;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 25 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("Frame Transparency (alpha)",1,"Value:  0 ... 1 ",Frame_Transp or 1);
                retvals_csv = tonumber(retvals_csv);
                if retval and retvals_csv then;
                    retvals_csv = math.min(math.max(0,retvals_csv),1);
                    reaper.SetExtState(section,"Frame_Transp",retvals_csv,true);
                    Frame_Transp = retvals_csv;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 26 then;
                ----
                local retval, retvals_csv = reaper.GetUserInputs("Frame Thickness",1,"Value:  0 ... ? ",Frame_Thickness or 1);
                retvals_csv = tonumber(retvals_csv);
                if retval and retvals_csv then;
                    retvals_csv = math.min(math.max(0,retvals_csv),100);
                    reaper.SetExtState(section,"Frame_Thickness",retvals_csv,true);
                    Frame_Thickness = retvals_csv;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 27 then;
                ----
                if BACKLIGHT_BTN == 1 then BACKLIGHT_BTN = 0 else BACKLIGHT_BTN = 1 end;
                reaper.SetExtState(section,"BACKLIGHT_BTN",BACKLIGHT_BTN,true);
                ----
            elseif showmenu == 28 then;
                ----
                local MB = reaper.MB("Eng:\nSet default brightness and transparency of buttons ?\n\nRus:\nУстановить яркость и прозрачность кнопок по умолчанию ?","Default Button",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"But_Bright",true);
                    reaper.DeleteExtState(section,"But_Transp",true);
                    reaper.DeleteExtState(section,"Frame_Transp",true);
                    reaper.DeleteExtState(section,"Frame_Thickness",true);
                    reaper.DeleteExtState(section,"BACKLIGHT_BTN",true);
                    But_Transp,But_Bright,Frame_Transp,Frame_Thickness,BACKLIGHT_BTN = 1,0,1,2,1;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 29 then;
                ----
                local MB = reaper.MB("Eng:\nSet all colors to default ?\n\nRus:\nУстановить все цвета по умолчанию ?","Default Color",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"But_Bright",true);
                    reaper.DeleteExtState(section,"But_Transp",true);
                    reaper.DeleteExtState(section,"Frame_Transp",true);
                    But_Transp,But_Bright,Frame_Transp = 1,0,1;
                    reaper.DeleteExtState(section,"Color_Text",true);
                    R_Text,G_Text,B_Text = R_Text_Default,G_Text_Default,B_Text_Default;
                    reaper.DeleteExtState(section,"Color_Background",true);
                    R_Back,G_Back,B_Back = R_Back_Default,G_Back_Default,B_Back_Default;
                    reaper.DeleteExtState(section,"Color_Gui",true);
                    R_Gui,G_Gui,B_Gui = R_Gui__Default,G_Gui__Default,B_Gui__Default;
                    Start_GUI();
                end;
                ----
            elseif showmenu == 30 then;
                ----
                local MB = reaper.MB("Eng:\nDo you really want to delete all saved settings ?\n\nRus:\nВы действительно хотите удалить все сохраненные настройки ?","Default Script",1);
                if MB == 1 then;
                    reaper.DeleteExtState(section,"But_Bright",true);
                    reaper.DeleteExtState(section,"But_Transp",true);
                    reaper.DeleteExtState(section,"Frame_Transp",true);
                    reaper.DeleteExtState(section,"Frame_Thickness",true);
                    reaper.DeleteExtState(section,"BACKLIGHT_BTN",true);

                    reaper.DeleteExtState(section,"TOOL_TIP",true);
                    reaper.DeleteExtState(section,"TOOLTIP_GRDNT",true);
                    reaper.DeleteExtState(section,"COL_PREV_GRAD",true);

                    reaper.DeleteExtState(section,"CLICK_GRD_CLOSE_WIN",true);
                    reaper.DeleteExtState(section,"CLICK_BUT_CLOSE_WIN",true);

                    reaper.DeleteExtState(section,"FOCUS_LOST_CLOSE",true);
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
            elseif showmenu == 31 then;
                ----
                local path = "https://money.yandex.ru/to/410018003906628/1000";
                OpenWebSite(path);
                reaper.ClearConsole();
                reaper.ShowConsoleMsg("Yandex-money - "..path.."\n\nWebManey - R159026189824");
                ----
            elseif showmenu == 32 then;
                ----
                local path = "https://forum.cockos.com/showthread.php?t=212819";
                OpenWebSite(path);
                ----
            elseif showmenu == 33 then;
                ----
                local path = "https://rmmedia.ru/threads/134701/";
                OpenWebSite(path);
                ----
            elseif showmenu == 34 then;
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