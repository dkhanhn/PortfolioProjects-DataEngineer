Select * from [Data Analyst Portfolio Project]..CovidDeaths
Where continent is not null
Order by location, date desc

-- Query data
Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by location, date


-- Total cases vs Total Deaths, Death percentage of Total case
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Data Analyst Portfolio Project]..CovidDeaths
--Where continent is not null and location like '%states'
Order by location, date


-- Tableau 4
-- Show Countries with Highest Infection Rate compared to Population
Select location, date, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From [Data Analyst Portfolio Project]..CovidDeaths
--Where continent is not null
Group by location, population, date
Order by PercentPopulationInfected desc


-- Tableau 3
-- Show Countries with Highest Infection Rate compared to Population
Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From [Data Analyst Portfolio Project]..CovidDeaths
Where continent is not null
Group by location, population
Order by PercentPopulationInfected desc


-- Show Countries with Highest Death Count per Population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Data Analyst Portfolio Project]..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

-- Tableau 2
-- Show Continent with Highest Death Count per Population
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Data Analyst Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Tableau 1
-- Global Number
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From [Data Analyst Portfolio Project]..CovidDeaths
Where continent is not null
Order by 1, 2





-- Use Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
-- Show Total Population vs Vaccination and Rolling Total of People Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Convert(bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Data Analyst Portfolio Project]..CovidDeaths dea
Inner Join [Data Analyst Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
	and dea.population is not null
Order by 1, 2 


Select *, (RollingPeopleVaccinated/Population)*100 as PercentofPeopleVaccinated
From #PercentPopulationVaccinated


--Create View to store data for later visualizations

--Drop View if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Convert(bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Data Analyst Portfolio Project]..CovidDeaths dea
Inner Join [Data Analyst Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
	and dea.population is not null
--Order by 1, 2 

Select *
From PercentPopulationVaccinated
