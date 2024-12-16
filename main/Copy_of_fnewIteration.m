clc;
clear;
addpath('../distmesh/')
addpath('../FEM_function/')
cnt = 1;
T_arr = [70, 200];
v_arr = [0.35, 0.4];
E_arr = [60e9, 43e9];
for i = 1:length(T_arr) % 7
    T = T_arr(i);
    for j = 1:length(v_arr)
        v = v_arr(j);
        for k = 1:length(E_arr)
            E = E_arr(k);
            for a = 0:2:4 % 0 4
                for r = 4:2:8-a 
                    for theta = 0:pi/2:pi % 7
                        for tx = 0:4:12-a-r
                            for ty = 0:4:12-a-r
        
                                fnewWriteFile(a,r,theta,tx,ty,E,v,T)
                                disp(cnt);
                                cnt = cnt +1;
                            end
                        end
                    end
                end
            end
        end
    end
end