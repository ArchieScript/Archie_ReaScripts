--[[ 
   * Category:    Grid 
   * Description: swing grid disable and reset(arrange) 
   * Oписание:    отключить и сбросить сетку качания(аранжировка) 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Author:      Archie 
   * Version:     1.0 
   * customer:    Maestro Sound(RMM Forum) 
   * gave idea:   Maestro Sound(RMM Forum) 
--=================================================]] 
 
 
 
    --=========================================================================== 
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
    --=========================================================================== 
 
 
 
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
     
 
 
 
    local _,grid,swingOnOff,swing = reaper.GetSetProjectGrid( 0, 0 ) 
    if swingOnOff == 0 and swing == 0 then no_undo() return end 
    
    reaper.GetSetProjectGrid(0,1,grid,0,0) 
 
    reaper.Undo_BeginBlock() 
    reaper.Undo_EndBlock("0.0%  / Swing RESET and OFF",1) 
 
  
 
 
 
 
 
 