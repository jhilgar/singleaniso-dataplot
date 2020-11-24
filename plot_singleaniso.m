function plot_singleaniso(singleaniso_data, varargin)
    
    %singleaniso_data = parse_singleaniso(filename);
    makeFigure();
    printLabels(singleaniso_data{1}, singleaniso_data{3});
    plotTransitions(singleaniso_data{1}, singleaniso_data{2}, varargin{:});
    plotStates(singleaniso_data{1}, false);
end

function makeFigure()
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
    %xlim([-14 14]);
    %ylim([-30 410]);
    setpixelposition(fig, [10 10 550 550]);
end

function printLabels(states, wavefunctions)
    text(-states(:, 1) - 5.0, states(:, 2), compose('$\\mathbf{%.1f\\%%}$', max(wavefunctions) ./ sum(wavefunctions) .* 100), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 10.5, 'Clipping', 'on');
    wavefunction_labels = compose('$\\mathbf{\\pm|\\frac{%d}{2}\\rangle}$', abs(-15:2:15));
    [~, wavefunction_indices] = max(wavefunctions);
    text(states(:, 1) + 5, states(:, 2), wavefunction_labels(wavefunction_indices), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 13.5, 'Clipping', 'on');
end

function plotTransitions(states, transitions, varargin)
    line_style = '-.';
    line_width = 1;

    cmap = jet(500);
    log_transitions = log10(transitions);
    upper_bound = ceil(max(log_transitions(:)));
    lower_bound = floor(min(log_transitions(:)));
    
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
        R = abs(states(close_energies, 1));  %or whatever radius you want
        x = R*cos(th);
        y = (ylim/xlim)*R*sin(th) + states(close_energies, 2);
        h = plot(x, y, 'LineWidth', 1.3);
        %set(h, {'Color'}, num2cell(cmap(normlalized_transitions(:, 1), :), 2));
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
    %colorbar('southoutside', 'XTick', 0:0.25:1, 'XTickLabel', {'10^{-15}', '10^{-12}', '10^{-9}', '10^{-6}', '10^{-3}'});
end

function plotStates(states, padding)
    state_width = 1.3; state_padding = 0.2;
    if padding
        line([states(:,1)' - state_width + state_padding; states(:,1)' + state_width + state_padding], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
        line(-[states(:,1)' - state_width + state_padding; states(:,1)' + state_width + state_padding], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
    end

    line([states(:,1)' - state_width; states(:,1)' + state_width], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
    line(-[states(:,1)' - state_width; states(:,1)' + state_width], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
end