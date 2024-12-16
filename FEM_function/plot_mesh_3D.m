% Input:
% coor, 2 by nnd
% conn, 3 by nel for a mesh of triangular elements or
% 4 by nel for a mesh of quadrilateral elements
% Test:
% 1. Commands:
% >> coor = [0 1 1 0; 0 0 1 1]; conn= [1 2; 2 3; 4 4];
% >> plot_mesh(coor,conn);
% 2. Commands:
% >> coor = [0 1 2 2 1 0; 0 0 0 1 1 1]; conn= [1 2; 2 3; 5 4; 6 5];
% >> plot_mesh(coor,conn);

%corr[x1, x2, ... , xn; y1, y2, ... ,yn];
%conn[shape1, shape2, ...; shape1, shape2, ...; shape1, shape2, ...];

function plot_mesh_3D(coor,conn)
    figure;
    nel = size(conn,2);
    scatter3(coor(1,:),coor(2,:),coor(3,:),'MarkerFaceColor','r');
    hold on;
    if(size(conn,1) == 8)
        x = zeros(8,3);
        lb8 = [1 2 3 4 5 6 7 8];
        for iel = 1:nel
            for i = 1:8
                for j = 1:3
                    x(i,j) = coor(j,conn(i,iel));
                end
            end
            patch('Vertices',x,'Faces',lb8,'FaceColor','none','EdgeColor','b');
        end
    end
    % if(size(conn,1) == 4)
    %     x = zeros(4,2);
    %     iq4 = [1 2 3 4];
    %     for iel = 1:nel
    %         for i = 1:4
    %             for j = 1:2
    %                 x(i,j) = coor(j,conn(i,iel));
    %             end
    %         end
    %         patch('Vertices',x,'Faces',iq4,'FaceColor','none','EdgeColor','b');
    %     end
    % end
    axis equal;
    box on;
    grid on;
    hold off;
end


