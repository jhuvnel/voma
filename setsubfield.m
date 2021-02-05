function s = setsubfield(s, fields, val)

if ischar(fields)
    fields = regexp(fields, '\.', 'split'); % split into cell array of sub-fields
end

if length(fields) == 1
    s.(fields{1}) = val;
else
    try
        subfield = s.(fields{1}); % see if subfield already exists
    catch
        subfield = struct(); % if not, create it
    end
    s.(fields{1}) = setsubfield(subfield, fields(2:end), val);
end