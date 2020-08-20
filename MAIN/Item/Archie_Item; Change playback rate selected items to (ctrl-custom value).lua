--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Change playback rate selected items to (ctrl-custom value)
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    HDVulcan(RMM)
   * Gave idea:   HDVulcan(RMM)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [07.11.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local TakeAll = false; -- false / true


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local title = "Change playback rate selected items to ";
    local section =({reaper.get_action_context()})[2]:match(".+[/\\](.+)");


    local Mouse_State = reaper.JS_Mouse_GetState(127);
    if Mouse_State&4 == 4 then;
        local ret = tonumber(reaper.GetExtState(section,"PLAY_RATE_IT_CUSTOM_VALUE"))or "";
        local retval, retvals_csv = reaper.GetUserInputs(title,1,"Enter Rate custom value",ret);
        retvals_csv = tonumber(retvals_csv);
        if not retval or not retvals_csv then no_undo() return end;
        reaper.SetExtState(section,"PLAY_RATE_IT_CUSTOM_VALUE",retvals_csv,true);
        no_undo() return;
    end;

    local RATE = tonumber(reaper.GetExtState(section,"PLAY_RATE_IT_CUSTOM_VALUE"));
    if not RATE then no_undo() return end;


    local CountItem = reaper.CountSelectedMediaItems(0);
    if CountItem == 0 then no_undo() return end;

    local RATE = tonumber(RATE)or 1;
    local RATE_N = (1-RATE);

    reaper.Undo_BeginBlock();

    for i = 1,CountItem do;

        local Item = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(Item,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(Item,"D_LENGTH");

        local Take = reaper.GetActiveTake(Item);
        local rate = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
        local Source = reaper.GetMediaItemTake_Source(Take);
        local SrcLen,_ = reaper.GetMediaSourceLength(Source);
        local preLen = (len*rate)/SrcLen;

        ----
        if TakeAll == true then;

            local CountTake = reaper.CountTakes(Item);
            for t = 1,CountTake do;
                local tk = reaper.GetMediaItemTake(Item,t-1);
                local rt = reaper.GetMediaItemTakeInfo_Value(tk,"D_PLAYRATE");
                reaper.SetMediaItemTakeInfo_Value(tk,"D_PLAYRATE",rt-RATE_N);
            end;
        else;
            reaper.SetMediaItemTakeInfo_Value(Take,"D_PLAYRATE",rate-RATE_N);
        end;
        ----
        local rate = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
        local newLen = (SrcLen / rate)*preLen
        reaper.SetMediaItemInfo_Value(Item,"D_LENGTH",newLen);
        reaper.UpdateItemInProject(Item);
    end;

    reaper.Undo_EndBlock(title..RATE,-1);
    reaper.UpdateArrange();