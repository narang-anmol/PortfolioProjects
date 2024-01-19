--Cleaning Data in SQL

	SELECT *
	FROM nashvillehousing;
	
--Standardizing Sale Date Format

	SELECT saledate, CAST(saledate AS DATE)
	FROM nashvillehousing;
	
	ALTER TABLE nashvillehousing
	ALTER COLUMN saledate TYPE DATE USING saledate::DATE;

--Populating Null Values in Property Address

	UPDATE nashvillehousing a
	SET propertyaddress = b.propertyaddress
	FROM nashvillehousing b
	WHERE a.parcelid = b.parcelid
		AND a.uniqueid <> b.uniqueid
		AND a.propertyaddress IS NULL;

--Breaking out Address Into Individual Columns (Address, City, State)

	ALTER TABLE nashvillehousing
	ADD propertysplitaddress VARCHAR(255),
	ADD propertysplitcity VARCHAR(255);
	
	UPDATE nashvillehousing
	SET
	propertysplitaddress = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1),
	propertysplitcity = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1, LENGTH(propertyaddress));

--Breaking out Owner Address Into Individual Columns (Address, City, State)

	ALTER TABLE nashvillehousing
	ADD ownersplitaddress VARCHAR(255),
	ADD ownersplitcity VARCHAR(255),
	ADD ownersplitstate VARCHAR(255);

	UPDATE nashvillehousing
	SET 
	ownersplitaddress = split_part(replace(owneraddress, ',', '.'), '.', 1),
    ownersplitcity = split_part(replace(owneraddress, ',', '.'), '.', 2),
    ownersplitstate = split_part(replace(owneraddress, ',', '.'), '.', 3);
	
--Change Y and N to Yes and No for Uniformity in "Sold As Vacant" Coluumn

	/* SELECT COUNT(*), soldasvacant
	FROM nashvillehousing
	GROUP BY soldasvacant */
	
	UPDATE nashvillehousing
	SET soldasvacant = 
					CASE 
                    WHEN soldasvacant = 'Y' THEN 'Yes'
                    WHEN soldasvacant = 'N' THEN 'No'
                    ELSE soldasvacant
                  	END;
					
--Removing Duplicate Rows

	WITH RowNumCTE AS (
	SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY parcelid,
                         propertyaddress,
                         saleprice,
                         saledate,
                         legalreference
            ORDER BY UniqueID
						) row_num
    FROM nashvillehousing
		)
	DELETE
	FROM nashvillehousing
	USING RowNumCTE
	WHERE nashvillehousing.uniqueid = RowNumCTE.uniqueid AND row_num > 1;
	
--Deleting Unused Columns

	ALTER TABLE nashvillehousing
	DROP COLUMN owneraddress,
	DROP COLUMN taxdistrict,
	DROP COLUMN propertyaddress,
	DROP COLUMN saledate;

	--SELECT * FROM nashvillehousing
