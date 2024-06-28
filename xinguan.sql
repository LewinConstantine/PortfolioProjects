select *
from PortfllioProject..CovidDeathed
order by 3,4


--select *
--from PortfllioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfllioProject..CovidDeathed
order by 1,2


-- 总病例数和死亡总数
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfllioProject..CovidDeathed
where Location like '%china%'
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfllioProject..CovidDeathed
where location like '%china%'
order by 1,2

select Location,  date, total_cases, total_deaths, ((total_deaths+0.0)/(total_cases+0.0)*100) as DeathPercentage
from PortfllioProject..CovidDeathed
where Location like '%china%'
order by 1,2



--ALTER TABLE CovidDeathed
--ALTER COLUMN total_cases int;

select Location, date, total_cases, total_deaths
from PortfllioProject..CovidDeathed
where SUBSTRING(date,1,4) = '2020%'



select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfllioProject..CovidDeathed
-- where location like '%china%'
order by 1,2

-- 感染率最多的国家

select Location, population, MAX(total_cases)as highestInfectioncount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfllioProject..CovidDeathed
-- where location like '%china%'
group by Location, population
order by PercentPopulationInfected DESC


--delete 
--from PortfllioProject..CovidVaccinations
--where location like 'Taiwan' or location like 'Hong Kong'

-- Deathed num_of_people

select location, population, MAX(total_deaths)as HighestDeathToll, MAX((total_deaths/population))*100 as PercentagePopulationdeaths
from PortfllioProject..CovidDeathed
-- where location like '%china%'
group by location, population
order by PercentagePopulationdeaths Desc

select location, MAX(total_deaths) HighestDeathToll
from PortfllioProject..CovidDeathed
where continent is not null
group by location
order by HighestDeathToll desc



--- 根据 continent 分类

select continent, MAX(total_deaths) HighestDeathToll
from PortfllioProject..CovidDeathed
where continent is not null
group by continent
order by HighestDeathToll desc


-- Alter谨慎使用
--ALTER TABLE PortfllioProject..CovidDeathed
--ALTER COLUMN new_cases int;

select sum(new_cases)as sum_new_cases, sum(new_deaths)as sum_new_deaths
from PortfllioProject..CovidDeathed
where continent is not null
--group by date
order by 1,2




-- 总人口与接疫苗总数
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(Cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.Location, dea.date) as total_vaccinations
from PortfllioProject..CovidDeathed as dea
join PortfllioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


-- use the cte


with cte(continest, Location, date, population, new_vaccinations, Rolling_vaccinations) as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(Cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.Location, dea.date) as Rolling_vaccinations
from PortfllioProject..CovidDeathed as dea
join PortfllioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3
)
select *,(Rolling_vaccinations/3) / population*100
from cte



-- temp table
Drop table if exists #PercentPopulationvaccinated
create table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,	
Rolling_vaccinations numeric
)

insert into #PercentPopulationvaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(Cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.Location, dea.date) as Rolling_vaccinations
from PortfllioProject..CovidDeathed as dea
join PortfllioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3

select *,(Rolling_vaccinations/3) / population*100
from #PercentPopulationvaccinated




-- 创建可供可视化的是view
create view PercentPopulationvaccinated as 
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(Cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.Location, dea.date) as Rolling_vaccinations
from PortfllioProject..CovidDeathed as dea
join PortfllioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3



select *
from PercentPopulationvaccinated














