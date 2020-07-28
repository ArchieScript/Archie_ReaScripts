--[[
   * Category:    Edit cursor
   * Description: Move edit cursor to start of first selected item and next in time
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Move edit cursor to start of first selected item and next in time
   * О скрипте:   Переместить курсор редактирования в начало первого выбранного элемента и далее к следующему по времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   HDVulcan[RMM]
   * Changelog:
   *              +  initialе / v.1.0 [04042019]


   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]



	

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local second = 1 -- The interval between the first and second pressing(running the script)in seconds;
                     -- Интервал между первым и вторым нажатием(запуском скрипта) в секундах;

    local StartEnd = 0
                       -- 0 To the beginning of the item; 1 to the end of the item;
                       -- 0 В начало айтема; 1 в конец айтема;

    local  view = 0
                    -- 0 do not move the view; 1 move view;
                    --0 не перемещать вид; 1 переместить вид;
    ---------------------------------------------------------




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --------------------------------------------------------
    local function no_undo()reaper.defer(function() end)end;
    --------------------------------------------------------
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;


    local ExtState = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");


    local z_time    = tonumber(reaper.GetExtState(ExtState,"z_time"))or os.time()+50;
    local z_numb    = tonumber(reaper.GetExtState(ExtState,"z_numb"))or 1;
    local z_curs    = tonumber(reaper.GetExtState(ExtState,"z_curs"))or reaper.GetCursorPosition();
    local ProjState = tonumber(reaper.GetExtState(ExtState,"ProjSt"));


    if reaper.GetProjectStateChangeCount(0)~= ProjState then z_numb = 1 end;


    local curX = reaper.GetCursorPosition();
    if math.ceil(curX) ~= math.ceil(z_curs) then z_numb = 1 end;


    local time = os.time();
    if time > z_time + second then z_numb = 1 end;


    local curs,posY,posX,len

    if z_numb == 1 then;

        local x = 10^10;
        local i;
        while true do;
            i = (i or -1)+1;

            local SelItem = reaper.GetSelectedMediaItem(0,i);
            if not SelItem then break end;
            local pos = reaper.GetMediaItemInfo_Value(SelItem, "D_POSITION");
            len = reaper.GetMediaItemInfo_Value(SelItem, "D_LENGTH");
            curs = reaper.GetCursorPosition();

            if pos < x then;
                if StartEnd > 0 then;
                    posY = pos +len;
                else;
                    posY = pos;
                end;
                x = pos;
            end;
        end;
        reaper.SetEditCurPos(posY or curs,view,false);
    end;



    if z_numb > 1 or not posY then;

        local x,curs = 10^10;
        local i;
        while true do;
            i = (i or -1)+1;

            local SelItem = reaper.GetSelectedMediaItem(0,i);
            if not SelItem then break end;
            local pos = reaper.GetMediaItemInfo_Value(SelItem, "D_POSITION");
            len = reaper.GetMediaItemInfo_Value(SelItem, "D_LENGTH");
            curs = reaper.GetCursorPosition();

            if pos > curs+0.00000000001 then;
                posX = pos - curs;
                if posX < x then;
                    if StartEnd > 0 then;
                        posY = pos +len;
                    else;
                        posY = pos;
                    end;
                    x = posX;
                end;
            end;
        end;

        reaper.SetEditCurPos(posY or curs, view, false);
    end;


    reaper.SetExtState(ExtState,"z_time",time    ,false);
    reaper.SetExtState(ExtState,"z_numb",z_numb+1,false);
    reaper.SetExtState(ExtState,"z_curs",reaper.GetCursorPosition(),false);
    reaper.SetExtState(ExtState,"ProjSt",reaper.GetProjectStateChangeCount(0),false);
    no_undo();