
-- Query to display the data we are starting with
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM githubproject.`ccovid-data`
Where continent is not null 
order by 1,2 ;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM githubproject.`ccovid-data`
WHERE continent is not null 
order by 1,2 ;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM githubproject.`ccovid-data`
order by 1,2;

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM githubproject.`ccovid-data`
Group by Location, Population
order by PercentPopulationInfected desc ; 

-- Countries with Highest Death Count per Population
SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM githubproject.`ccovid-data` 
Where continent is not null 
Group by Location
order by TotalDeathCount desc ;


-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM githubproject.`ccovid-data` 
Where continent is not null 
Group by continent
order by TotalDeathCount desc ; 

-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM githubproject.`ccovid-data` 
where continent is not null 
--Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select  death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From githubproject.`ccovid-data` AS death
Join githubproject.`vaccination` AS vacc
	On death.location = vacc.location
	and death.date = vacc.date
where  continent is not null 
order by 2,3;
 
-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From githubproject.`ccovid-data` death
Join githubproject.`vaccination` vacc
On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null 
