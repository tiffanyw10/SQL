SELECT * FROM msm
WHERE hitcount > 17000
order by hitcount DESC

SELECT class,ark_dpm, hitcount from msm
order by hitcount desc


SELECT class,lotus_dpm, hitcount from msm
order by hitcount desc

SELECT 
	class,
    hitcount,
    MAX(ark_dpm) AS max_ark_dpm
from msm

SELECT 
	class,
    hitcount,
    min(ark_dpm) AS min_ark_dpm
from msm

SELECT class, mu_lung from msm
where floor = 45
order by mu_lung desc

select class, players from msm
order by players desc


select class, players, hitcount from msm
where hitcount > 16000
order by hitcount desc

select class, players from msm
where players > 100
