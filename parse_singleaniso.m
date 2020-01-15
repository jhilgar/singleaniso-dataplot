function output = parse_singleaniso(filename)
    energies = [];
    moments = [];
    states = [];
    wave_functions = [];
    matrix_elements = [];

    fileID = fopen(filename);
    tline = fgetl(fileID);
    while ischar(tline)
        % energy vs. moment_z
        if contains(tline, 'spin-orbit state 1. energy(1)')
            newStr = strtrim(split(tline, '='));
            newStr = split(newStr{2}, ' ');
            energies = [energies; str2double(newStr{1})];
        end
        if contains(tline, '<1| mu_Z |1>')
            newStr = strtrim(split(tline, '|'));
            moments = [moments; str2double(newStr{end-1})];
        end

        % wavefunction contributions, absolute value of coefficients
        if contains(tline, '/2> |')
            newStr = strtrim(split(tline, '|'));
            if length(newStr) == 9
                newStr = split({newStr{3}; newStr{5}; newStr{7}}, {'  ', ' '});
                newDbl = str2double({newStr{1,:}, newStr{2,:}, newStr{3,:}});
                wave_functions = [wave_functions; abs(newDbl(1:2:5) + newDbl(2:2:6).*1i)];
            end
        end

        % matrix elements
        if contains(tline, ' | < ')
            newStr = strtrim(split(tline, '|'));
            newStr = newStr(~cellfun('isempty', newStr));
            if length(newStr) == 6
                matrix_elements = [matrix_elements; str2double(newStr{end})];
            end
        end

        tline = fgetl(fileID);
    end
    fclose(fileID);

    % reorganize state information
    states = [moments, energies];
    % reorganize and extract wavefunction contributions, doublets truncated
    wave_functions = arrayfun(@(x) wave_functions((x-1)*16+(1:16),:), (1:5), 'UniformOutput', false);
    wave_functions = [wave_functions{:}];
    wave_functions = wave_functions(:, 1:2:15);
    % reorganize and extract matrix elements, only: +1 -> -1 ; +1 -> +2 ; +1 -> -2
    matrix_elements = [matrix_elements(1:8), [matrix_elements(9:2:21); 0], [matrix_elements(10:2:22); 0]];

    output = {states, matrix_elements, wave_functions};
end