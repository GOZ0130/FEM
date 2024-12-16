function M = numIntegPt(ndime,nelnd)
    if (ndime == 1)
        M = 2;
    elseif (ndime == 2)
        if (nelnd == 3)
            M = 1;
        end
        if (nelnd == 6)
            M = 4;
        end
        if (nelnd == 4)
            M = 4;
        end
        if (nelnd == 8)
            M = 9;
        end
    elseif (ndime == 3)
        if (nelnd == 4)
            M = 1 ;
        end
        if (nelnd == 10)
            M = 4;
        end
        if (nelnd == 8)
            M = 8;
        end
        if (nelnd == 20)
            M = 27;
        end
    end
end