function plot_singleaniso(filename)
    singleaniso_data = parse_singleaniso(filename);
    makeFigure();
    printLabels(singleaniso_data{1}, singleaniso_data{3});
    plotTransitions(singleaniso_data{1}, singleaniso_data{2});
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
    xlim([-14 14]);
    ylim([-30 410]);
    setpixelposition(fig, [10 10 550 550]);
end

function printLabels(states, wavefunctions)
    text(states(:, 1) + 3.0, states(:, 2), compose('$\\mathbf{%.1f\\%%}$', max(wavefunctions) ./ sum(wavefunctions) .* 100), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 10.5, 'Clipping', 'on');
    wavefunction_labels = compose('$\\mathbf{\\pm|\\frac{%d}{2}\\rangle}$', abs(-15:2:15));
    [~, wavefunction_indices] = max(wavefunctions);
    text(-states(:, 1) - 2.9, states(:, 2), wavefunction_labels(wavefunction_indices), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'Fontsize', 13.5, 'Clipping', 'on');
end

function plotTransitions(states, transitions)
    line_style = '-.';
    line_width = 1;

    cmap = jet(500);
    log_transitions = log10(transitions);
    log_transitions(8, 2) = 1;
    log_transitions(8, 3) = -4;
    normlalized_transitions = round(rescale(log_transitions, 1, 500));

    h = line([-states(:, 1)'; states(:, 1)'], [states(:, 2)'; states(:, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normlalized_transitions(:, 1), :), 2));
    
    h = line([-states(1:end-1, 1)'; states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normlalized_transitions(1:end-1, 3), :), 2));
    h = line([states(1:end-1, 1)'; -states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normlalized_transitions(1:end-1, 3), :), 2));

    h = line([-states(1:end-1, 1)'; -states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normlalized_transitions(1:end-1, 2), :), 2));
    h = line([states(1:end-1, 1)'; states(2:end, 1)'], [states(1:end-1, 2)'; states(2:end, 2)'], 'LineStyle', line_style, 'LineWidth', line_width);
    set(h, {'Color'}, num2cell(cmap(normlalized_transitions(1:end-1, 2), :), 2));

    colormap('jet');
    colorbar('southoutside', 'XTick', 0:0.2:1, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '1', '10'});
end

function plotStates(states, padding)
    if padding
        line([states(:,1)' - 0.6; states(:,1)' + 0.6], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
        line(-[states(:,1)' - 0.6; states(:,1)' + 0.6], [states(:,2)'; states(:,2)'], 'Color', 'white', 'LineWidth', 5);
    end

    line([states(:,1)' - 0.4; states(:,1)' + 0.4], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
    line(-[states(:,1)' - 0.4; states(:,1)' + 0.4], [states(:,2)'; states(:,2)'], 'Color', 'black', 'LineWidth', 2);
end