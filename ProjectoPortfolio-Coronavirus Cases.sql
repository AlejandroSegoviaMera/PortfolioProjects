Select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select the data that we are using


Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelyhood of dying if you contract coronavirus in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like '%Mexico%'
where continent is not null
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of populaiton got coronavirus

Select location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
from PortfolioProject..CovidDeaths
Where location like '%Mexico%'
where continent is not null
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%Mexico%'
where continent is not null
group by location, population
order by PercentPopulationInfected desc


-- Shwoing countries with the Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%Mexico%'
where continent is not null
group by location 
order by TotalDeathCount desc



-- Let's break down by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%Mexico%'
where continent is null
group by location
order by TotalDeathCount desc


-- Showing the continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%Mexico%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Let's check the global numbers

Select date, sum(total_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths
-- Where location like '%Mexico%'
where continent is not null
group by date
order by 1,2


Select sum(total_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths
-- Where location like '%Mexico%'
where continent is not null
order by 1,2



-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

 

 -- use CTE

with PopvsVac (Continent, Location, date, population, new_vaccionations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


-- TEMP TABLE