function verbose(trigger, level, message)
% VERBOSE displays an information message if verbosity level is reached
%
% VERBOSE(TRIGGER, LEVEL, MESSAGE) displays the message MESSAGE if TRIGGER
% is equal or higher LEVEL. It also adds a timestamp to the message and
% indents it depending on LEVEL.
%
% With this, a simple verbosity level system can be built. A global
% VERBOSITY variable can be defined. if it reaches the LEVEL of VERBOSE,
% then the MESSAGE is shown, else it is ommited.
%
% Examples:
%   verbose(2, 1, 'This will be displayed.')
%   verbose(2, 2, 'This will also be displayed and indented.')
%   verbose(1, 2, 'This will not be displayed'
%
% See also FPRINTF.

LINEWIDTH = 73;

if trigger < level
    return
end

% Add timestamp
message = [datestr(now(), 'HH:MM:SS.FFF'), ' - ', message];

% Wrap lines, max with is dependent on level
% Indent whole message with 4 spaces for each level higher 1
messagecell = linewrap(message, LINEWIDTH - (level-1)*4);
for ii = 1:length(messagecell)
    messagecell{ii} = [make_n_spaces((level-1)*4), messagecell{ii}];
end

% Indent two additional spaces for lines proceeding the first line
if length(messagecell) > 1
    for ii = 2:length(messagecell)
        messagecell{ii} = [make_n_spaces(2), messagecell{ii}];
    end
end

fprintf('%s\n', messagecell{:})

end


% LOCAL FUNCTIONS

function spaces = make_n_spaces(nn)
    spaces = '';
    if nn == 0
        return
    end
    for ii = 1:nn
        spaces = [spaces, ' ']; %#ok
    end

end
