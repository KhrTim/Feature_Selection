function saveStructAsJSON(filename, dataStruct)
% saveStructAsJSON Saves a MATLAB struct to a JSON file.
%   saveStructAsJSON(filename, dataStruct)
%
% Inputs:
%   - filename: the output JSON file name (string)
%   - dataStruct: the MATLAB struct to save

    filename = strcat(filename, '.json');
    if ~isstruct(dataStruct)
        error('Input must be a struct.');
    end

    jsonStr = jsonencode(dataStruct);

    fid = fopen(filename, 'w');
    if fid == -1
        error('Failed to open file: %s', filename);
    end
    fwrite(fid, jsonStr, 'char');
    fclose(fid);
end