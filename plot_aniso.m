function plot_aniso(data, varargin)
    make_figure();
    if isfield(data, 'wave_functions')
        print_labels(data.states, data.wave_functions);
    end
    plot_transitions(data.states, data.matrix_elements, varargin{:});
    plot_states(data.states, false);
end

function make_figure()
    fig = figure();
    box('on');
    ax = gca();
    set(gca, 'linewidth', 1.5);
    ax.FontSize = 10;
    ax.TickDir = 'in';
    axis('square');
    ylabel('Energy (cm^{-1})', 'FontSize', 11, 'FontWeight', 'bold');
    xlabel('Moment (\mu_B)', 'FontSize', 11, 'FontWeight', 'bold');
    hold('on');
    setpixelposition(fig, [10 10 550 550]);
end

function print_labels(states, wavefunctions)
    %text(-states(:, 1) + 5.0, states(:, 2), compose('$\\mathbf{%.1f\\%%}$', max(wavefunctions) ./ sum(wavefunctions) .* 100), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 10.5, 'Clipping', 'on');
    text(-states(:, 1) + 5.0, states(:, 2), compose('$\\mathsf{%.1f\\%%}$', (max(wavefunctions) + wavefunctions(abs([17 49 81 113 145 177 209 241]' - find(wavefunctions == max(wavefunctions))))') ./ sum(wavefunctions) .* 100), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 10.5, 'Clipping', 'on');
    wavefunction_labels = compose('$\\mathbf{\\pm|\\frac{%d}{2}\\rangle}$', abs(-15:2:15));
    [~, wavefunction_indices] = max(wavefunctions);
    text(states(:, 1) - 5, states(:, 2), wavefunction_labels(wavefunction_indices), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 13.5, 'Clipping', 'on');
end

function plot_transitions(states, transitions, varargin)
    line_style = '-.';
    line_width = 1;

    cmap = jet(500);
    log_transitions = log10(transitions);
    bound_spacing = 5;
    %upper_bound = ceil(max(log_transitions(:)));
    %lower_bound = floor(min(log_transitions(:)));
    %upper_bound = lower_bound + round((upper_bound - lower_bound) / bound_spacing) * bound_spacing;
    upper_bound = -3;
    lower_bound = -23;
    p = inputParser;
    p.addParameter('transition_limits', [lower_bound, upper_bound]);
    p.parse(varargin{:});
    log_transitions(end, 2) = p.Results.transition_limits(1);
    log_transitions(end, 3) = p.Results.transition_limits(2);
    
    normalized_transitions = round(rescale(log_transitions, 1, 500));
    disp(strcat('normalizing lower and upper transition bounds to [', num2str(log_transitions(end, 2)), ', ', num2str(log_transitions(end, 3)), ']'));
    h = line([-states(:, 1)'; states(:, 1)'], [states(:, 2)'; states(:, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normalized_transitions(:, 1), :), 2));

    close_energies = find(abs(states(:, 1)) < 0.8);
    if size(close_energies ~= 0)
        th = linspace(0, pi, 100);
        R = abs(states(close_energies, 1) + 1);  %or whatever radius you want
        x = R*cos(th);
        y = (ylim/xlim)*R*sin(th) + states(close_energies, 2);
        for n = [1:length(close_energies)]
            h = plot(x(n, :), y(n, :), 'LineWidth', 1.3, 'LineStyle', line_style);
            %set(h, {'Color'}, num2cell(cmap(normalized_transitions(:, 1), :), 2));
        end
    end

    h = line([-states(1:end-1, 1)'; states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normalized_transitions(1:end-1, 3), :), 2));
    h = line([states(1:end-1, 1)'; -states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normalized_transitions(1:end-1, 3), :), 2));

    h = line([-states(1:end-1, 1)'; -states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normalized_transitions(1:end-1, 2), :), 2));
    h = line([states(1:end-1, 1)'; states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normalized_transitions(1:end-1, 2), :), 2));

    colormap('jet');
    colorbar('southoutside');
    x_tick_labels = compose('10^{%d}', (lower_bound:(((upper_bound - lower_bound) / (bound_spacing-1))):upper_bound));
    cbar = colorbar('southoutside', 'XTick', 0:(1 / (bound_spacing - 1)):1, 'XTickLabel', x_tick_labels);
    cbar.Label.String = 'Transition Matrix Element'; cbar.Label.FontSize = 16; cbar.Label.FontWeight = 'bold';
    cbar.Box = 'on'; cbar.LineWidth = 1.5;
end

function plot_states(states, padding)
    state_width = 1.3; state_padding = 0.2;
    if padding
        line([states(:,1)' - state_width + state_padding; states(:,1)' + state_width + state_padding], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
        line(-[states(:,1)' - state_width + state_padding; states(:,1)' + state_width + state_padding], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
    end

    line([states(:,1)' - state_width; states(:,1)' + state_width], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
    line(-[states(:,1)' - state_width; states(:,1)' + state_width], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
end
