/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing




------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing


-- update NashvilleHousing
-- set SaleDate = CONVERT(Date, SaleDate)


alter table NashvilleHousing
add SaleDateConverted Date;


update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)


-------------------------------------------------------


-- Populate Property Address data

select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is not null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as City

from PortfolioProject.dbo.NashvilleHousing


-- Let's create two new columns

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);


update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);


update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing



-- Modification of 'OwnerAddress'


-- The 'OwnerAddress' contains the address, the city and the state in one single column
select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


-- Breaking of information into different columns by using 'PARSENAME'

select
PARSENAME(replace(OwnerAddress, ',', '.'),3)
, PARSENAME(replace(OwnerAddress, ',', '.'),2)
, PARSENAME(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);


update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'),3)


alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);


update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);


update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'),1)


select *
from PortfolioProject.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------

--- Change Y and N to Yes and No in "SoldasVacant" field

select distinct(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing


select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, Case When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject.dbo.NashvilleHousing



update NashvilleHousing
set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

select *
from PortfolioProject.dbo.NashvilleHousing



-----------------------------------------------------------------------------------------

-- Remove Duplicates


with row_numCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

select *
from row_numCTE
where row_num > 1
order by PropertyAddress




with row_numCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

delete
from row_numCTE
where row_num > 1
--order by PropertyAddress


--------------------------------------------------------------------------------

-- Delete Unused Columns

select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, PropertyAddress, TaxDistrict



alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate