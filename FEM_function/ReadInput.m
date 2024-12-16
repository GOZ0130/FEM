function [coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput(filename)
    coor = h5read(filename, '/coor');
    conn = h5read(filename, '/conn');
    ndime = h5read(filename, '/ndime');
    mate = h5read(filename, '/mate');
    nnode = h5read(filename, '/nnode');
    nelem = h5read(filename, '/nelem');
    nelnd = h5read(filename, '/nelnd');
    npres = h5read(filename, '/npres');
    pres = h5read(filename, '/pres');
    nload = h5read(filename, '/nload');
    load = h5read(filename, '/load');
    ntrac = h5read(filename, '/ntrac');
    trac = h5read(filename, '/trac');
end