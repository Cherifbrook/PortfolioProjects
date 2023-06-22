Select*
from PortfolioProject..CovidDeath
where continent is not null
order by 3,4

Select*
from PortfolioProject..CovidVaccinations
order by 3,4

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..CovidDeath
where location like '%morocco%'
order by 1,2

Alter table Covidvaccinations
alter column new_vaccinations float

Exec sp_help 'coviddeath';


Select Location, date,population, total_cases,  (total_cases/population)* 100 as CasebyPopulation
from PortfolioProject..CovidDeath
where location like '%morocco%'
order by 1,2


--looking at countries with the hichest infection rate compared to the population

Select Location,population,max( total_cases) as HighestInfectioncount,  max((total_cases/population))* 100 as PercentPopulationInfected
from PortfolioProject..CovidDeath
Group by Location, Population
order by PercentPopulationInfected desc


--showing countries with the highest deathcount per Population

Select Location,max(total_deaths ) as TotalDeathCount
from PortfolioProject..CovidDeath

where continent is not null
Group by Location
order by TotalDeathCount desc

--let s break thigns down by continent 
Select continent ,max( total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeath

where continent is not null
Group by continent
order by TotalDeathCount desc

--showing continent with the highest death count per population

Select continent ,max( total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeath
where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers





	--looking at total population vs vaccination


--USE CTE

	With PopvsVac (Continent, location, date, population, new_vaccinations, Totalvaccination)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) Totalvaccination

from PortfolioProject..CovidVaccinations  vac
Join PortfolioProject..CovidDeath dea
on dea.location  = vac.location
and dea.date = vac.date

where dea.continent is not null
)
select*, (Totalvaccination/population)*100 RollingPopulationVaccinated
from PopvsVac



         --Temp table 
Drop table if exists #PercentagePopulationVaccinated
Create table #PercentagePopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPopulationVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) Totalvaccination

from PortfolioProject..CovidVaccinations  vac
Join PortfolioProject..CovidDeath dea
on dea.location  = vac.location
and dea.date = vac.date

where dea.continent is not null

select*, (RollingPopulationVaccinated/population)*100 
from #PercentagePopulationVaccinated



--creating view to store data for later viz




use PortfolioProject
go
create view testPercentagePopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) Totalvaccination

from PortfolioProject..CovidVaccinations  vac
Join PortfolioProject..CovidDeath dea
on dea.location  = vac.location
and dea.date = vac.date
where dea.continent is not null


Select*
from #PercentagePopulationVaccinated
