clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('parameters.h5');

[uglob, stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

stress_val = zeros(1,nelem);
for i = 1:nelem
    stress_val(i) = sqrt(sum(stress_glob{i}(:).^2));  
end

[max_stress, max_index] = max(stress_val);
    stress_val_prime = stress_val;
    stress_val_prime(max_index) = 0;
    [second_max_stress, second_max_index] = max(stress_val_prime);
    
    
    max_loc = zeros(ndime,nelnd);
    second_max_loc = zeros(ndime,nelnd);
    
    for i = 1:nelnd %1:3
        for j = 1:ndime %1:2
            max_loc(j, i) = coor(j,conn(i,max_index));
            second_max_loc(j, i) = coor(j,conn(i,second_max_index));
        end
    end
    
    mean_max_loc = mean(max_loc,2);
    mean_second_loc = mean(second_max_loc,2);
    if mean_max_loc(1,1) <= mean_second_loc(1,1)
        stress1st = max_stress;
        x1st = mean_max_loc(1,1);
        y1st = mean_max_loc(2,1);
        stress2nd = second_max_stress;
        x2nd = mean_second_loc(1,1);
        y2nd = mean_second_loc(2,1);
    else
        stress2nd = max_stress;
        x2nd = mean_max_loc(1,1);
        y2nd = mean_max_loc(2,1);
        stress1st = second_max_stress;
        x1st = mean_second_loc(1,1);
        y1st = mean_second_loc(2,1);
    end

fprintf('Stress1st: %.2f, X1st: %.2f, Y1st: %.2f\n', stress1st, x1st, y1st);
fprintf('Stress2nd: %.2f, X2nd: %.2f, Y2nd: %.2f\n', stress2nd, x2nd, y2nd);

plot_stress(coor, conn, stress_val, max_index, second_max_index);