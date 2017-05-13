function y = g_sbetime2timenum(x)

y = x./24/3600+datenum([1970 1 1 0 0 0]);