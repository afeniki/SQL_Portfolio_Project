SELECT *
FROM portfolio_project..Covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2



--Exploring total_deaths, and total_cases
--This shows the total amount of cases, total deaths, percentage of death, location and date.
--Percentage_of_deaths, showing the likelyhood of dying if infected with covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_of_death
FROM portfolio_project..Covid_deaths
WHERE location like '%Nigeria%'
ORDER BY 1, 2


--total_cases versus population
--Percentage of population with covid
SELECT date, location, population, total_cases, (total_cases/population)*100 AS percentage_covidPopulation
FROM portfolio_project..Covid_deaths
WHERE location like '%Nigeria%'
ORDER BY 1, 2


--Country with the highest infection rate compared to the population
SELECT location, population, MAX(total_cases) AS HighestCases, (MAX(total_cases/population))*100 AS Max_PercentageOfCovidPop
FROM portfolio_project..Covid_deaths
--WHERE location like '%Nigeria%'
GROUP BY location, population
ORDER BY Max_PercentageOfCovidPop DESC


--Number of total_deaths
--The United States has the highest number of deaths of 958,437
SELECT location, MAX(CAST(total_deaths as int)) AS Total_no_Deaths
FROM portfolio_project..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_no_Deaths DESC


--Number of total_deaths by continents
--Europe is the continent with the highest number of deaths
SELECT continent, MAX(CAST(total_deaths as int)) AS Total_no_Deaths
FROM portfolio_project..Covid_deaths
WHERE continent IS  not NULL
GROUP BY continent
ORDER BY Total_no_Deaths DESC


--Continents with the highest death count per population
--**Therefore, overall(accross all the countries) we had a total of 443974342 cases, and 5969448 deaths in the world
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS percentage_of_deaths
FROM portfolio_project..Covid_deaths
WHERE continent is NOT NULL
--GROUP BY date
ORDER by 1, 2




--*************************
--*************************
--*************************
--COVID VACCINATION
--Joining the vaccination and covid_death table on location and date

SELECT *
FROM portfolio_project..Covid_deaths AS cd
JOIN portfolio_project..Covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date


--Total population and total number of people that have gotten vaccinated


WITH popvsVac (continent, location, date, population, new_vaccinations, people_vaccinated)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS bigint)) OVER (PARTITION by cd.location ORDER BY cd.location, cd.date)
AS people_vaccinated
FROM portfolio_project..Covid_deaths cd
JOIN portfolio_project..Covid_vaccinations cv
	ON cd.location = cv.location
	AND cd.date = cd.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2, 3
)
SELECT *
FROM popvsVac


--****************************************
--****************************************
--****************************************
--ORRRRRRRRR
--****************************************
--****************************************
TABLE--****************************************

--DROP TABLE IF EXISTS percentage_of_vaccinated_population
CREATE TABLE percentage_of_vaccinated_population
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
People_Vaccinated numeric
)

INSERT INTO percentage_of_vaccinated_population
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(CAST(cv.new_vaccinations as bigint)) OVER (PARTITION BY cd.location ORDER BY cd.location,
	cd.date) AS people_vaccinated
FROM portfolio_project..Covid_deaths cd
JOIN portfolio_project..Covid_vaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
--WHERE cd.continent IS NOT NULL

SELECT *, (people_vaccinated/population) * 100
FROM percentage_of_vaccinated_population



--****************************************
--****************************************
--****************************************
--CREATING VIEW TO STORE LATER FOR VISUALIZATIONS
CREATE VIEW percentOfVaccinated_population as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(CAST(cv.new_vaccinations as bigint)) OVER (PARTITION BY cd.location ORDER BY cd.location,
	cd.date) AS people_vaccinated
FROM portfolio_project..Covid_deaths cd
JOIN portfolio_project..Covid_vaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL



--****************************************
--****************************************
--****************************************
SELECT *
FROM percentOfVaccinated_population

