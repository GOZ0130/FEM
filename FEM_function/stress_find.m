function [uglob, Stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload, load)
    [kglob, Cglob, Bglob] = GlobStif(ndime,nnode,nelem,nelnd,mate,coor,conn);
    rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac);
    for i = 1:nload
        rglob(2*load(i, 1)) = load(i, 3);
    end
    diagIndices = 1:min(size(kglob));  
    for i = diagIndices
        if kglob(i, i) == 0
            kglob(i, i) = 1e-9;
        end
    end
    kpres= kglob;
    rpres= rglob;
    for i = 1:npres
        idof = ndime*(pres(i,1)-1)+pres(i,2);
        for ir = 1:ndime*nnode
            kpres(ir,idof) = 0;
            rpres(ir) = rpres(ir) - kglob(ir,idof)*pres(i,3);
        end
    end
    for i = 1:npres
        idof = ndime*(pres(i,1)-1)+pres(i,2);
        kpres(idof,:) = 0;
        kpres(idof,idof) = 1;
        rpres(idof) = pres(i,3);
    end
    uglob = kpres\rpres;
    uel = zeros(6,1);
    for j = 1:nelem
        Cel = Cglob{j};
        Bel = Bglob{j};
        Bel_3_6 = zeros(3, 6);
        Bel_3_6(1,1) = Bel(1,1); 
        Bel_3_6(1,3) = Bel(2,1); 
        Bel_3_6(1,5) = Bel(3,1);
        Bel_3_6(2,2) = Bel(1,2); 
        Bel_3_6(2,4) = Bel(2,2); 
        Bel_3_6(2,6) = Bel(3,2);
        Bel_3_6(3,1) = Bel(1,2);
        Bel_3_6(3,2) = Bel(1,1);
        Bel_3_6(3,3) = Bel(2,2);
        Bel_3_6(3,4) = Bel(2,1);
        Bel_3_6(3,5) = Bel(3,2);
        Bel_3_6(3,6) = Bel(3,1);
        uel(1:2,1) = [uglob(2*conn(1,j)-1, 1),uglob(2*conn(1,j), 1)];
        uel(3:4,1) = [uglob(2*conn(2,j)-1, 1),uglob(2*conn(2,j), 1)];
        uel(5:6,1) = [uglob(2*conn(3,j)-1, 1),uglob(2*conn(3,j), 1)];
        strain = Bel_3_6 * uel;
        Stress_glob{j} = Cel * strain;
    end
end