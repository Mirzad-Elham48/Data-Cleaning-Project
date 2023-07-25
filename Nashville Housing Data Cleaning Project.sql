/*

Cleaning data in SQL queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing
-------------------------------------------------------------------------------

-- Standardize date format

Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date, SaleDate)

Alter Table NashvilleHousing
add SaleDateConv Date;

Update NashvilleHousing
set SaleDateConv = Convert(Date, SaleDate)

-------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.propertyaddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------------

-- Breaking out Address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
-- order by ParcelID


Select SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) As Adress,
SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) As City
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
add PropertySpiltAddress nvarchar(255);

Update NashvilleHousing
set PropertySpiltAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertySpiltCity nvarchar(255);

Update NashvilleHousing
set PropertySpiltCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select PropertySpiltCity, PropertySpiltAddress
From NashvilleHousing





Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(Replace(owneraddress, ',', '.'), 3),
PARSENAME(Replace(owneraddress, ',', '.'), 2),
PARSENAME(Replace(owneraddress, ',', '.'), 1)
From NashvilleHousing


Alter Table NashvilleHousing
add OwnerSpiltAddress nvarchar(255);

Update NashvilleHousing
set OwnerSpiltAddress = PARSENAME(Replace(owneraddress, ',', '.'), 3)

Alter Table NashvilleHousing
add OwnerSpiltCity nvarchar(255);

Update NashvilleHousing
set OwnerSpiltCity = PARSENAME(Replace(owneraddress, ',', '.'), 2)

Alter Table NashvilleHousing
add OwnerSpiltState nvarchar(255);

Update NashvilleHousing
set OwnerSpiltState = PARSENAME(Replace(owneraddress, ',', '.'), 1)


Select OwnerSpiltAddress, OwnerSpiltCity, OwnerSpiltState
From NashvilleHousing


-------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end
From NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end


-------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE as(
Select *,
ROW_NUMBER() OVER (
Partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by
			 UniqueID
			 ) row_num
			 
From NashvilleHousing
--order by parcelID
)
--Delete
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress




-------------------------------------------------------------------------------

-- Remove Duplicates


Select *
From NashvilleHousing


Alter Table NashvilleHousing
Drop Column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict