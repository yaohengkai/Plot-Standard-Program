datadir='G:\ISHI数据\temp\';
filelist=dir([datadir,'*.nc']);
a=filelist(1).name;
b=filelist(2).name;
k=length(filelist);
for n=1:12;
    n=1
    h=figure(n);
    numb=num2str(n+2000);
    title([numb,'年经度-深度断面图']);
    set(h,'name','经度-深度断面图','Numbertitle','off')
    for i=1:12;
    subplot(3,4,i);
    filename=[datadir,filelist(56+n).name];
    data{1,n}=ncread(filename,'WTMP_GDS0_DBSL');
    depth{1,n}=ncread(filename,'lv_DBSL1');
    lon{1,n}=ncread(filename,'g0_lon_3');
    lat{1,n}=ncread(filename,'g0_lat_2');
    temp=data{1,n}(:,164,:,i);
    tempa=squeeze(temp);
    tempa1=tempa(341:360,:);
    tempa2=tempa(1:40,:);
    tempfinal=cat(1,tempa1,tempa2);
    [cc hh]=contourf(lon1,depth{1,n},tempfinal');clabel(cc,hh);
    axis([-20 40 0 1200])
    %set()
    num=num2str(i);
    xlabel('X轴-经度');
    ylabel('Y轴-深度(m)');
    set(gca,'yTick',[0 10 20 30 50 75 100 125 150 200 250 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500]);
    title([num,'月份']);
    end
    %colorbar;
end
    
    