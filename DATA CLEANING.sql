-- Data Cleaning

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values
-- 4. Remove Any Columns

-- REMOVING DUPLICATES

SELECT * 
FROM layoffs_staging;

-- 1

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)

SELECT * FROM duplicate_cte
WHERE row_num >1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int, 
  `row_num` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging2;

-- REMOVED DUPLICATES FROM THE DATA

-- STANDARDIZING THE DATA

-- checking the data in the company coloumn

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- checking the data in the industry coloumn
-- Found lot of duplicates in crypto industry such as crypto, cryptocurrency

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE '%crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE '%Crypto%';

-- checking the data in the location and the country coloumn

SELECT DISTINCT location
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET  country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- updated the country coloumn

SELECT *
FROM layoffs_staging2;

-- updating the date coloum from string to date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- standardized the data

-- NULL AND BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry , t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    SET t1.industry = t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;

-- cleaned the DATA
