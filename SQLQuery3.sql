/*
Cleaning Data in SQL Queries
*/
Select *
from portfolio3.dbo.NashvilleHousing

/*
Make the sale date standard
*/
Select SaleDate, convert(Date,SaleDate)
from portfolio3.dbo.NashvilleHousing


update NashvilleHousing
set SaleDate=convert(Date,SaleDate)

Alter Table Nashvillehousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted=convert(Date,SaleDate)


--populate property address Data

Select * 
from portfolio3.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

-- same parcels have the same address so we have to assign same address' for the null ones.
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio3.dbo.NashvilleHousing a
join portfolio3.dbo.NashvilleHousing b
on a.parcelID=b.ParcelID
and a.[uniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

Update a
set PropertyAddress= isnull(a.propertyAddress,b.PropertyAddress)
from portfolio3.dbo.NashvilleHousing a
join portfolio3.dbo.NashvilleHousing b
on a.parcelID=b.ParcelID
and a.[uniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null


-- Breaking address into individual columns 

Select PropertyAddress
From portfolio3.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Portfolio3t.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From portfolio3.dbo.NashvilleHousing


--owner address modification

Select OwnerAddress
From portfolio3.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From portfolio3.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From portfolio3.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolio3.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portfolio3.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   From portfolio3.dbo.NashvilleHousing

	   -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From portfolio3.dbo.NashvilleHousing

)
Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From portfolio3.dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From portfolio3.dbo.NashvilleHousing


ALTER TABLE portfolio3.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
