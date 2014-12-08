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
for i=1:12
    subplot(3,4,i);
    temp2=squeeze(temp1(:,:,:,i));
    templa=nanmean(temp2,1);templa=squeeze(templa);
    templa(templa==0)=nan;
    [cc hh]=contourf(lat1,depth1,templa');clabel(cc,hh);
    s=[num2str(i),'月份']
    title(s)
    xlabel('X轴-纬度   经度平均');
    ylabel('Y轴-深度(m)');
end
figure
for i=1:12
    subplot(3,4,i);
    temp2=squeeze(temp1(:,:,:,i));
    templ2a=nanmean(temp2,2);templ2a=squeeze(templ2a);
    templ2a(templ2a==0)=nan;
    [cc hh]=contourf(lon1,depth1,templ2a');clabel(cc,hh);
    s=[num2str(i),'月份']
    title(s)
    xlabel('X轴-经度  纬度平均');
    ylabel('Y轴-深度(m)');
end
for i=1:4
    subplot(2,2,i);
    temph=temp
figure
for i=1:68
    temp4=squeeze(temp(:,:,:,:,i));
    for j=1:12
        temp5(:,:,:,i*j)=squeeze(temp4(:,:,:,j));
    end
end
temp6=nanmean(temp5,4);
temp7=squeeze(temp6(:,:,1));
temp7(temp7==0)=nan;
contourf(lon1,lat1,temp7');
title([num2str(depth1(1)),'主要标准层海温分布']);
figure
temp7=squeeze(temp6(:,:,5));
temp7(temp7==0)=nan;
contourf(lon1,lat1,temp7');
title([num2str(depth1(5)),'主要标准层海温分布']);
figure
temp7=squeeze(temp6(:,:,7));
temp7(temp7==0)=nan;
contourf(lon1,lat1,temp7');
title([num2str(depth1(7)),'主要标准层海温分布']);
figure
temp7=squeeze(temp6(:,:,12));
temp7(temp7==0)=nan;
contourf(lon1,lat1,temp7');
title([num2str(depth1(12)),'主要标准层海温分布']);
figure
temp7=squeeze(temp6(:,:,16));
temp7(temp7==0)=nan;
contourf(lon1,lat1,temp7');
title([num2str(depth1(16)),'主要标准层海温分布']);

