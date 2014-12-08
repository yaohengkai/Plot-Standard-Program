datadir='G:\ISHI数据\temp\';
filelist=dir([datadir,'*.nc']);
n=length(filelist);
a=[datadir,filelist(1).name];
lon=ncread(a,'g0_lon_3');
depth=ncread(a,'lv_DBSL1');
lat=ncread(a,'g0_lat_2');
time=ncread(a,'initial_time0_hours');
temp0=zeros(360,180,24,12,68);
temp=zeros(25,7,16,12,68);
for k=1:n
    filename=[datadir,filelist(k).name];
    temp0(:,:,:,:,k)=ncread(filename,'WTMP_GDS0_DBSL');
    temp(:,:,:,:,k)=cat(1,temp0(344:360,167:173,1:16,:,k),temp0(1:8,167:173,1:16,:,k));
end    
temp1(25,7,16,12,68)=0;
temp1=nanmean(temp(:,:,:,:,:),5);
lon1=cat(1,lon(344:360)-360,lon(1:8));
lon1=double(lon1);
lat1=lat(167:173);
lat1=double(lat1);
depth1=depth(1:16);
depth1=double(depth1);
subplot(2,2,1);
for i=1:4
temph{i}=1/3*(squeeze(temp1(:,:,:,i+2))+squeeze(temp1(:,:,:,i+3))+squeeze(temp1(:,:,:,i+4)));
end
for i=1:4
    subplot(2,2,i);
    templa=nanmean(temph{i},1);templa=squeeze(templa);
    templa(templa==0)=nan;
    [cc hh]=contourf(lat1,depth1,templa');clabel(cc,hh);
    s=[num2str(i),'季节']
    title(s)
    xlabel('X轴-纬度   经度平均');
    ylabel('Y轴-深度(m)');
end
figure
for i=1:4
    subplot(2,2,i);
    templ2a=nanmean(temph{i},2);templ2a=squeeze(templ2a);
    templ2a(templa==0)=nan;
    [cc hh]=contourf(lon1,depth1,templ2a');clabel(cc,hh);
    s=[num2str(i),'季节']
    title(s)
    xlabel('X轴-经度  纬度平均');
    ylabel('Y轴-深度(m)');
end
