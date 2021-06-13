-- Covid_death Table

select * 
from covid_data..covid_death
order by 3,4

select location , date, population , new_cases, total_cases,new_deaths , total_deaths
from covid_data..covid_death
where continent != location
order by 1,2



--total cases vs population
--what percentage of peoples suffered from covid in Nepal
select location , date,population ,total_cases, (total_cases/population) * 100 as covid_contracted_percentage
from covid_data..covid_death
where location like '%nepal%' and continent != location  
order by 1,2

--looking at which country has major covid contracted percentage with respect to population
select location , max(total_cases) as highest_infection_count,population , max(total_cases/population) * 100 as covid_contracted_percentage
from covid_data..covid_death
where continent != location  
group by location, population
order by 4 desc

--looking at which country have highest number of covid infections
select location, population , max(cast(total_cases as int)) as TotalCases
from covid_data..covid_death
where continent != location  
group by location, population
order by 3 desc

--looking at which country have highest number of covid deaths
select location, population , max(cast(total_deaths as int)) as TotalDeaths
from covid_data..covid_death
where continent != location  
group by location, population
order by TotalDeaths desc

--looking at the most affected continent
select location ,max(cast(total_deaths as int)) as total_deaths
from covid_data..covid_death
where continent is null and total_deaths > 1105 and location != 'World'
group by location
order by total_deaths desc


--global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentageWorld
from covid_data..covid_death
where continent is not null
group by date
order by date


--Covid_Vaccination table
select * 
from covid_data..covid_vaccination

-- total_population vs people_vaccination_percentage
drop table if exists #total_vacc
SELECT *
INTO #total_vacc
FROM 
(select location, population, (max(cast(people_vaccinated as numeric)) over(partition by location)) as people_Vaccinated, 
(max(cast(people_fully_vaccinated as numeric)) over(partition by location)) as people_fully_Vaccinated,
 (max(cast(total_vaccinations as numeric)) over(partition by location)) as total_vaccinations,
max((people_vaccinated/population) * 100) as vaccinated_percentage,
max((people_fully_vaccinated/population) * 100) as fully_vaccinated_percentage,
max((total_vaccinations/population) * 100) as total_vaccinated_percentage
from covid_data..covid_vaccination
where continent != location  and people_vaccinated is not null
group by location, population, people_vaccinated,people_fully_vaccinated,total_vaccinations
) as total_vacc

select location, population , people_Vaccinated , people_fully_Vaccinated, total_vaccinations,max(vaccinated_percentage) as People_vaccinated_percent,
max(fully_vaccinated_percentage) as people_fully_vaccinated,
max(total_vaccinated_percentage) as total_vaccinated_percent
from #total_vacc
group by location , population, people_Vaccinated, people_fully_Vaccinated, total_vaccinations
order by 7 desc

--Atleast one vaccination in Nepal
select location, population , people_Vaccinated , people_fully_Vaccinated, total_vaccinations,max(vaccinated_percentage) as People_vaccinated_percent,
max(fully_vaccinated_percentage) as people_fully_vaccinated,
max(total_vaccinated_percentage) as total_vaccinated_percent
from #total_vacc
where location like '%Nepal%'
group by location , population, people_Vaccinated, people_fully_Vaccinated, total_vaccinations
order by location 






-- Used queries for visualization

-- total_cases vs total_deaths
-- likelihood of dying if you suffer from covid in Nepal
select location , date, total_cases,total_deaths , (total_deaths/total_cases) * 100 as death_percentage
from covid_data..covid_death
where location like '%nepal%' and continent != location  
order by 1,2

--looking at which country have highest number of covid deaths
select location, population , max(cast(total_deaths as int)) as TotalDeaths
from covid_data..covid_death
where continent != location  
group by location, population
order by TotalDeaths desc


--looking at the most affected continent
select location ,max(cast(total_deaths as int)) as total_deaths
from covid_data..covid_death
where continent is null and total_deaths > 1105 and location != 'World'
group by location
order by total_deaths desc

--global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentageWorld
from covid_data..covid_death
where continent is not null
group by date
order by date


--Atleast one vaccination in Nepal
select location, population , people_Vaccinated , people_fully_Vaccinated, total_vaccinations,max(vaccinated_percentage) as People_vaccinated_percent,
max(fully_vaccinated_percentage) as people_fully_vaccinated,
max(total_vaccinated_percentage) as total_vaccinated_percent
from #total_vacc
where location like '%Nepal%'
group by location , population, people_Vaccinated, people_fully_Vaccinated, total_vaccinations
order by location 



-- total_cases vs total_deaths
-- likelihood of dying if you suffer from covid

select * from covid_data..covid_death
select location ,date, max(cast(total_cases as int)) as Present_Case,max(cast(total_deaths as int)) as Death_Case , (max(total_deaths)/max(total_cases)) * 100 as Death_percentage
from covid_data..covid_death
where continent != location  
group by location,date
order by 1,2