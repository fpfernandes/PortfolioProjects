/*

Cleaning Data Using SQL

*/

select *
from project.dbo.nashvillehousing

------- Standardizing Date Format ---------------------------------------------

select 
	SaleDate,
	CONVERT(Date, SaleDate)
from project.dbo.nashvillehousing

ALTER TABLE project.dbo.nashvillehousing
Add SaleDateConverted Date;

update project.dbo.nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted
from project.dbo.nashvillehousing


------- Populating Property Address Data ---------------------------------------------

select *
from project.dbo.nashvillehousing
where PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from project.dbo.nashvillehousing a
JOIN project.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


------- Breaking Out Addresses Into Individual Columns (Address, City, State) ---------------------------------------------

select PropertyAddress
from project.dbo.nashvillehousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from project.dbo.nashvillehousing

ALTER TABLE project.dbo.nashvillehousing
Add PropertySplitAddress Nvarchar(255);

update project.dbo.nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE project.dbo.nashvillehousing
Add PropertySplitCity Nvarchar(255);

update project.dbo.nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



select 
	PARSENAME(REPLACE(OwnerAddress, ',','.') ,3),
	PARSENAME(REPLACE(OwnerAddress, ',','.') ,2),
	PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
from project.dbo.nashvillehousing

ALTER TABLE project.dbo.nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

update project.dbo.nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

ALTER TABLE project.dbo.nashvillehousing
Add OwnerSplitCity Nvarchar(255);

update project.dbo.nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)

ALTER TABLE project.dbo.nashvillehousing
Add OwnerSplitState Nvarchar(255);

update project.dbo.nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

select *
from project.dbo.nashvillehousing



------- Changing Y and N to Yes and No in "Sold as Vacant" field ---------------------------------------------

select 
	SoldAsVacant,
	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		 when SoldAsVacant = 'Y' THEN 'Yes'
		 else SoldAsVacant
		 END 
from project.dbo.nashvillehousing

update project.dbo.nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
		 when SoldAsVacant = 'Y' THEN 'Yes'
		 else SoldAsVacant
		 END 



------- Removing Duplicates ---------------------------------------------


WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num
from project.dbo.nashvillehousing
)
Delete
from RowNumCTE
where row_num > 1


------- Deleting Unused Columns ---------------------------------------------


ALTER TABLE project.dbo.nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







