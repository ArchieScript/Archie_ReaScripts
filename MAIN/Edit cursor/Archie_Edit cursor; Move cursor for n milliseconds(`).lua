--[[
   * Category:    Edit cursor
   * Description: Move cursor for n milliseconds
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Move cursor for n milliseconds
   * О скрипте:   Переместить курсор на n миллисекунд
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    HDVulcan[RMM]
   * Gave idea:   HDVulcan[RMM]
   * Provides:
   *              [nomain] .
   *              [main] . > Archie_Edit cursor; Move cursor left for 100 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 200 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 300 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 400 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 500 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 600 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 700 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 800 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 900 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor left for 1000 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 100 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 200 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 300 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 400 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 500 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 600 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 700 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 800 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 900 milliseconds(`).lua
   *              [main] . > Archie_Edit cursor; Move cursor right for 1000 milliseconds(`).lua
   * Changelog:
   *              +  initialе / v.1.0 [01042019]


   -- Тест только на windows  /  Test only on windows.
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               ||
      -------------------------------------------------------------------------------------||
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    ||
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               ||
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             ||
   (-) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc ||
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr ||
                                                                    http://clck.ru/Eo5Lw   ||
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                ||
      -------------------------------------------------------------------------------------||
    ˄ - (+) - required for installation / (-) - not necessary for installation             ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


	

    local Move_Arrange = 1
                    -- = 0 Не перемещать вид за курсором редактирования
                    -- = 1 переместить вид за курсором редактирования
                         --------------------------------------------
                    -- = 0 Do not move the view behind the edit cursor
                    -- = 1 move the view behind the edit cursor
                    -------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------


    local ScrName = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");


    local left = tonumber(ScrName:match("left for (%d+)"));
    local right = tonumber(ScrName:match("right for (%d+)"));

    if left then;
        moveTo = left-left*2;
    elseif right then;
        moveTo = right;
    end;


    if type(moveTo) == "number" then;
        local cur = reaper.GetCursorPosition();
        reaper.SetEditCurPos(cur+(moveTo/1000),Move_Arrange,false);
    end;
    no_undo();
    reaper.UpdateArrange();