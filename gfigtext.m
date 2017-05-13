function ht = gfigtext(s,n)

yl = get(gca,'ylim');
xl = get(gca,'xlim');

if n==1
    y = yl(2)-(yl(2)-yl(1))/15;
    x = xl(2)-(xl(2)-xl(1))/15;
    ht = text(x,y,s);
    set(ht,'horizontalalignment','right','fontsize',12,'fontweight','bold')

elseif n==4
    y = yl(1)+(yl(2)-yl(1))/15;
    x = xl(2)-(xl(2)-xl(1))/15;
    ht = text(x,y,s);
    set(ht,'horizontalalignment','right','fontsize',12,'fontweight','bold')

elseif n==2
    y = yl(2)-(yl(2)-yl(1))/15;
    x = xl(1)+(xl(2)-xl(1))/15;
    ht = text(x,y,s);
    set(ht,'horizontalalignment','left','fontsize',12,'fontweight','bold')

elseif n==3
    y = yl(1)+(yl(2)-yl(1))/15;
    x = xl(1)+(xl(2)-xl(1))/15;
    ht = text(x,y,s);
    set(ht,'horizontalalignment','left','fontsize',12,'fontweight','bold')
end