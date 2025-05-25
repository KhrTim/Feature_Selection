function dataStruct = loadStructFromJSON(filename)
% loadStructFromJSON Loads a MATLAB struct from a JSON file.
%   dataStruct = loadStructFromJSON(filename)
%
% Input:
%   - filename: path to the JSON file
%
% Output:
%   - dataStruct: the decoded MATLAB struct

    fid = fopen(filename, 'r');
    if fid == -1
        error('Failed to open file: %s', filename);
    end

    raw = fread(fid, inf, 'char');
    fclose(fid);

    jsonStr = char(raw');
    dataStruct = jsondecode(jsonStr);
end