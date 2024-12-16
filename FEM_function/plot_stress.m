function plot_stress(coor, conn, Stress_val, max_index, second_max_index)
    figure;
    hold on;
    default_color = [0.3, 0.3, 0.3]; 
    max_stress_color = [1, 0, 0];  
    for i = 1:size(conn, 2)
        triangle_vertices = coor(:, conn(:, i));
        if i == max_index || i == second_max_index
            patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
                max_stress_color, 'EdgeColor', 'none');
        else
            patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
                default_color, 'EdgeColor', 'none');
        end
    end
    hold off;
    axis equal;
    xlabel('X-axis');
    ylabel('Y-axis');
    title('Maximum Stress Position');
    
    
    Stress_normalized = (Stress_val - min(Stress_val)) / (max(Stress_val) - min(Stress_val));

    figure;
    hold on;
    for i = 1:size(conn, 2)
        if Stress_normalized(1, i) <= 1/5
            channel_nom = (Stress_normalized(1, i) - 0) / (1/5);
            colorRGB = [0, channel_nom, 1];
        elseif Stress_normalized(1, i) <= 2/5
            channel_nom = (Stress_normalized(1, i) - 1/5) / (1/5);
            colorRGB = [0, 1, 1 - channel_nom];
        elseif Stress_normalized(1, i) <= 3/5
            channel_nom = (Stress_normalized(1, i) - 2/5) / (1/5);
            colorRGB = [channel_nom, 1, 0];
        else
            channel_nom = (Stress_normalized(1, i) - 3/5) / (2/5);
            colorRGB = [1, 1 - channel_nom, 0];
        end

        triangle_vertices = coor(:, conn(:, i));
        patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', colorRGB, 'EdgeColor', 'none');
    end
    hold off;
    axis equal;
    xlabel('X-axis');
    ylabel('Y-axis');
    title('Stress Distribution');
    
    caxis([0 1]);
    n_colors = 256;
    blue_to_cyan = [linspace(0, 0, n_colors/5)', linspace(0, 1, n_colors/5)', linspace(1, 1, n_colors/5)'];
    cyan_to_green = [linspace(0, 0, n_colors/5)', linspace(1, 1, n_colors/5)', linspace(1, 0, n_colors/5)'];
    green_to_yellow = [linspace(0, 1, n_colors/5)', linspace(1, 1, n_colors/5)', linspace(0, 0, n_colors/5)'];
    yellow_to_orange = [linspace(1, 1, n_colors/5)', linspace(1, 0.5, n_colors/5)', linspace(0, 0, n_colors/5)'];
    orange_to_red = [linspace(1, 1, n_colors/5)', linspace(0.5, 0, n_colors/5)', linspace(0, 0, n_colors/5)'];
    gradient_colors = [blue_to_cyan; cyan_to_green; green_to_yellow; yellow_to_orange; orange_to_red];
    colormap(gradient_colors);
    
    split_points = linspace(min(Stress_val), max(Stress_val), 6);
    Stress_label = num2str(split_points', '%.2f');

    C = colorbar('Ticks', linspace(0, 1, 6), 'TickLabels', strtrim(cellstr(Stress_label)));
    C.Label.String = 'Pa';
    C.Label.VerticalAlignment = 'bottom';
    C.Label.HorizontalAlignment = 'right';
    C.Label.Rotation = 0;
    C.Label.Position(2) = C.Label.Position(2) + 0.51;
    C.Label.Position(1) = C.Label.Position(1) - 1.5;
end