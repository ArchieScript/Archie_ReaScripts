--[[
   * Category:    Envelope
   * Description: Select all automation items in selected envelope track,
                                         with selected  points preserve
   * Oписание:    выберите все элементы автоматизации в выбранной дорожке
                                    конверта, с сохранением выбранных точек
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

    local selT={}
    for i = 1,CountAutoItem do
        local CountPoint = reaper.CountEnvelopePointsEx(Envelope,i-1)
        for iPoint = 1,CountPoint do
            local _,_,_,_,_,sel = reaper.GetEnvelopePointEx(Envelope,i-1,iPoint-1)
            selT[iPoint] = sel
        end
        reaper.GetSetAutomationItemInfo( Envelope, i-1, 'D_UISEL', 1, 1 )
        for iPointT = 1,#selT do
            reaper.SetEnvelopePointEx(Envelope,i-1,iPointT-1,nil,nil,nil,nil,selT[iPointT],nil)
        end
    end

    local name_script = [[Select all automation items in selected envelope track,]]
                          ..[[with selected  points preserve]]
    reaper.Undo_EndBlock(name_script,1)
    reaper.UpdateArrange()




