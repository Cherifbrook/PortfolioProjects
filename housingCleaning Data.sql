/* 
cleaning data in SQL Server */

Select*
from PortfolioProject.dbo.Housingcleaning

--Standarize Date Format

Select SaleDateConverted, convert( Date, SaleDate)
from PortfolioProject.dbo.Housingcleaning

Update portfolioProject.dbo.Housingcleaning
Set SaleDate = Convert(date, SaleDate)

Alter table portfolioproject.dbo.Housingcleaning
add SaleDateConverted Date;

Update PortfolioProject.dbo.Housingcleaning
Set SaleDateConverted = Convert(date, SaleDate)


--populate proerty address data 

Select *
from PortfolioProject.dbo.Housingcleaning
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housingcleaning a
join PortfolioProject.dbo.Housingcleaning b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housingcleaning a
join PortfolioProject.dbo.Housingcleaning b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-- Breaking out address into individual columns ( address, city, state)

select Propertyaddress
FROM PortfolioProject.DBO.Housingcleaning
--Where propertyaddress is null
--order by parcelID

select 
SUBSTRING (propertyaddress,1, charindex(',', PropertyAddress)-1) as Address
, SUBSTRING (propertyaddress , charindex(',', PropertyAddress) +1 , LEN (PropertyAddress)) as Address
FROM PortfolioProject.DBO.Housingcleaning

Alter table portfolioproject.dbo.Housingcleaning
add PropertySplitAdress Nvarchar(255);

Update PortfolioProject.dbo.Housingcleaning
Set PropertySplitAdress = SUBSTRING (propertyaddress,1, charindex(',', PropertyAddress)-1)

Alter table portfolioproject.dbo.Housingcleaning
add PropertySplitcity Nvarchar(255); 

Update PortfolioProject.dbo.Housingcleaning
Set PropertySplitcity = SUBSTRING (propertyaddress , charindex(',', PropertyAddress) +1 , LEN (PropertyAddress))

select*
from PortfolioProject.dbo.Housingcleaning


select ownerAddress
from PortfolioProject.dbo.Housingcleaning

select 
parsename (replace(ownerAddress,',','.'),3)
,parsename (replace(ownerAddress,',','.'),2)
,parsename (replace(ownerAddress,',','.'),1)
from PortfolioProject.dbo.Housingcleaning

Alter table portfolioproject.dbo.Housingcleaning
add OwnerSplitAdress Nvarchar(255);

Update PortfolioProject.dbo.Housingcleaning
Set OwnerSplitAdress = parsename (replace(ownerAddress,',','.'),3)

Alter table portfolioproject.dbo.Housingcleaning
add OwnerSplitcity Nvarchar(255); 

Update PortfolioProject.dbo.Housingcleaning
Set OwnerSplitcity = parsename (replace(ownerAddress,',','.'),2)

Alter table portfolioproject.dbo.Housingcleaning
add OwnerSplitState Nvarchar(255); 

Update PortfolioProject.dbo.Housingcleaning
Set OwnerSplitState = parsename (replace(ownerAddress,',','.'),1)

select*
from PortfolioProject.dbo.Housingcleaning

--change  Y and N to Yes and No in "Sold as vacant" field

select distinct (SoldAsVacant), count(soldasvacant)
from PortfolioProject.dbo.Housingcleaning
group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then'No'
		else SoldAsVacant 
		end
from PortfolioProject.dbo.Housingcleaning


update PortfolioProject.dbo.Housingcleaning
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then'No'
		else SoldAsVacant 
		end


--remove duplicates ( just to try things )


with rowNumCTE as (
select*,
ROW_NUMBER()over(
	partition by ParcelID, 
			 PropertyAddress, 
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order BY
			    UniqueID
				) row_num
from PortfolioProject.dbo.Housingcleaning
--order by ParcelID
)
select*
from rowNumCTE 
where row_num > 1
--order by PropertyAddress




--delete unused columns (just because i can for now ?)

select*
from PortfolioProject.dbo.Housingcleaning

alter table  PortfolioProject.dbo.Housingcleaning
drop column Owneraddress, taxDistrict, PropertyAddress  ,SaleDate

--tadaa!

