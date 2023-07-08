
-- Working with the table CovidDeaths
-- Select data that will be used

select 
	continent,
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
from project..CovidDeaths
where continent is not null
order by 1,2,3 

-- Looking at the total cases vs total deaths
-- Showing the likelyhood of dying if you contract covid in the UK
select 
	continent,
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 as death_percentage
from project..CovidDeaths
where location like '%kingdom%'
order by 1,2

-- Looking at the total cases vs population
-- Showing what percentage of population in the UK got covid
select 
	continent,
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 as cases_percentage
from project..CovidDeaths
where location like '%kingdom%'
order by 1,2

-- Looking at countries with highest infection rate compared to population

select 
	continent,
	location,
	population,
	max(total_cases) as highest_infection_count,
	max(total_cases/population)*100 as percentage_pop_infected
from project..CovidDeaths
where continent is not null
group by continent, location, population
order by percentage_pop_infected desc

-- Showing the countries with the highest death count per population

select 
	continent,
	location,
	max(cast(total_deaths as int)) as highest_death_count
from project..CovidDeaths
where continent is not null
group by continent, location
order by highest_death_count desc

-- Breaking data down by continent
-- Showing the continents with highest death count per population

select
 continent,
 max(cast(total_deaths as int)) as highest_deaths_count
from project..CovidDeaths
where continent is not null
group by continent
order by highest_deaths_count desc

-- Global numbers

select 
	date,
	sum(new_cases) as total_cases,
	sum(cast(new_deaths as int)) as total_deaths,
	sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from project..CovidDeaths
where continent is not null
group by date
order by 1,2

select 
	sum(new_cases) as total_cases,
	sum(cast(new_deaths as int)) as total_deaths,
	sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from project..CovidDeaths
where continent is not null

-- Working with the table CovidVaccinations
-- Looking at total population vs vaccinations

select 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingcount_people_vac, 
	((sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date))/dea.population)*100 as total_percentage_vac
from project..CovidDeaths as dea
join project..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

-- Using CTE 

with temp_table as (
	select 
	dea.continent,
	dea.location,
	dea.population,
	dea.date,
	vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingcount_people_vac
from project..CovidDeaths as dea
join project..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select 
	*,
	(rollingcount_people_vac/population)*100 as total_percentage_vac
from temp_table

-- Using temp tables

create table percentpopvac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingcount_people_vac numeric
)
insert into percentpopvac
select 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingcount_people_vac
from project..CovidDeaths as dea
join project..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select 
	*,
	(rollingcount_people_vac/population)*100 as total_percentage_vac
from percentpopvac

-- Creating view to store data for later visualizations

create view percentpopvac2 as
select 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, 
	dea.date) as rollingcount_people_vac
from project..CovidDeaths as dea
join project..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from percentpopvac2



  


