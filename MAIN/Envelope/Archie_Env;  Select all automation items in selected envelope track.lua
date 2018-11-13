--[[
   * Category:    Envelope
   * Description: Select all automation items in selected envelope track                                          
   * Oписание:    выберите все элементы автоматизации в выбранной дорожке конверта                   
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---  
   * gave idea:   ---
--=============================================]]    
    
    
    
    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    ----------------------------------------------------------------------------- 
    
    
    
    local Envelope  = reaper.GetSelectedEnvelope( 0 )
    if not Envelope then no_undo()return end
    
    
    local CountAutoItem = reaper.CountAutomationItems(Envelope)
    if CountAutoItem == 0 then no_undo()return end
    
    
    reaper.Undo_BeginBlock()
    
    for i = 1,CountAutoItem do
        reaper.GetSetAutomationItemInfo( Envelope, i-1, 'D_UISEL', 1, 1 )      
    end
    
    local CountEnvPoint = reaper.CountEnvelopePoints( Envelope )
    for i = 1,CountEnvPoint do
        reaper.SetEnvelopePoint( Envelope, i-1, nil, nil, nil, nil, 0, false )
    end
    
    local name_script = [[Select all automation items in selected envelope track,]]
    reaper.Undo_EndBlock(name_script,1)
    reaper.UpdateArrange()
