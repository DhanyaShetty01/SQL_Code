-- Data_Cleaning

USE world_layoffs;

-- Create a new duplicate table of raw data so that the raw data can be used to refer if any mistakes are made. 

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Select *
-- from layoffs_staging
-- where company = 'casper';

-- Step1: Remove Duplicates if there are any
-- * Here we donot have primary key/unique vales so we can use windows function to find Row numbers
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

-- Finding for duplicate columns; If row_num is 1 the there are no duplictes , else if row num >= 1 the there are duplicates
WITH duplicate_cte as(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- To remove duplicates create another table same as layoffs_staging, its like creating another table that has an extra row 
-- and then deleting it where that row is equal to 2
CREATE TABLE layoffs_staging2
LIKE layoffs_staging;


ALTER TABLE layoffs_staging2
ADD row_num int;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num >1 ;

-- Safe mode in MySQL is a feature designed to prevent accidental updates or deletions of data.
-- When safe mode is enabled, MySQL restricts the execution of UPDATE or DELETE statements that do not include a WHERE.
SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num >1 ;

-- We successfully removed the duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num >1 ;


-- Step2: Standardize the data(spelling mistakes, same format etc)

-- TRIM removes the white spaces on both sides
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Cry%';
-- ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Cry%';

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
-- 1 means 1st column in select statement which is location
ORDER BY 1;

-- TRAILING is used trim char which comes at the end. 
SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united States%';

SELECT DISTINCT country
FROM layoffs_staging2
order by 1;

SELECT `date`,
-- SQL date format
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

-- Changing data type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


-- Step3: Null Values or Blank Values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Setting blank values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT industry
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Did not get updated, So updating all the blanks in industry col to null
UPDATE layoffs_staging2  t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2;


-- Step4: Remove any unwanted Columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- OUR final cleaned data
SELECT *
FROM layoffs_staging2;

