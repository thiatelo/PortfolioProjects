--select data that we are going to be using
SELECT Location, date, total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
order by 1,2

--looking at Total cases vs Total deaths
--showing likelihood of dying if you contract covid in your country


SELECT Location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location like '%negal%'

order by 1,2

--ALTER TABLE CovidDeaths
--ALTER COLUMN total_cases float;

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

SELECT Location, date,Population,total_cases, (total_cases/population)*100 as PopulationPercentageInfect
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'

order by 1,2

--Looking at countries with highest Infection Rate compare to Popolation



SELECT Location, Population,MAX(total_cases) as highestInfection, MAX((total_cases/population))*100 as PopulationPercentageInfect
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'
Group by population, Location

order by PopulationPercentageInfect desc


--Showing countries with Highest Death count per Popolation

SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'
WHERE continent is not NULL
Group by  Location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT 

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'
WHERE continent is not NULL
Group by  continent
order by TotalDeathCount desc


--Showing continent with Highest Death count per Popolation

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'
WHERE continent is not NULL
Group by  continent
order by TotalDeathCount desc

--GLOBAL NUMBER
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%negal%'
WHERE continent is not NULL

order by 1,2

--COVID VACCINATION
SELECT * 
FROM PortfolioProject..CovidVaccination

--Looking at total Population vs Vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations_smoothed_per_million
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinationted

CREATE TABLE #PercentPopulationVaccinationted
(
continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations_smoothed_per_million numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinationted
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations_smoothed_per_million,
SUM(CONVERT(int,vac.new_vaccinations_smoothed_per_million)) OVER ( Partition by dea.Location ,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from #PercentPopulationVaccinationted

--Creating view to store data  for visualution later

Create View PercentPopulationVaccinated1 as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations_smoothed_per_million,
SUM(CONVERT(int,vac.new_vaccinations_smoothed_per_million)) OVER ( Partition by dea.Location ,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3