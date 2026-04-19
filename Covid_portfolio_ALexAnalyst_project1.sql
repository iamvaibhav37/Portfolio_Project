--SHow the likelihood of dying if you get covid.

--SELECT location, date, total_cases, total_deaths, (CAST (total_deaths AS FLOAT)/CAST (total_cases AS FLOAT))*100 AS death_rate
--FROM Portfolio_project..CovidDeaths_v2
--WHERE location like 'india'
--ORDER BY 1, 2


--Shows what percentage of population got the COVID
--(CREATE index idx_location
--ON Portfolio_project..CovidDeaths_v2(location);)

--SELECT location, date, total_cases, population, (CAST (total_cases AS FLOAT)/ population)*100 AS infected_rate
--FROM Portfolio_project..CovidDeaths_v2
--WHERE location = 'India'
--Order BY 1, 2


--Lets' look at the highest percentage infected for each country


--SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX(CAST (total_cases as FLOAT)/Population)*100 as InfectedRate
--FROM Portfolio_project..CovidDeaths_v2
--Group by location, population
--ORDER BY InfectedRate DESC


--lets look at highest death count per population

--SELECT Location,Population, MAX(total_deaths) as HighestDeathCount, MAX(CAST (total_deaths as FLOAT)/population)*100 as DeathRate
--FROM Portfolio_project..CovidDeaths_v2
--WHERE continent is not null
--GROUP BY location, population
--ORDER BY HighestDeathCount DESC


--looking a death count by continent
--SELECT continent, MAX(total_deaths) as HighestDeath
--FROM Portfolio_project..CovidDeaths_v2
--WHERE continent is not null
--GROUP BY continent
--ORDER BY HighestDeath DESC  
--(this querry is giving us the max of tottal death in a country in a continent, e.g. NorthAMerica here only shows about the US data)


--looking a death count by continent
--SELECT location, MAX(total_deaths) as HighestDeath
--FROM Portfolio_project..CovidDeaths_v2
--WHERE continent is null
--GROUP BY location
--ORDER BY HighestDeath DESC  
--(this query gives the total sum of total deaths by the continent i.e rows wheere location itself is the continent name.)



--Global Numbers
--SELECT date, SUM(new_deaths)
--FROM Portfolio_project..CovidDeaths_v2
--GROUP BY date
--ORDER BY date ASC


----JOINING THE TABLES
--SELECT *
--FROM Portfolio_project..CovidDeaths_v2 dea
--JOIN Portfolio_project..CovidVaccinations_v2 vac
--	ON dea.location = vac.location
--	and dea.date = vac.date 


--People in the world that got vaccinated 
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) as CumulativeVaccine
--FROM Portfolio_project..CovidDeaths_v2 dea
--JOIN Portfolio_project..CovidVaccinations_v2 vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null 
--ORDER BY 2,3 



--creating CTE - Common Table Expression; acts like a temporary table, where you can retrieve column names easily. 
WITH Pop_VAC (Continent, Location, Date, Population, New_vaccinantions, RollingVaccines)
as
(SELECT dea.continent,
	   dea.location,
	   dea.date,
	   dea.population, 
	   vac.new_vaccinations, 
	   SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingVaccines
FROM Portfolio_project..CovidDeaths_v2 dea
JOIN Portfolio_project..CovidVaccinations_v2 vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *,
	   (RollingVaccines/Population)*100 as VaccineRate
FROM Pop_VAC