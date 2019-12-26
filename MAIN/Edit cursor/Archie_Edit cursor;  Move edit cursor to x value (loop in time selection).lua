--[[
   * Category:    Edit cursor
   * Description: Move edit cursor to x value (loop in time selection)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переместить курсор редактирования на значение x (цикл выбора времени)
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2039533/acb4305b-dde0-4933-b5b7-6f3c1ee78e89/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Arthur McArthur(forum Reaper)
   * Gave idea:   Arthur McArthur(forum Reaper)
   * Changelog:   v.1.0 [26.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local VALUE = true
             -- = true  | показать окно ввода
             -- = иначе введите значение (= 1/4; =1/2; =1; = -1/4; =-1/2; =-1 и т.д.)
                  -------------------------------------------------------------------
             -- = true  | show the input box
             -- = else enter a value (= 1/4; =1/2; =1; = -1/4; =-1/2; =-1 etc)
             -----------------------------------------------------------------
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
    local function tonumb(s);
        local function x(s);
            return tonumber((load('return '..s)()));
        end;
        return tonumber((({pcall(x,s)})[2]));
    end;
    -------------------------------------------------------
    
    
    ---------------------------------------------
    if type(VALUE)=='boolean'then VALUE = '' end;
    VALUE = VALUE:gsub('^%++','');
    ------------------------------
    
    
    -------------------------------------------------------
    if not tonumb(VALUE)then;
        ::rest::;
        local _,ExtState = reaper.GetProjExtState(0,'Move edit cursor to x value(loop in time selection)','VALUE');
        if ExtState == '' then ExtState = 1 end;
        local retval, retvals_csv = reaper.GetUserInputs('Move edit cursor to x value (loop in time selection)',1,'Value ( - +  x)',ExtState);
        if not retval then no_undo() return end;
        local val = tonumb(retvals_csv);
        if not val then;
            local MB = reaper.MB('Invalid value!\nRepeat?\n\nНеверное значение!\nПовторить?','Error',1);
            if MB == 2 then no_undo() return end;
            goto rest;
        end;
        if val ~= 0 then;
            reaper.SetProjExtState(0,'Move edit cursor to x value(loop in time selection)','VALUE',retvals_csv);
        end;
        VALUE = val;
    else;
        VALUE = tonumb(VALUE);
    end;
    -------------------------------------------------------
    
    
    
    -------------------------------------------------------
    if VALUE == 0 then no_undo()return end;
    local CursorPosition = reaper.GetCursorPosition();
    local CursorPositionX = CursorPosition;
    local startLoop,endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    
    local beat = reaper.parse_timestr_pos(2,2);
    
    local moveLen = math.abs(beat*VALUE);
    
    if startLoop == endLoop then;
        startLoop = 0-math.huge;
        endLoop   =   math.huge;
    else;
        if (VALUE < 0 and CursorPosition < startLoop) or
           (VALUE > 0 and CursorPosition > endLoop  ) then;
           
           if VALUE < 0 then mv = CursorPosition-moveLen end;
           if VALUE > 0 then mv = CursorPosition+moveLen end;
           
           reaper.SetEditCurPos(mv,true,false);
           no_undo()return;
        end;
    end;
    -------------------------------------------------------
       
    
    -------------------------------------------------------
    local Move;
    
    if VALUE > 0 then;
    
        ::Res::
        if (CursorPosition + moveLen) > endLoop then;
            moveLen = moveLen - (endLoop-CursorPosition);
            CursorPosition = startLoop;
            goto Res;
        end;
        Move = CursorPosition + moveLen;
    else;
        
        ::Res2::
        if (CursorPosition - moveLen) < startLoop then;
            moveLen = moveLen - (CursorPosition-startLoop);
            CursorPosition = endLoop;
            goto Res2;
        end;
        Move = CursorPosition - moveLen;
    end;
    
    
    if Move < 0 then Move = CursorPositionX end;
    
    if Move == CursorPositionX then no_undo() return end;
    
    reaper.SetEditCurPos(Move,true,false);
    -------------------------------------------------------
    no_undo();