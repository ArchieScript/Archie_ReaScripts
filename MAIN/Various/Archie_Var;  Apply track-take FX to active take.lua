--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Apply track-take FX to active take.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Примените track-take FX к активному take
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(Rmm)
   * Gave idea:   smrz1(Rmm)
   * Extension:   Reaper 6.09+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [090520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local CHAN = 0; -- 0 auto, 1 mono, 2 stereo,3 multichannel;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    
    local t1 = {};
    local t2 = {};
    local chanX,chan;
    
    for i = 1,CountSelItem do;
        
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local take = reaper.GetActiveTake(item);
        
        local chanMode = reaper.GetMediaItemTakeInfo_Value(take,'I_CHANMODE');
        if chanMode >= 2 and chanMode <= 4 then;
            chan = 1;
        else;
            local source = reaper.GetMediaItemTake_Source(take);
            source = reaper.GetMediaSourceParent(source) or source;
            chan = reaper.GetMediaSourceNumChannels(source);
        end;
        
        local midi = reaper.TakeIsMIDI(take);
        if midi and chan <= 1 then chan = 2 end;
        
        chanX = math.max(chanX or 0,chan);
        t1[#t1+1] = take;
    end;
    
    ----
    local ActId = 40209;
    if chanX <= 1 then ActId = 40361 end;--Apply track/take FX to items (mono output)
    if chanX == 2 then ActId = 40209 end;--Apply track/take FX to items
    if chanX >= 3 then ActId = 41993 end;--Apply track/take FX to items (multichannel output)
    --
    if CHAN == 1 then ActId = 40361 end;--mono
    if CHAN == 2 then ActId = 40209 end;--ster
    if CHAN == 3 then ActId = 41993 end;--multichannel
    ----
    
    ----
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    reaper.Main_OnCommand(ActId,0);--Apply
    
    for i = 1,reaper.CountSelectedMediaItems(0)do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local take = reaper.GetActiveTake(item);
        t2[#t2+1] = take;
    end;
    
    for i = 1,#t1 do;
        reaper.SetActiveTake(t1[i]);
    end;
    
    reaper.Main_OnCommand(40129,0);--Delete active take from items
    
    for i = 1,#t2 do;
        reaper.SetActiveTake(t2[i]);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Apply track-take FX to active take',-1);
    
    
    
    
    