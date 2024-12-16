function [uglob, displacement] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload, load)
    [kglob, Cglob, Bglob] = GlobStif(ndime,nnode,nelem,nelnd,mate,coor,conn);
    rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac);
    for i = 1:nload
        rglob(2*load(i, 1)) = load(i, 4);
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
    displacement = zeros(nnode,1);
    for i = 1:nnode
       displacement(i,1) = sqrt(uglob(2*i-1,1)^2 + uglob(2*i,1)^2);
    end
end