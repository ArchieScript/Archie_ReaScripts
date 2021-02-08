--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Archie_var; Volume change on tracks or items by 1 dB (mouse wheel).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Changelog:   
   *              v.1.0 [050221]
   *                  + initialе
--]]
  
  
    ------------
    local DB = 1
    ------------
  
  
  
  
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
  
  
    ----------------------------------------------------
    local _,_,_,_,_,_,val = reaper.get_action_context()
    if val <= 0 then
        DB = DB-DB*2
    end
    ----------------------------------------------------
  
   
    ----------------------------------------------------
    local screen_x,screen_y = reaper.GetMousePosition()
    local item, take = reaper.GetItemFromPoint(screen_x,screen_y,false)
    local track,info = reaper.GetTrackFromPoint(screen_x,screen_y)
  
    if item then
      
        local vol = reaper.GetMediaItemInfo_Value( item, 'D_VOL' )
        local vol = 20 * math.log(vol,10);
        reaper.SetMediaItemInfo_Value(item,"D_VOL",(10^((vol+DB)/20)))
      
    elseif info == 0 then
        if track then
      
            local vol = reaper.GetMediaTrackInfo_Value( track, 'D_VOL' )
            local vol = 20 * math.log(vol,10);
            reaper.SetMediaTrackInfo_Value(track,"D_VOL",(10^((vol+DB)/20)))
        end
    end
    reaper.UpdateArrange()
    ----------------------------------------------------
    no_undo()