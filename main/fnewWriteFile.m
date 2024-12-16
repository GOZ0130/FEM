function fnewWriteFile(a,r,theta,tx,ty,E,v,T)
    % E in Pa, T in N
    % assump side area = 100 mm^2, result in MPa 
    fd = @(p) milling(p, a, r, theta, tx, ty);
    fh = @uniform;
    
    [p,t] = distmesh_2d( fd, fh, 3, [-50,-50;50,50], 500 , [-50,-50;-50,50;50,-50;50,50] );
    
    % 題目給的參數跟我們要設定的參數
    b_plane_strain = 1;
    mate = zeros(3,1);
    mate(1) = b_plane_strain;
    mate(2) = E;
    mate(3) = v;
    
    ndime = size(p,2); % column numbers of p
    nnode = size(p,1); % row numbers of p
    nelem = size(t,1); % row numbers of t
    nelnd = 3; % numbers of nodes in each element
    
    coor = p'; % 網格節點座標資訊
    conn = t'; % 網格元素連接資訊
    
    npres = 0; 
    pres = 0; % 位移邊界條件
    
    nload = 0;
    load = 0; % 力邊界條件
    
    % 找出受到traction的元素 面 水平和垂直traction
    trac_node_neg50 = find(p(:, 1) == -50);
    trac_elem = [];
    trac_face = [];
    trac_h = [];
    trac_v = [];
    for i = 1:size(t, 1) % numbers of element
        [Lia, Locb] = ismember(t(i, :), trac_node_neg50); % 看t(i)中那些元素是在-50的位置
        if sum(Lia) == 2 % 如果某個element有兩個nodes在-50上
            trac_elem = [trac_elem; i]; % 將i新增至trac_elem裡面
            elem_edge_nodei = find(Locb ~= 0); % 找出不等於0的項目
            if(elem_edge_nodei(1) == 1)
                if(elem_edge_nodei(2) == 2)
                    trac_face = [trac_face; 1];
                else
                    trac_face = [trac_face; 3];
                end
            else
                trac_face = [trac_face; 2];
            end
            trac_h = [trac_h; T/100];
            trac_v = [trac_v; 0];
        end
    end
    
    trac_node_50 = find(p(:, 1) == 50);
    for i = 1:size(t, 1)
        [Lia, Locb] = ismember(t(i, :), trac_node_50);
        if sum(Lia) == 2
            trac_elem = [trac_elem; i];
            elem_edge_nodei = find(Locb ~= 0);
            if(elem_edge_nodei(1) == 1)
                if(elem_edge_nodei(2) == 2)
                    trac_face = [trac_face; 1];
                else
                    trac_face = [trac_face; 3];
                end
            else
                trac_face = [trac_face; 2];
            end
            trac_h = [trac_h; -T/100];
            trac_v = [trac_v; 0];
        end
    end
    ntrac = size(trac_elem,1);
    trac = zeros(ntrac,2+ndime); % 哪個element的哪個邊受到traction，大小為何
    
    for i = 1:ntrac
        trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];
    end
    
%     filename = 'parameters.h5';
%     if exist(filename, 'file') == 2
%         delete(filename);
%     end
%     
%     h5create(filename, '/coor', size(coor));
%     h5write(filename, '/coor', coor);
%     
%     h5create(filename, '/conn', size(conn));
%     h5write(filename, '/conn', conn);
%     
%     h5create(filename, '/ndime', size(ndime));
%     h5write(filename, '/ndime', ndime);
%     
%     h5create(filename, '/mate', size(mate));
%     h5write(filename, '/mate', mate);
%     
%     h5create(filename, '/nnode', size(nnode));
%     h5write(filename, '/nnode', nnode);
%     
%     h5create(filename, '/nelem', size(nelem));
%     h5write(filename, '/nelem', nelem);
%     
%     h5create(filename, '/nelnd', size(nelnd));
%     h5write(filename, '/nelnd', nelnd);
%     
%     h5create(filename, '/npres', size(npres));
%     h5write(filename, '/npres', npres);
%     
%     h5create(filename, '/pres', size(pres));
%     h5write(filename, '/pres', pres);
%     
%     h5create(filename, '/nload', size(nload));
%     h5write(filename, '/nload', nload);
%     
%     h5create(filename, '/load', size(load));
%     h5write(filename, '/load', load);
%     
%     h5create(filename, '/ntrac', size(ntrac));
%     h5write(filename, '/ntrac', ntrac);
%     
%     h5create(filename, '/trac', size(trac));
%     h5write(filename, '/trac', trac);
    
    function D = milling(p, a, r, theta, tx, ty)
        % 對點 p 進行旋轉變換
    %     p_rot = protate(p, theta);
    %     p_rot_shift = pshift(p_rot, x1, y1);
        
        p_shift = pshift(p, -tx, -ty);
        p_shift_rot = protate(p_shift, theta);
        
        % d1 使用未旋轉的點 p 計算，保持邊界不旋轉
        d1 = drectangle(p, -50, 50, -50, 50);
        % d2, d3, d4 使用旋轉後的點 p_rot 計算
        d2 = dcircle(p_shift_rot, a, 0, r);
        d3 = dcircle(p_shift_rot, -a, 0, r);
        d4 = drectangle(p_shift_rot, -a, a, -r, r);
        d5 = min(d2,min(d3,d4));
    
        % 組合距離函數
        D = ddiff(d1, d5);
    end
    
    function h = uniform(p)
        h = ones(size(p,1),1);
    end

    f2newMainFile(a,r,theta,tx,ty,E,v,T,coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac);

end