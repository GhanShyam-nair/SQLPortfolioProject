
-- Data Cleaning 
-- changing the date format

ALTER TABLE Nashville
Add SaleDateUpdated Date;

UPDATE Nashville
SET	SaleDateUpdated =Convert(Date,SaleDate)

SELECT SaleDateUpdated
From main_project..Nashville


--add null value addresses 

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville a
Join Nashville b
On a.ParcelID=b.ParcelID
WHERE a.[UniqueID ] <> b.[UniqueID ]

Select a.propertyAddress,b.propertyAddress,a.ParcelID,b.ParcelId
From Nashville a
Join Nashville b
On a.ParcelID =b.ParcelID
WHERE a.PropertyAddress is null


--Breaking down address into multiple values
ALTER TABLE Nashville
Add CityName varchar(50);

ALTER TABLE Nashville
Add PropertyLocation varchar(50);

Update nashville
set PropertyLocation =SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)


Update nashville
set CityName =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * from Nashville


--- setting sold as vacant as yes and no
Select Distinct(SoldAsVacant) , Count(SoldAsVacant)
From Nashville
group by SoldAsVacant
order by 2


Update Nashville
Set SoldAsVacant = 
Case When SoldAsVacant='Y' THEN 'Yes'
	When SoldAsVacant ='N' THEN 'NO'
ELSE SoldAsVacant
END



--REmoving Duplicates
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

From Nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Nashville




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Nashville


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
