function flipped = flip_signal(signal)
% FLIP_SIGNAL performs a coordinate transformation, translation + rotation
%
% Takes a signal structure and translates the original coordinate system
% along the time-axis by period superposed by a 180° rotation.
%
% FLIPPED = FLIP_SIGNAL(SIGNAL)
%
% FLIPPED is of the same type as SIGNAL.

flipped = signal;
switch lower(signal.type)
    case 'fhandle'
        flipped.fcn = @(t) -signal.fcn(signal.period - t);
    case 'linear'
        flipped.val = -flip(signal.val);
        flipped.time = signal.time(end) - flip(signal.time);
    case 'step'
        flipped.val = -flip(signal.val);
        flipped.time = [cumsum(flip(diff(signal.time))); signal.time(end)];
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

end
