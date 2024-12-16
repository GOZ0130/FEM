function fnewMainFile(a,r,theta,tx,ty,E,v,T,coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac)    
    
%     [coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('parameters.h5');
    
    [uglob, stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);
    
    stress_val = zeros(1,nelem);
    for i = 1:nelem
        stress_val(i) = sqrt(sum(stress_glob{i}(:).^2));  
    end
    
    [stress1st, max_index] = max(stress_val);
    stress_val_prime = stress_val;
    stress_val_prime(max_index) = 0;
    [stress2nd, second_max_index] = max(stress_val_prime);
    
    
    max_loc = zeros(ndime,nelnd);
    second_max_loc = zeros(ndime,nelnd);
    
    for i = 1:nelnd %1:3
        for j = 1:ndime %1:2
            max_loc(j, i) = coor(j,conn(i,max_index));
            second_max_loc(j, i) = coor(j,conn(i,second_max_index));
        end
    end
    
    mean_max_loc = mean(max_loc,2);
    x1st = mean_max_loc(1,1);
    y1st = mean_max_loc(2,1);
    mean_second_loc = mean(second_max_loc,2);
    x2nd = mean_second_loc(1,1);
    y2nd = mean_second_loc(2,1);
    
%     plot_stress(coor, conn, stress_val, max_index, second_max_index);

    fileID = fopen('test.csv', 'a');
    if ftell(fileID) == 0  % 檢查文件是否為空
        fprintf(fileID, 'a,r,theta,tx,ty,E,v,T,stress1st,x1st,y1st,stress2nd,x2nd,y2nd,\n');  % 寫入表頭
    end

   
    fprintf(fileID, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n', a,r,theta,tx,ty,E,v,T,stress1st,x1st,y1st,stress2nd,x2nd,y2nd);
    
    % 關閉文件
    fclose(fileID);

end