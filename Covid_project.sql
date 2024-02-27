select *
from project..CovidDeaths
where continent is not null
order by 3,4

--select *
--from project..Vaccinations
--order by 3,4

--select data 

select location, date, total_cases, new_cases, total_deaths, population
from project..CovidDeaths
order by 1,2

-- Total cases vs total deaths --
-- shows death percentage from covid in Canada--
select 
	location, date, total_cases, total_deaths
	,(cast(total_deaths as float)/cast(total_cases as float))*100 as death_percentage
from project..CovidDeaths
where location like 'canada%' and continent is not null
order by 1,2

-- total cases vs population--

select 
	location, date, total_cases, population
	,(cast(total_cases as float)/population)*100 as percent_infected
from project..CovidDeaths
where continent is not null
order by 1,2


-- Countries with highest infection rate compared to population--

select 
	location
	,max(total_cases) as highest_count
	,population
	,(cast(max(total_cases) as float)/population)*100 as percent_infected
from project..CovidDeaths
where continent is not null
group by location, population
order by percent_infected desc

-- show total deaths by continent--

select 
	continent
	,sum(cast(new_deaths as int)) as death_count
from project..CovidDeaths
where continent is not null
group by continent
order by death_count desc

-- show total deaths by country--
select 
	location
	,sum(cast(new_deaths as int)) as death_count
from project..CovidDeaths
where continent is not null
group by location
order by death_count desc


-- global death and case count -- 
select 
	 max(cast(total_cases as int)) as total_cases
	 , max(cast(total_deaths as int)) as total_deaths
	 , max(cast(total_deaths as float))/max(cast(total_cases as float))*100 as death_percentage
from project..CovidDeaths
order by 1,2



--look at vaccinations count--

select 
    death.continent, death.location, death.date, death.population
    ,vax.new_vaccinations
    ,sum(cast(vax.new_vaccinations as bigint)) 
        over (partition by death.location 
              order by death.location, death.date) as rolling_vaccinations
from project..coviddeaths death
join project..vaccinations vax
    on death.location = vax.location 
    and death.date = vax.date 
where death.continent is not null
order by 2,3


--Temp Table--

drop table if exists #PercentPopulationVaccinated  --if need to modify 
create table #PercentPopulationVaccinated
(Continent nvarchar(255)
,Location nvarchar(255)
,Date datetime
,Population numeric 
, New_vaccinations numeric
,rolling_vaccinations numeric)

insert into #PercentPopulationVaccinated
select 
    death.continent, death.location, death.date, death.population
    ,vax.new_vaccinations
    ,sum(cast(vax.new_vaccinations as bigint)) 
        over (partition by death.location 
              order by death.location, death.date) as rolling_vaccinations
from project..coviddeaths death
join project..vaccinations vax
    on death.location = vax.location 
    and death.date = vax.date 
where death.continent is not null
select * , (rolling_vaccinations/Population)*100
from #PercentPopulationVaccinated


--create view to store data for visualization--

Create view PercentPopulationVax as
select 
    death.continent, death.location, death.date, death.population
    ,vax.new_vaccinations
    ,sum(cast(vax.new_vaccinations as bigint)) 
        over (partition by death.location 
              order by death.location, death.date) as rolling_vaccinations
from project..coviddeaths death
join project..vaccinations vax
    on death.location = vax.location 
    and death.date = vax.date 
where death.continent is not null

Select*
From PercentPopulationVaccinated
