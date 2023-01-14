use [portfolio project]

select * from [dbo.NashvilleHousing]

/*
Clening Data in SQL Quries

*/

-----------------------------------------------

---Standardize Date Format

select SaleDateConverted,convert(Date,saleDate)
from [dbo.NashvilleHousing]

update [dbo.NashvilleHousing] 
set SaleDate = convert(Date,saleDate)


Alter table [dbo.NashvilleHousing]
add SaleDateConverted date;

update [dbo.NashvilleHousing] 
set SaleDateConverted = convert(Date,saleDate)



-----------------------------------------------------------------------------------------------------------

---Populate Property Address Data

select* from [dbo.NashvilleHousing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelId,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from [dbo.NashvilleHousing] a
join [dbo.NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [dbo.NashvilleHousing] a
join [dbo.NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


----------------------------------------------------------------------------------------------

----Breking out Address Into Individual Column (Address, City , State)

select PropertyAddress from [dbo.NashvilleHousing]
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress) +1,len(PropertyAddress)) as Address
 from [dbo.NashvilleHousing]

 Alter table [dbo.NashvilleHousing]
 Add PropertySplitAddress nvarchar(255);

 update [dbo.NashvilleHousing]
 set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1 )

 Alter table  [dbo.NashvilleHousing]
 Add PropertySplitCity nvarchar(255);

 update [dbo.NashvilleHousing]
 set PropertySplitCity =SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress) +1,len(PropertyAddress))



 select OwnerAddress from [dbo.NashvilleHousing]

 select 
 PARSENAME(replace(OwnerAddress,',','.'),3)
 ,PARSENAME(replace(OwnerAddress,',','.'),2)
 ,PARSENAME(replace(OwnerAddress,',','.'),1)
 from [dbo.NashvilleHousing]


 Alter table [dbo.NashvilleHousing]
 Add OwnerSplitAddress nvarchar(255);

 update [dbo.NashvilleHousing]
 set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

 Alter table  [dbo.NashvilleHousing]
 Add OwnerSplitCity nvarchar(255);

 update [dbo.NashvilleHousing]
 set OwnerSplitCity =PARSENAME(replace(OwnerAddress,',','.'),2)

 Alter table  [dbo.NashvilleHousing]
 Add OwnerSplitState nvarchar(255);


 update [dbo.NashvilleHousing]
 set OwnerSplitState =PARSENAME(replace(OwnerAddress,',','.'),1)



 select * from [dbo.NashvilleHousing]



 ---------------------------------------------------------------------------------------------------------------------

 -----Change Y and N to yes and No in "Sold as Vacant" Field 


 select distinct(soldAsVacant),Count(soldAsVacant)
 from [dbo.NashvilleHousing]
 Group by SoldAsVacant
 order by 2

 select  SoldAsVacant 
 ,CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'Y' THEN 'NO'
	   Else SoldAsVacant
	   End
	from [dbo.NashvilleHousing]

	update [dbo.NashvilleHousing]
	set SoldAsVacant =CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'Y' THEN 'NO'
	   Else SoldAsVacant
	   End

----------------------------------------------------------------------------------------------------------------------
-----Remove Duplicates

with RownumberCTE AS(
select *, 
ROW_NUMBER() over( partition by ParcelId,PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by uniqueid
) row_num
from  [dbo.NashvilleHousing] 
--order by ParcelID
)
select * from RownumberCTE
where row_num >1
order by PropertyAddress

--------------------------------------------------------------------------------------------------------------------------- 
----Delete Unused column 

select * from [dbo.NashvilleHousing]

alter table [dbo.NashvilleHousing]
drop column OwnerAddress ,TaxiDistrict,PropertyAddress


alter table [dbo.NashvilleHousing]
drop column SaleDate

