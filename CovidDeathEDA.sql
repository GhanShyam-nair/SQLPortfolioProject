--Select *
--From main_project .. CovidDeaths$
--order by 3,4

--Select *
--From main_project .. CovidVaccinations$
--order by 3,4
--SELECT lOCATION,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--From main_project..CovidDeaths$
--where location like'%ndia%'
--order by 1,2
-- Looking at the total cases vs population
--SELECT lOCATION,date,total_cases,total_deaths,population,(total_cases/population)*100 as PopulationPercentage
--From main_project..CovidDeaths$
--where location like'%ndia%'
--order by 1,2
 -- Countries with high infection rate 
 Select  location,population,MAX(total_cases)as peak_cases ,MAX((total_cases/population)*100) as peakRatio
 From main_project..CovidDeaths$
 Group by location,population
 order by peakRatio  desc

 -- Showing the global number 
Select SUM(new_cases) as total_cases,SUM(cast (new_deaths as int )) total_deaths , SUM(cast(new_deaths as int)) /SUM(New_cases)*100 as DeathPercentage
From main_project..CovidDeaths$
Where continent is not null
order by 1,2
-- Looking at total population 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From main_project..CovidDeaths$ dea
Join main_project..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From main_project..CovidDeaths$ dea
Join main_project..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as perpopvacc
From PopvsVac



DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From main_project..CovidDeaths$ dea
Join main_project..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where vac.new_vaccinations is not null 
--AND dea.continent is not null
order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
Where New_vaccinations is not null
and Continent is not null
and Location like '%state%'
order by 2,3