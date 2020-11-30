function output = parse_aniso(filename)
    file_as_string = fileread(filename);
    file_lines = regexp(file_as_string, '\r\n|\r|\n', 'split');
    num_file_lines = length(file_lines);
    
    poly_aniso = is_poly_aniso(file_lines, num_file_lines);
    
    % states -> column 1: moment(z); column 2: energies
    states = get_states(file_lines, num_file_lines);
    if poly_aniso
    %   states = [states; -states(:, 1) states(:, 2)];
    end
    output.states = states;
    
    % wave functions -> i forget
    if ~poly_aniso
        wave_functions = get_wave_functions(file_lines, num_file_lines); 
        output.wave_functions = wave_functions;
    end

    % matrix elements, only: +1 -> -1 ; +1 -> +2 ; +1 -> -2
    matrix_elements = get_matrix_elements(file_lines, num_file_lines);
    output.matrix_elements = matrix_elements;
end

function output = is_poly_aniso(file_lines, num_file_lines)
    for a = 1:num_file_lines
       if contains(file_lines{a}, '&POLY_ANISO')
           output = true;
           return
       end
    end
        output = false;
        return
end

function states = get_states(file_lines, num_file_lines)
    energies = []; 
    moments = [];
    
    for a = 1:num_file_lines
        if contains(file_lines{a}, 'spin-orbit state 1. energy(1)')
            new_string = strtrim(split(file_lines{a}, '='));
            new_string = split(new_string{2}, ' ');
            energies = [energies; str2double(new_string{1})];
        end
        if contains(file_lines{a}, '<1| mu_Z |1>')
            new_string = strtrim(split(file_lines{a}, '|'));
            moments = [moments; str2double(new_string{end-1})];
        end
    end
    
    states = [moments, energies];
end

function wave_functions = get_wave_functions(file_lines, num_file_lines)
    wave_functions = [];
    
    for a = 1:num_file_lines
        if contains(file_lines{a}, '/2> |')
            new_string = strtrim(split(file_lines{a}, '|'));
            if length(new_string) == 7
                new_string = split(new_string{4}, ' ');
                new_double = str2double(new_string{1});
                wave_functions = [wave_functions; new_double];
            end
        end
    end
    
    wave_functions = reshape(wave_functions, 16, 8);
end

function matrix_elements = get_matrix_elements(file_lines, num_file_lines)
    matrix_elements = [];
    num_entries = 0;
    
    for a = 1:num_file_lines
        if contains(file_lines{a}, ' | < ')
            new_string = strtrim(split(file_lines{a}, '|'));
            new_string = new_string(~cellfun('isempty', new_string));
            if length(new_string) == 6
                num_entries = num_entries + 1;
                matrix_elements = [matrix_elements; str2double(new_string{end})];
            end
        end
    end
    
    num_states = 0.5 * (sqrt(8 * num_entries / 2 + 1) - 1);
    qtm_elements = matrix_elements(2:2:(num_states * 2));
    same_side_elements = matrix_elements(num_states * 2 + (1:2:(num_states * 2 - 2)));
    diagonal_elements = matrix_elements(num_states * 2 + (2:2:(num_states * 2 - 2)));
    matrix_elements = [qtm_elements, [same_side_elements; NaN], [diagonal_elements; NaN]];
end