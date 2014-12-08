%%
t=ncread('temp.2012.grb.nc','WTMP_GDS0_DBSL');
p=ncread('temp.2012.grb.nc','MSLSA_GDS0_DBSL');
s=ncread('sal.2012.grb.nc','SALTY_GDS0_DBSL');
lon=ncread('sal.2012.grb.nc','g0_lon_3');
lat=ncread('sal.2012.grb.nc','g0_lat_2');
d=ncread('sal.2012.grb.nc','lv_DBSL1');
save('data_tpsd_lonlat.mat');%��ȡ�ļ�����
%%
s2=squeeze(s(:,:,2,1));
t2=squeeze(t(:,:,2,1));
p2=squeeze(p(:,:,2,1));
ptmp=sw_ptmp(s2,t2,p2,0);
m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]);
m_contourf(lon,lat,ptmp');
m_coast('patch',[.7 .7 .7]);
m_grid('xtick',18,'ytick',18);
colorbar;
title('Jan of 2012,10m,Global potential temperature ');%2012��1��10��ˮ�ȫ��ˮƽ�ֲ�ͼ
%%
s0=[s(345:360,:,:,:);s(1:8,:,:,:)];
s1=squeeze(s0(:,169,:,1));
p0=[p(345:360,:,:,:);p(1:8,:,:,:)];
p1=squeeze(p0(:,169,:,1));
t0=[t(345:360,:,:,:);t(1:8,:,:,:)];
t1=squeeze(t0(:,169,:,1));
ptmp=sw_ptmp(s1,t1,p1,0);
figure;
contourf(ptmp);
axis ij;
colorbar;
set(gca,'XAxisLocation','top','XTickLabel',{'14.5W','12.5W','10.5W','8.5W','6.5W','4.5W','2.5W','0.5W','1.5E','3.5E','5.5E','7.5E'},'YTickLabel',{'10','30','75','125','200','300','500','700','900','1100','1300','1500'});
title('Jan of 2012,78.5N section,potential temperature');%2012��1��78.5Nfram��Ͽ���洦λ�·ֲ�ͼ

%%
load('data_tpsd_lonlat.mat')
sij=zeros(360,180);
tij=zeros(360,180);
pij=zeros(360,180);
ptmpij=zeros(360,180);
ptmp=zeros(360,180,24,12);
pdenij=zeros(360,180);
pden=zeros(360,180,24,12);
for i=1:12
    for j=1:24
        sij=squeeze(s(:,:,j,i));
        tij=squeeze(t(:,:,j,i));
        pij=squeeze(p(:,:,j,i));
        ptmpij=sw_ptmp(sij,tij,pij,0);
        ptmp(:,:,j,i)=ptmpij(:,:);
        pdenij=sw_pden(sij,tij,pij,0);
        pden(:,:,j,i)=pdenij(:,:);
    end
end %�õ�ptmp��pden��ά����
save('data_ptmp_pden.mat');
%%
load('data_tpsd_lonlat.mat');
load('data_ptmp_pden.mat');
ptmp1=zeros(24,20,1500,12);%ptmp1,pden1�ǲ�ֵ��1-1500�ף���λ��λ�ܣ���ȡ�˾ֲ�����
pden1=zeros(24,20,1500,12);

%��ԭptmp��pden�ľֲ�����γ�Ⱥ�ԭ��ȸ���ptmp1��pden1
for i=1:8 %���ȵ�һ����
    for j=1:20
        for k=2:24 %����0m
        ptmp1(i,j,d(k),:)=ptmp(i,j+150,k,:);%d��k��Ϊԭˮ��
        pden1(i,j,d(k),:)=pden(i,j+150,k,:);
        end
    end
end

for i=9:24 %���ȵڶ�����
    for j=1:20
        for k=2:24
        ptmp1(i,j,d(k),:)=ptmp(i+336,j+150,k,:);
        pden1(i,j,d(k),:)=pden(i+336,j+150,k,:);
        end
    end
end

%��������Ȳ�ֵ
for m=1:8%���ȵ�һ����
    for n=1:20
        for k=1:12
            for i=1:23
                for j=d(i)+1:d(i+1)-1 %+1��-1���ų���ԭ��� 
                    ptmp1(m,n,j,k)=(1/(j-d(i))*ptmp(m,n+150,i,k)+1/(d(i+1)-j)*ptmp(m,n+150,i+1,k))/(1/(j-d(i))+1/(d(i+1)-j));
                    pden1(m,n,j,k)=(1/(j-d(i))*pden(m,n+150,i,k)+1/(d(i+1)-j)*pden(m,n+150,i+1,k))/(1/(j-d(i))+1/(d(i+1)-j));
                end
            end
        end
    end
end

for m=9:24%���ȵڶ�����
    for n=1:20
        for k=1:12
            for i=1:23
                for j=d(i)+1:d(i+1)-1
                    ptmp1(m,n,j,k)=(1/(j-d(i))*ptmp(m+336,n+150,i,k)+1/(d(i+1)-j)*ptmp(m+336,n+150,i+1,k))/(1/(j-d(i))+1/(d(i+1)-j));
                    pden1(m,n,j,k)=(1/(j-d(i))*pden(m+336,n+150,i,k)+1/(d(i+1)-j)*pden(m+336,n+150,i+1,k))/(1/(j-d(i))+1/(d(i+1)-j));
                end
            end
        end
    end
end
%���н���ǣ�����ԭ�����ֵ��������ȶ�Ϊ0,��ֵ���ɹ�.������Ϊm��n��k��i��ֵ�����ղ�ֵ��ʽ����������