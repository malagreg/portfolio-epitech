--test pour les bdd

Select *
From [portfolioproject epitech]..covidDeaths
Where continent is not null
order by 3,4 ;

--Select *
--From [portfolioproject epitech]..covidVaccination
--order by 3,4 ;

--select les données que l'on va utiliser
Select Location , date, total_cases, new_cases, total_deaths, population
From [portfolioproject epitech]..covidDeaths
Where continent is not null
order by 1,2 ;

--nombre de cas contre nombre de mort
--proba de mourir si l'on contracte le covid('%pays%') (varchar to float)
SELECT Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / CONVERT(float, total_cases)) * 100 as DeathPercentage
FROM [portfolioproject epitech]..covidDeaths
WHERE location like '%france%'
and continent is not null
ORDER BY 1, 2;

--nombre de cas total  contre la population

--montre quel pourcentage de la population à contracté le covid 
SELECT Location, date, population, total_cases,  (CONVERT(float, total_cases) / CONVERT(float, population)) * 100 as popinfectedpercentage
FROM [portfolioproject epitech]..covidDeaths
WHERE location like '%france%'
ORDER BY 1, 2;

-- vue sur les pays avec le plus grand taux de d'infection sur l'ensemble de sa pop

SELECT Location, population, MAX(total_cases) as highestinfectionCount,  MAX((CONVERT(float, total_cases) / CONVERT(float, population)))* 100 as popinfectedpercentage
FROM [portfolioproject epitech]..covidDeaths
--WHERE location like '%france%'
Group by location, population
ORDER BY popinfectedpercentage desc ;


-- les pays avec les plus grand compte de mort par population "where continent is not ull" permet de mettre au claire les data 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolioproject epitech]..covidDeaths
--where location is like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc ;

-- montre les continents avec les plus grands nombres de morts
--  " remplace continent du select et du grou by par location " et "where is null"pour les bonne data 


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolioproject epitech]..covidDeaths
--where location is like '%states%'
Where continent is null
Group by location
order by TotalDeathCount desc;

-- diff between celle d'en haut et celle la 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolioproject epitech]..covidDeaths
--where location is like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc;


-- les nombres globeaux 

SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
COALESCE((SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(new_cases), 0)), 0) AS DeathPercentage
FROM [portfolioproject epitech]..covidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 ;

--taux de mortalité du covid  
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
COALESCE((SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(new_cases), 0)), 0) AS DeathPercentage
FROM [portfolioproject epitech]..covidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2;

 -- regard sur le total des vaccinationpar jour vs le totale de la population 
 
 SELECT dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location Order by dea.location , dea.date) as déroulépersonnevacciné
 FROM [portfolioproject epitech]..covidDeaths dea
 join [portfolioproject epitech]..covidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 ;


--marche pas mais belle essaie XD 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint, COALESCE(vac.new_vaccinations, 0))) OVER (PARTITION BY dea.location) AS Total_Vaccinations
FROM [portfolioproject epitech]..covidDeaths dea
JOIN [portfolioproject epitech]..covidVaccination vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;





with Popvsvac (continent, Location , Date , Population , New_Vaccinations , RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location Order by dea.location , dea.date)
 as déroulépersonnevacciné,
 FROM [portfolioproject epitech]..covidDeaths dea
 join [portfolioproject epitech]..covidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3 ;
)
Select *, (déroulépersonnevacciné/Population)*100
FROM Popvsvac





















