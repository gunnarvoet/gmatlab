function ro = g_internal_rossby_radius(deltarho,h,lat)

gprime = sw_g(lat).*deltarho./1027;
c = sqrt(gprime*h);

ro = c/abs(sw_f(lat));