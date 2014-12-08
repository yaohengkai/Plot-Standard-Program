%%
%输入一个该海区的初始范围经纬度范围（lon1:西，lon2：东，lat1：北，lat2：南）
%东经为正，西经为负，北纬为正，南纬为负
%并计算总共格点数
lon_field0=[-32,16];
lat_field0=[60,85];
lon_num=lon_field0(2)-lon_field0(1)+1;
lat_num=lat_field0(2)-lat_field0(1)+1;
%将所输入经纬转换到数据对应坐标
%本程序适用于数据La1       = -89.5
%                         Lo1       = 0.5
%                         La2       = 89.5
%                         Lo2       = 359.5
%将本初子午线东西两侧的区域分开
if (lon_field0(1)<0&&lon_field0(2)>0) 
    lon_field=[lon_field0(1)+360, 360, 1, lon_field0(2)];
end
if (lat_field0>0)
    lat_field=lat_field0+90;
end

    lon1_num=lon_field(2)-lon_field(1)+1;
    lon2_num=lon_field(4)-lon_field(3)+1;
%批量读取nc文件的list
datadir='/Volumes/Macintoch HD/DATA/ishii/temp/';
filelist=dir([datadir,'*.nc']);
n=length(filelist);
%读入文件原始经纬、时间、深度列表
a=[datadir,filelist(1).name];
lon0=ncread(a,'g0_lon_3');
lat0=ncread(a,'g0_lat_2');
depth0=ncread(a,'lv_DBSL1');
time0=ncread(a,'initial_time0_hours');
% save data_inf
%%
%批量读取nc文件(温度、盐度、压力)
%load data_inf
%温度
datadir='/Volumes/Macintoch HD/DATA/ishii/temp/';
temp=zeros(lon_num, lat_num, length(depth0), length(time0),n);
temp1=zeros(lon1_num, lat_num, length(depth0), length(time0));
temp2=zeros(lon2_num, lat_num, length(depth0), length(time0));

for k=1:n
    filename=[datadir,filelist(k).name];
    temp1(:,:,:,:)=ncread(filename,'WTMP_GDS0_DBSL',...
                       [lon_field(1), lat_field(1), 1, 1], [lon1_num, lat_num, inf, inf]);
    temp2(:,:,:,:)=ncread(filename,'WTMP_GDS0_DBSL',...
                       [lon_field(3), lat_field(1), 1, 1], [lon2_num, lat_num, inf, inf]);
	temp(:,:,:,:,k)=cat(1,temp1,temp2);
end   

%盐度
datadir='/Volumes/Macintoch HD/DATA/ishii/salinity/';
salt=zeros(lon_num, lat_num, length(depth0), length(time0),n);
salt1=zeros(lon1_num, lat_num, length(depth0), length(time0));
salt2=zeros(lon2_num, lat_num, length(depth0), length(time0));

for k=1:n
    filename=[datadir,filelist(k).name];
    salt1(:,:,:,:)=ncread(filename,'SALTY_GDS0_DBSL',...
                       [lon_field(1), lat_field(1), 1, 1], [lon1_num, lat_num, inf, inf]);
    salt2(:,:,:,:)=ncread(filename,'SALTY_GDS0_DBSL',...
                       [lon_field(3), lat_field(1), 1, 1], [lon2_num, lat_num, inf, inf]);
	salt(:,:,:,:,k)=cat(1,salt1,salt2);
end 

%压力
datadir='/Volumes/Macintoch HD/DATA/ishii/temp/';
pres=zeros(lon_num, lat_num, length(depth0), length(time0),n);
pres1=zeros(lon1_num, lat_num, length(depth0), length(time0));
pres2=zeros(lon2_num, lat_num, length(depth0), length(time0));

for k=1:n
    filename=[datadir,filelist(k).name];
    pres1(:,:,:,:)=ncread(filename,'MSLSA_GDS0_DBSL',...
                       [lon_field(1), lat_field(1), 1, 1], [lon1_num, lat_num, inf, inf]);
    pres2(:,:,:,:)=ncread(filename,'MSLSA_GDS0_DBSL',...
                       [lon_field(3), lat_field(1), 1, 1], [lon2_num, lat_num, inf, inf]);
	pres(:,:,:,:,k)=cat(1,pres1,pres2);
end  

%位温&位密
s=zeros(lon_num, lat_num);
t=zeros(lon_num, lat_num);
p=zeros(lon_num, lat_num);
ptmp=zeros(lon_num, lat_num, length(depth0), length(time0),n);
pden=zeros(lon_num, lat_num, length(depth0), length(time0),n);
for i=1:n;
    for j=1:length(time0);
        for k=1:length(depth0);
            s(:,:)=salt(:,:,k,j,i);
            t(:,:)=temp(:,:,k,j,i);
            p(:,:)=pres(:,:,k,j,i);
            ptmp(:,:,k,j,i)=sw_ptmp(s,t,p,0);
            pden(:,:,k,k,i)=sw_pden(s,t,p,0);
        end
    end
end


lon=lon0([lon_field(1):lon_field(2),lon_field(3):lon_field(4)]);
lat=lat0(lat_field(1):lat_field(2));

save('data_temp.mat','temp','salt','pres','ptmp','pden','lon','lat','depth0','time0');
clear;
%%
%mode=1气候态；mode=2十年平均；mode=3五年平均；mode=4季节平均；mode=5逐月平均
load data_temp.mat
% mode=1;

% size10=idivide(size0(5),10,'ceil');
% size5=idivide(size0(5),5,'ceil');
size0=size(temp);
size10=ceil(size0(5)./10);
size5=ceil(size0(5)./5);
for mode=1:5;
switch mode
    case 1
        %temp
        temp1=zeros(length(lon),length(lat),length(depth0));
        temp1(:,:,:)=nanmean(nanmean(temp,5),4);
        %salt
        salt1=zeros(length(lon),length(lat),length(depth0));
        salt1(:,:,:)=nanmean(nanmean(salt,5),4);
        %ptmp
        ptmp1=zeros(length(lon),length(lat),length(depth0));
        ptmp1(:,:,:)=nanmean(nanmean(ptmp,5),4);
        %pden
        pden1=zeros(length(lon),length(lat),length(depth0));
        pden1(:,:,:)=nanmean(nanmean(pden,5),4);
        
    case 2
        %temp
        temp2=zeros(length(lon),length(lat),length(depth0),size10);
        for k=1:size10-1;
            temp2(:,:,:,k)=nanmean(nanmean(temp(:,:,:,:,10*k-9:10*k),5),4);
        end
            temp2(:,:,:,size10)=nanmean(nanmean(temp(:,:,:,:,10*size10-9:end),5),4);
        %salt
        salt2=zeros(length(lon),length(lat),length(depth0),size10);
        for k=1:size10-1;
            salt2(:,:,:,k)=nanmean(nanmean(salt(:,:,:,:,10*k-9:10*k),5),4);
        end
            salt2(:,:,:,size10)=nanmean(nanmean(salt(:,:,:,:,10*size10-9:end),5),4);
        %ptmp
        ptmp2=zeros(length(lon),length(lat),length(depth0),size10);
        for k=1:size10-1;
            ptmp2(:,:,:,k)=nanmean(nanmean(ptmp(:,:,:,:,10*k-9:10*k),5),4);
        end
            ptmp2(:,:,:,size10)=nanmean(nanmean(ptmp(:,:,:,:,10*size10-9:end),5),4);
        %pden
        pden2=zeros(length(lon),length(lat),length(depth0),size10);
        for k=1:size10-1;
            pden2(:,:,:,k)=nanmean(nanmean(pden(:,:,:,:,10*k-9:10*k),5),4);
        end
            pden2(:,:,:,size10)=nanmean(nanmean(pden(:,:,:,:,10*size10-9:end),5),4);
    case 3
        %temp
        temp3=zeros(length(lon),length(lat),length(depth0),size5);
        for k=1:size5-1;
            temp3(:,:,:,k)=nanmean(nanmean(temp(:,:,:,:,5*k-4:5*k),5),4);
        end
            temp3(:,:,:,size5)=nanmean(nanmean(temp(:,:,:,:,5*size5-4:end),5),4);
        %salt
            salt3=zeros(length(lon),length(lat),length(depth0),size5);
        for k=1:size5-1;
            salt3(:,:,:,k)=nanmean(nanmean(salt(:,:,:,:,5*k-4:5*k),5),4);
        end
            salt3(:,:,:,size5)=nanmean(nanmean(salt(:,:,:,:,5*size5-4:end),5),4);
        %ptmp
        ptmp3=zeros(length(lon),length(lat),length(depth0),size5);
        for k=1:size5-1;
            ptmp3(:,:,:,k)=nanmean(nanmean(ptmp(:,:,:,:,5*k-4:5*k),5),4);
        end
            ptmp3(:,:,:,size5)=nanmean(nanmean(ptmp(:,:,:,:,5*size5-4:end),5),4);        
        %pden
        pden3=zeros(length(lon),length(lat),length(depth0),size5);
        for k=1:size5-1;
            pden3(:,:,:,k)=nanmean(nanmean(pden(:,:,:,:,5*k-4:5*k),5),4);
        end
            pden3(:,:,:,size5)=nanmean(nanmean(pden(:,:,:,:,5*size5-4:end),5),4);
    case 4
        %temp
        temp4=zeros(length(lon),length(lat),length(depth0),length(time0)/3);
        for i=1:3;
            temp4(:,:,:,i)=nanmean(nanmean(temp(:,:,:,(3*i):(3*i+2),:),5),4);
        end
            temp4(:,:,:,4)=nanmean(nanmean(temp(:,:,:,[1,2,12],:),5),4);
        %salt
        salt4=zeros(length(lon),length(lat),length(depth0),length(time0)/3);
        for i=1:3;
            salt4(:,:,:,i)=nanmean(nanmean(salt(:,:,:,(3*i):(3*i+2),:),5),4);
        end
            salt4(:,:,:,4)=nanmean(nanmean(salt(:,:,:,[1,2,12],:),5),4);
        %ptmp
        ptmp4=zeros(length(lon),length(lat),length(depth0),length(time0)/3);
        for i=1:3;
            ptmp4(:,:,:,i)=nanmean(nanmean(ptmp(:,:,:,(3*i):(3*i+2),:),5),4);
        end
            ptmp4(:,:,:,4)=nanmean(nanmean(ptmp(:,:,:,[1,2,12],:),5),4);
        %pden
        pden4=zeros(length(lon),length(lat),length(depth0),length(time0)/3);
        for i=1:3;
            pden4(:,:,:,i)=nanmean(nanmean(pden(:,:,:,(3*i):(3*i+2),:),5),4);
        end
            pden4(:,:,:,4)=nanmean(nanmean(pden(:,:,:,[1,2,12],:),5),4);

%         for k=1,size0(5)
%         if(~isempty(temp(:,:,:,12,k-1)))
%             temp4(:,:,:,4)=nanmean(nanmean(cat(4,temp(:,:,:,12,k-1),temp(:,:,:,[1,2],k)),5),4);
%         else
%             temp4(:,:,:,4)
    case 5
        %temp
        temp5=zeros(length(lon),length(lat),length(depth0),length(time0));
        temp5(:,:,:,:)=nanmean(temp,5);
        %salt
        salt5=zeros(length(lon),length(lat),length(depth0),length(time0));
        salt5(:,:,:,:)=nanmean(salt,5);        
        %ptmp
        ptmp5=zeros(length(lon),length(lat),length(depth0),length(time0));
        ptmp5(:,:,:,:)=nanmean(ptmp,5);        
        %pden
        pden5=zeros(length(lon),length(lat),length(depth0),length(time0));
        pden5(:,:,:,:)=nanmean(pden,5);
    otherwise
        error('You have to chooose a mode!')
end

end
save('temp12345.mat','temp1','temp2','temp3','temp4','temp5');





