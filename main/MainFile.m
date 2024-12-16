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
fprintf('Max stress is %.3f Pa.\n',max_stress);
fprintf('Second Max stress is %.3f Pa.\n',second_max_stress);

max_loc = zeros(ndime,nelnd);
second_max_loc = zeros(ndime,nelnd);

for a = 1:nelnd %1:3
    for b = 1:ndime %1:2
        max_loc(b, a) = coor(b,conn(a,max_index));
        second_max_loc(b, a) = coor(b,conn(a,second_max_index));
    end
end

mean_max_loc = mean(max_loc,2);
mean_second_loc = mean(second_max_loc,2);

plot_stress(coor, conn, stress_val, max_index, second_max_index);