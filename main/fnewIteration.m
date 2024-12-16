clc;
clear;
addpath('../distmesh_2/')
addpath('../FEM_function_2/')
cnt = 1;
T_arr = [250, 1100, 720];
v_arr = [0.1, 0.3, 0.4];
E_arr = [60e8, 100e9, 43e9];
for i = 1:length(T_arr) % 7
    T = T_arr(i);
    for j = 1:length(v_arr)
        v = v_arr(j);
        for k = 1:length(E_arr)
            E = E_arr(k);
            for a = 0:4:16 % 0 4 8 12 16
                for r = 4:4:20-a 
                    for theta = 0:pi/6:pi % 7
                        for tx = 0:4:24-a-r
                            for ty = 0:4:24-a-r
        
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

T = 250;
v = 0.3;
E = 100e9;
r = 0;

for a = 0:4:12 % 0 4
    for theta = 0:pi/6:pi % 7
        for tx = 0:4:12-a-r
            for ty = 0:4:12-a-r

                fnewWriteFile(a,r,theta,tx,ty,E,v,T)
                disp(cnt);
                cnt = cnt +1;
            end
        end
    end
end
            