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
	ADD propertysplitaddress VARCHAR(255);

	ALTER TABLE nashvillehousing
	ADD propertysplitcity VARCHAR(255);
	
	UPDATE nashvillehousing
	SET
	propertysplitaddress = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1),
	propertysplitcity = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1, LENGTH(propertyaddress));
	
	SELECT * FROM nashvillehousing