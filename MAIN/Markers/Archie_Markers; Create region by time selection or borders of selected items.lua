--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Markers 
   * Description: Markers; Create region by time selection or borders of selected items.lua 
   * Author:      Archie 
   * Version:     1.02 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound(Rmm) 
   * Gave idea:   Maestro Sound(Rmm) 
   * Extension:   Reaper 6.10+ http://www.reaper.fm/ 
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.0 [310520] 
   *                  + initialе 
--]]  
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    local Name = "Enter name inside script" 
            --   введите Имя региона 
            --   Например:  Name = "Region Name" 
            ---------------------------- 
     
                                   
    local R, G, B = "random","random","random"; 
                          -- R, G, B = Задайте цвет создаваемого региона R, G, B  
                          -- например:local R, G, B = 162, 171, 171 
                          -- для рандомного выбора цвета задайте значения 
                          -- local R, G, B = "random","random","random" 
                          -- иначе задайте значения  
                          -- local R, G, B = nil, nil, nil 
                          -- http://csscolor.ru/rgb/162,171,171 
                          ------------------------------------- 
     
                      
    local Remove_Time_Selection = false -- true/false 
     
     
    local Unselect_Item = false  -- true/false   
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
     
    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); 
    local Count = reaper.CountSelectedMediaItems(0); 
    if Count == 0 and timeSelStart==timeSelEnd then no_undo()return end; 
     
     
    if timeSelStart==timeSelEnd then; 
        local POS,END = math.huge,0; 
        for i = 1,Count do; 
            local item = reaper.GetSelectedMediaItem(0,i-1); 
            local pos_it = reaper.GetMediaItemInfo_Value(item,"D_POSITION"); 
            local end_it = pos_it + reaper.GetMediaItemInfo_Value(item,"D_LENGTH"); 
            if pos_it < POS then POS = pos_it end; 
            if end_it > END then END = end_it end; 
        end; 
        timeSelStart,timeSelEnd = POS,END; 
    end; 
     
     
    reaper.Undo_BeginBlock(); 
    reaper.PreventUIRefresh(1); 
     
     
    if R == "random" and G == "random" and B == "random" then; 
        local mr = math.random R,G,B = mr(999),mr(999),mr(999); 
    end; 
     
    if R ~= nil and G ~= nil and B ~= nil then; 
        local RGB = reaper.ColorToNative(R,G,B); 
        reaper.PreventUIRefresh(158); 
        reaper.InsertTrackAtIndex(0,false); 
        local track = reaper.GetTrack(0,0); 
        reaper.SetTrackColor(track,RGB); 
        col = reaper.GetTrackColor(track); 
        reaper.DeleteTrack(track); 
        reaper.PreventUIRefresh(-158); 
    else; 
        col = 0; 
    end; 
     
    reaper.AddProjectMarker2(0,1,timeSelStart,timeSelEnd,Name,-1,col); 
     
    if Remove_Time_Selection==true then; 
        reaper.GetSet_LoopTimeRange(1,0,0,0,0); 
    end; 
     
    if Unselect_Item==true then; 
        reaper.SelectAllMediaItems(0,0); 
    end; 
     
    reaper.Undo_EndBlock('Create region by time selection or borders of selected items',-1); 
    reaper.PreventUIRefresh(-1); 
     
     
     
     
     
     
     
     